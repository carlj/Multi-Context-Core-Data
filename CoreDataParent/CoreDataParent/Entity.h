#import "_Entity.h"

@interface Entity : _Entity {}
// Custom logic goes here.
+ (id)entityWithName:(NSString *)name;
+ (id)entityWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;


@end
