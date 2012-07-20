#import "Entity.h"
#import "ModelFactory.h"

@implementation Entity

// Custom logic goes here.



+ (id)entityWithName:(NSString *)name {
  
  NSManagedObjectContext *moc = [[ModelFactory sharedInstance] mainManagedObjectContext];
  
  return [self entityWithName:name inContext:moc];
}

+ (id)entityWithName:(NSString *)name inContext:(NSManagedObjectContext *)context {
  Entity *entity = [Entity insertInManagedObjectContext: context];
  entity.name =name;
  
  NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
  int32_t interval = (int32_t)timeInterval;

  [entity setCreatedValue: interval];
  [entity setUpdatedValue: interval];

  return entity;
}



@end
