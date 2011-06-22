//
//  ShoppingCart.m
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright (c) 2011 Basically Bits, LLC. All rights reserved.
//

#import "ShoppingCart.h"
#import "Item.h"
#import "Store.h"


@implementation ShoppingCart
@dynamic shoppingCartToStore;
@dynamic cartItems;


- (void)addCartItemsObject:(Item *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"cartItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"cartItems"] addObject:value];
    [self didChangeValueForKey:@"cartItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeCartItemsObject:(Item *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"cartItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"cartItems"] removeObject:value];
    [self didChangeValueForKey:@"cartItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addCartItems:(NSSet *)value {    
    [self willChangeValueForKey:@"cartItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"cartItems"] unionSet:value];
    [self didChangeValueForKey:@"cartItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeCartItems:(NSSet *)value {
    [self willChangeValueForKey:@"cartItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"cartItems"] minusSet:value];
    [self didChangeValueForKey:@"cartItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
