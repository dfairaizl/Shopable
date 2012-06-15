//
//  BBList.h
//  Shopable
//
//  Created by Daniel Fairaizl on 6/15/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBShoppingCart;

@interface BBList : NSManagedObject

@property (nonatomic, retain) NSNumber * currentlyShopping;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) BBShoppingCart *shoppingCart;

@end
