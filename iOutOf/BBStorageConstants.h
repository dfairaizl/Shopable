//
//  BBStorageConstants.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#ifndef iOutOf_BBStorageConstants_h
#define iOutOf_BBStorageConstants_h

//Entities
#import "BBStore.h"
#import "BBItemCategory.h"
#import "BBItem.h"

//Categories
#import "BBStore+Logic.h"
#import "BBShoppingCart+Logic.h"

#define     BB_ENTITY_STORE             @"BBStore"
#define     BB_ENTITY_ITEM_CATEGORY     @"BBItemCategory"
#define     BB_ENTITY_ITEM              @"BBItem"
#define     BB_ENTITY_SHOPPING_CART     @"BBShoppingCart"

typedef enum {
    bbStoreTypeDepartment = 0,
    bbStoreTypeGrocery = 1,
    bbStoreTypeOther,
} BBType;

#endif
