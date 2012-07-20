//
//  ModelDelegate.h
//  Dart
//
//  Created by Carl Jahn on 23.01.12.
//  Copyright (c) 2012 NIDAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Singelton.h"

typedef void(^PerformBlock)(void);


@interface ModelFactory : NSObject

SingletonInterface(ModelFactory);

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *writeManagedObjectContext;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;



- (NSManagedObjectContext *)newPrivateManagedObjectContext;

- (void)saveWriteContext;
- (void)saveMainContext;
- (void)saveContext:(NSManagedObjectContext *)context;
- (void)writeToDisk;
- (void)performBlock:(PerformBlock)block target:(id)target async:(BOOL)async;

@end
