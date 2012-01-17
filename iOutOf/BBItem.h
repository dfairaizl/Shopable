//
//  BBItem.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/17/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBItemCategory, BBShoppingCart;

@interface BBItem : NSManagedObject

@property (nonatomic, retain) NSNumber * checkedOff;
@property (nonatomic, retain) NSString * itemCategoryName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSString * units;
@property (nonatomic, retain) NSNumber * isCustom;
@property (nonatomic, retain) BBItemCategory *parentItemCategory;
@property (nonatomic, retain) BBShoppingCart *parentShoppingCart;

@end
