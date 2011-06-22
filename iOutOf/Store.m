//
//  Store.m
//  iOutOf
//
//  Created by Dan Fairaizl on 6/19/11.
//  Copyright (c) 2011 Basically Bits, LLC. All rights reserved.
//

#import "Store.h"
#import "StoreCategory.h"


@implementation Store
@dynamic Name;
@dynamic Categories;

- (void)addCategoriesObject:(StoreCategory *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Categories" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Categories"] addObject:value];
    [self didChangeValueForKey:@"Categories" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeCategoriesObject:(StoreCategory *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Categories" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Categories"] removeObject:value];
    [self didChangeValueForKey:@"Categories" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addCategories:(NSSet *)value {    
    [self willChangeValueForKey:@"Categories" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Categories"] unionSet:value];
    [self didChangeValueForKey:@"Categories" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeCategories:(NSSet *)value {
    [self willChangeValueForKey:@"Categories" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Categories"] minusSet:value];
    [self didChangeValueForKey:@"Categories" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
