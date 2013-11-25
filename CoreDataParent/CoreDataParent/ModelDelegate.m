//
//  QModelDelegate.m
//  qontact
//
//  Created by Carl Jahn on 18.06.12.
//  Copyright (c) 2012 NIDAG. All rights reserved.
//

#import "ModelDelegate.h"
#import "ModelFactory.h"
#import <CoreData/CoreData.h>
#import "Entity.h"

//#define DSLog(format, ...) NSLog(format, ## __VA_ARGS__)
#define DSLog(format, ...)

@implementation ModelDelegate

SingletonImplementation(ModelDelegate);

- (id)init {
  self = [super init];
  
  if (self) {
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(willSave:)
                                                 name: NSManagedObjectContextWillSaveNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didSave:)
                                                 name: NSManagedObjectContextDidSaveNotification
                                               object: nil];
    
  }
  
  return self;
}

- (void)didSave:(NSNotification *)notification {
  DSLog(@"%s", __FUNCTION__);
  
  
  NSManagedObjectContext *saveContext = notification.object;
  NSManagedObjectContext *writeContext = [ModelFactory sharedInstance].writeManagedObjectContext;
  //NSManagedObjectContext *mainContext = [ModelFactory sharedInstance].mainManagedObjectContext;
  
  if (writeContext == saveContext) {
    NSLog(@"save write context");
    return;
  }
  
  /*
  if (mainContext == saveContext) {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue,^{
      NSLog(@"merge main context to write context");
      [writeContext mergeChangesFromContextDidSaveNotification: notification];
    });

    return;
  }
  */
  
  if (saveContext.persistentStoreCoordinator && ( writeContext.persistentStoreCoordinator != saveContext.persistentStoreCoordinator )) {
    return;
  }
  
  

  /*
  dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"merge private to main context");
    [mainContext mergeChangesFromContextDidSaveNotification: notification];
  });
  */
  
  [saveContext performBlockAndWait:^{
    [saveContext.parentContext performBlockAndWait:^{
      [saveContext.parentContext mergeChangesFromContextDidSaveNotification:notification];
    }];
  }];
}

- (void)willSave:(NSNotification *)notification {
  
  DSLog(@"%s", __FUNCTION__);
  
  NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
  int32_t interval = (int32_t)timeInterval;
  
  NSManagedObjectContext *context = notification.object;
  
  for (NSManagedObject *c in context.updatedObjects) {
    if ([ c isKindOfClass:[Entity class] ]) {
      Entity *s = (Entity *)c;
      [s setUpdatedValue: interval];
    }
  }
  
}


- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver: self];
  [super dealloc];
}

@end
