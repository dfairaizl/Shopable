//
//  BBStore.h
//  iOutOf
//
//  Created by Dan Fairaizl on 2/7/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBShoppingCart;

@interface BBStore : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * currentlyShopping;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) BBShoppingCart *shoppingCart;

@end
