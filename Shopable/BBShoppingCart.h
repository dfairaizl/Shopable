//
//  BBShoppingCart.h
//  Shopable
//
//  Created by Dan Fairaizl on 2/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBShoppingItem, BBStore;

@interface BBShoppingCart : NSManagedObject

@property (nonatomic, retain) NSSet *cartItems;
@property (nonatomic, retain) BBStore *parentStore;
@end

@interface BBShoppingCart (CoreDataGeneratedAccessors)

- (void)addCartItemsObject:(BBShoppingItem *)value;
- (void)removeCartItemsObject:(BBShoppingItem *)value;
- (void)addCartItems:(NSSet *)values;
- (void)removeCartItems:(NSSet *)values;

@end
