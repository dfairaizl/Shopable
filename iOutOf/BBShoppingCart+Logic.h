//
//  BBShoppingCart+Logic.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/16/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBShoppingCart.h"

@interface BBShoppingCart (Logic)

- (void)addItemToCart:(BBItem *)item;
- (void)removeItemFromCart:(BBItem *)item;
- (BOOL)containsItem:(BBItem *)item;

@end
