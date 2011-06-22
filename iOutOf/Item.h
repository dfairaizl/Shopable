//
//  Item.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/21/11.
//  Copyright (c) 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, ShoppingCart;

@interface Item : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * userDefined;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * checkedOff;
@property (nonatomic, retain) Category * itemToCategory;
@property (nonatomic, retain) ShoppingCart * itemToShoppingCart;

@end
