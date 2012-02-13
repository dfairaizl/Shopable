//
//  BBShoppingCart+Logic.h
//  Shopable
//
//  Created by Dan Fairaizl on 1/16/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBShoppingCart.h"

@class BBItem;

@interface BBShoppingCart (Logic)

- (BBShoppingItem *)addItemToCart:(BBItem *)item;
- (void)addUncategorizedItem:(BBItem *)newItem;
- (void)removeItemFromCart:(BBShoppingItem *)item;
- (BOOL)containsItem:(BBShoppingItem *)item;

- (BBShoppingItem *)shoppingItemForItem:(BBItem *)item createIfNotPresent:(BOOL)create;
- (BOOL)containsShoppingItemForItem:(BBItem *)item;

@end
