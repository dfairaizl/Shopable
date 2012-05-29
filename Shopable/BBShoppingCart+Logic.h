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

- (BOOL)containsItem:(BBItem *)item;
- (void)addItem:(BBItem *)item; 
- (void)removeItem:(BBItem *)item;
- (void)removeShoppingItem:(BBShoppingItem *)shoppingItem;

@end
