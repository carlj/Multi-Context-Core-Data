// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Entity.h instead.

#import <CoreData/CoreData.h>


extern const struct EntityAttributes {
	 NSString *created;
	 NSString *name;
	 NSString *updated;
} EntityAttributes;

extern const struct EntityRelationships {
} EntityRelationships;

extern const struct EntityFetchedProperties {
} EntityFetchedProperties;






@interface EntityID : NSManagedObjectID {}
@end

@interface _Entity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (EntityID*)objectID;




@property (nonatomic, retain) NSNumber *created;


@property int32_t createdValue;
- (int32_t)createdValue;
- (void)setCreatedValue:(int32_t)value_;

//- (BOOL)validateCreated:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *updated;


@property int32_t updatedValue;
- (int32_t)updatedValue;
- (void)setUpdatedValue:(int32_t)value_;

//- (BOOL)validateUpdated:(id*)value_ error:(NSError**)error_;






@end

@interface _Entity (CoreDataGeneratedAccessors)

@end

@interface _Entity (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber *)primitiveCreated;
- (void)setPrimitiveCreated:(NSNumber *)value;

- (int32_t)primitiveCreatedValue;
- (void)setPrimitiveCreatedValue:(int32_t)value_;




- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;




- (NSNumber *)primitiveUpdated;
- (void)setPrimitiveUpdated:(NSNumber *)value;

- (int32_t)primitiveUpdatedValue;
- (void)setPrimitiveUpdatedValue:(int32_t)value_;




@end
