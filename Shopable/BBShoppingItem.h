//
//  BBShoppingItem.h
//  Shopable
//
//  Created by Dan Fairaizl on 2/19/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBItem, BBShoppingCart;

@interface BBShoppingItem : NSManagedObject

@property (nonatomic, retain) NSNumber * checkedOff;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * itemCategoryName;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSString * units;
@property (nonatomic, retain) BBItem *item;
@property (nonatomic, retain) BBShoppingCart *parentShoppingCart;

@end
