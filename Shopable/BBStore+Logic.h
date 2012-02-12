//
//  BBStore+Logic.h
//  Shopable
//
//  Created by Dan Fairaizl on 1/16/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStore.h"

@interface BBStore (Logic)

+ (NSArray *)stores;
+ (BBStore *)addStore;

- (BBShoppingCart *)currentShoppingCart;

@end
