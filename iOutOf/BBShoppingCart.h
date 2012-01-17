//
//  BBShoppingCart.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/16/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBItem, BBStore;

@interface BBShoppingCart : NSManagedObject

@property (nonatomic, retain) BBStore *parentStore;
@property (nonatomic, retain) NSSet *cartItems;
@end

@interface BBShoppingCart (CoreDataGeneratedAccessors)

- (void)addCartItemsObject:(BBItem *)value;
- (void)removeCartItemsObject:(BBItem *)value;
- (void)addCartItems:(NSSet *)values;
- (void)removeCartItems:(NSSet *)values;

@end
