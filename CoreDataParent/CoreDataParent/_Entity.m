// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Entity.m instead.

#import "_Entity.h"

const struct EntityAttributes EntityAttributes = {
	.created = @"created",
	.name = @"name",
	.updated = @"updated",
};

const struct EntityRelationships EntityRelationships = {
};

const struct EntityFetchedProperties EntityFetchedProperties = {
};

@implementation EntityID
@end

@implementation _Entity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Entity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:moc_];
}

- (EntityID*)objectID {
	return (EntityID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"createdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"created"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"updatedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"updated"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic created;



- (int32_t)createdValue {
	NSNumber *result = [self created];
	return [result intValue];
}

- (void)setCreatedValue:(int32_t)value_ {
	[self setCreated:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCreatedValue {
	NSNumber *result = [self primitiveCreated];
	return [result intValue];
}

- (void)setPrimitiveCreatedValue:(int32_t)value_ {
	[self setPrimitiveCreated:[NSNumber numberWithInt:value_]];
}





@dynamic name;






@dynamic updated;



- (int32_t)updatedValue {
	NSNumber *result = [self updated];
	return [result intValue];
}

- (void)setUpdatedValue:(int32_t)value_ {
	[self setUpdated:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveUpdatedValue {
	NSNumber *result = [self primitiveUpdated];
	return [result intValue];
}

- (void)setPrimitiveUpdatedValue:(int32_t)value_ {
	[self setPrimitiveUpdated:[NSNumber numberWithInt:value_]];
}










@end
