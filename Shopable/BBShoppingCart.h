//
//  BBShoppingCart.h
//  Shopable
//
//  Created by Dan Fairaizl on 3/25/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBShoppingItem, BBList;

@interface BBShoppingCart : NSManagedObject

@property (nonatomic, retain) NSSet *cartItems;
@property (nonatomic, retain) BBList *parentStore;
@end

@interface BBShoppingCart (CoreDataGeneratedAccessors)

- (void)addCartItemsObject:(BBShoppingItem *)value;
- (void)removeCartItemsObject:(BBShoppingItem *)value;
- (void)addCartItems:(NSSet *)values;
- (void)removeCartItems:(NSSet *)values;

@end
