//
//  BBShoppingCart+Logic.m
//  iOutOf
//
//  Created by Dan Fairaizl on 1/16/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBShoppingCart+Logic.h"
#import "BBStorageManager.h"

@implementation BBShoppingCart (Logic)

- (void)addItemToCart:(BBItem *)item {
    
    [self addCartItemsObject:item];
    
    item.itemCategoryName = item.parentItemCategory.name;
}

- (void)removeItemFromCart:(BBItem *)item {
    
    [self removeCartItemsObject:item];
}

- (BOOL)containsItem:(BBItem *)item {
    
    return [self.cartItems containsObject:item];
}

@end
