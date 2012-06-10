//
//  BBStorageConstants.h
//  Shopable
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#ifndef Shopable_BBStorageConstants_h
#define Shopable_BBStorageConstants_h

//Entities
#import "BBList.h"
#import "BBItemCategory.h"
#import "BBItem.h"
#import "BBShoppingCart.h"
#import "BBShoppingItem.h"

//Categories
#import "BBList+Logic.h"
#import "BBItem+Logic.h"
#import "BBShoppingCart+Logic.h"

#define     BB_ENTITY_LIST              @"BBList"
#define     BB_ENTITY_ITEM_CATEGORY     @"BBItemCategory"
#define     BB_ENTITY_ITEM              @"BBItem"
#define     BB_ENTITY_SHOPPING_CART     @"BBShoppingCart"
#define     BB_ENTITY_SHOPPING_ITEM     @"BBShoppingItem"

typedef enum {
    bbStoreTypeDepartment = 0,
    bbStoreTypeGrocery = 1,
    bbStoreTypeOther,
} BBType;

#endif
