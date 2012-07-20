//
//  ModelDelegate.m
//  Dart
//
//  Created by Carl Jahn on 23.01.12.
//  Copyright (c) 2012 NIDAG. All rights reserved.
//

#import "ModelFactory.h"
#import "ModelDelegate.h"

@interface ModelFactory ()

- (NSURL *)applicationDocumentsDirectory;
@property (nonatomic, retain) ModelDelegate *modelDelegate;

@end

@implementation ModelFactory
@synthesize modelDelegate = _modelDelegate;
@synthesize mainManagedObjectContext = _mainManagedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize writeManagedObjectContext = _writeManagedObjectContext;

SingletonImplementation(ModelFactory);


- (id)init {
  self = [super init];
  if (self) {
    _modelDelegate = [[ModelDelegate sharedInstance] retain];
  }
  
  return self;
}

- (void)dealloc
{
  NSLog(@"%s", __FUNCTION__);
  [_modelDelegate release];
  [_writeManagedObjectContext release];
  [_mainManagedObjectContext release];
  [_persistentStoreCoordinator release];
  [_managedObjectModel release];
  [super dealloc];
}

#pragma mark - 
#pragma mark - Core Data Methods

- (void)writeToDisk {
  
  NSManagedObjectContext *writeManagedObjectContext = self.writeManagedObjectContext;
  NSManagedObjectContext *mainManagedObjectContext = self.mainManagedObjectContext;

  [mainManagedObjectContext performBlock:^{
    NSError *error = nil;
    if ([mainManagedObjectContext hasChanges] && ![mainManagedObjectContext save:&error])
    {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    [writeManagedObjectContext performBlock:^{
      NSError *error = nil;
      if ([writeManagedObjectContext hasChanges] && ![writeManagedObjectContext save:&error])
      {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      }
    }];
    
  }];

}

- (void)performBlock:(PerformBlock)block target:(id)target async:(BOOL)async {
  
  if (async) {
    [target performBlock: block];
  } else {
    [target performBlockAndWait:block];
  }
  
}


- (void)saveWriteContext
{
  NSManagedObjectContext *managedObjectContext = self.writeManagedObjectContext;
  [self saveContext: managedObjectContext];
}


- (void)saveMainContext
{
  NSManagedObjectContext *managedObjectContext = self.mainManagedObjectContext;
  [self saveContext: managedObjectContext];
}

- (void)saveContext:(NSManagedObjectContext *)context
{
  //You need the performBlock to execute the save on the Context Queue
  [self performBlock:^{
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error])
    {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
    
  }          target:context 
              async:YES];
  
  
  /*
  [context performBlock:^{
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error])
    {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
    
  }];
  */
}

#pragma mark - Core Data stack
- (NSManagedObjectContext *)newPrivateManagedObjectContext {
  
  
  NSManagedObjectContext *privateManagedObjectContext;
  
  
  privateManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
  [privateManagedObjectContext setParentContext: self.mainManagedObjectContext];
  [privateManagedObjectContext setUndoManager: nil];
  return [privateManagedObjectContext autorelease];
  
}


- (NSManagedObjectContext *)writeManagedObjectContext {
  
  @synchronized(self) {
    if (_writeManagedObjectContext != nil)
    {
      return _writeManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {  
      _writeManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
      [_writeManagedObjectContext setUndoManager: nil];
      [_writeManagedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _writeManagedObjectContext;
  }
}
/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)mainManagedObjectContext
{
  
  @synchronized(self) {
    if (_mainManagedObjectContext != nil)
    {
      return _mainManagedObjectContext;
    }
    
    _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_mainManagedObjectContext setParentContext: self.writeManagedObjectContext];
    
    return _mainManagedObjectContext;
  }
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
  
  @synchronized(self) {
    if (_managedObjectModel != nil)
    {
      return _managedObjectModel;
    }
    
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource: @"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
  }
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  
  @synchronized(self) {
    if (_persistentStoreCoordinator != nil)
    {
      return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [ [self applicationDocumentsDirectory] URLByAppendingPathComponent: @"Model.sqlite" ];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
      
      //Alten Store removen und nochmal versuchen zu connecten
      [[NSFileManager defaultManager] removeItemAtURL: storeURL error: nil];
      if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration: nil URL: storeURL options: nil error: &error])
      {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
      } 
    }
    
    
    // Encryption
    NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
    if (![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:[storeURL path] error:&error]) {
      //Handle Error
      NSLog(@"error");
    }
    return _persistentStoreCoordinator;
  }
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
