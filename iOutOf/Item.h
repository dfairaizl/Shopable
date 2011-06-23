//
//  Item.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/22/11.
//  Copyright (c) 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, ShoppingCart;

@interface Item : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * checkedOff;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * userDefined;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) Category * itemToCategory;
@property (nonatomic, retain) ShoppingCart * itemToShoppingCart;

@end
