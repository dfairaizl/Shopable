//
//  BBStore+Logic.m
//  iOutOf
//
//  Created by Dan Fairaizl on 1/16/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStore+Logic.h"

#import "BBStorageManager.h"

@implementation BBStore (Logic)

- (BBShoppingCart *)currentShoppingCart {
    
    BBShoppingCart *cart = self.shoppingCart;
    
    if(cart == nil) {
        
        cart = [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_SHOPPING_CART inManagedObjectContext:self.managedObjectContext];
        cart.parentStore = self;
    }
    
    return cart;
}

@end
