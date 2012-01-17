//
//  BBItem.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/16/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBItemCategory, BBShoppingCart;

@interface BBItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * itemCategoryName;
@property (nonatomic, retain) NSNumber * checkedOff;
@property (nonatomic, retain) BBItemCategory *parentItemCategory;
@property (nonatomic, retain) BBShoppingCart *parentShoppingCart;

@end
