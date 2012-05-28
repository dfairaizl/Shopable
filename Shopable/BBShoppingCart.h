//
//  BBShoppingCart.h
//  Shopable
//
//  Created by Dan Fairaizl on 5/28/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBList, BBShoppingItem;

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
