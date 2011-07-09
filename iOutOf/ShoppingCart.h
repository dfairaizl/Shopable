//
//  ShoppingCart.h
//  iOutOf
//
//  Created by Dan Fairaizl on 7/8/11.
//  Copyright (c) 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Store;

@interface ShoppingCart : NSManagedObject {
@private
}
@property (nonatomic, retain) NSSet *cartItems;
@property (nonatomic, retain) Store *shoppingCartToStore;
@end

@interface ShoppingCart (CoreDataGeneratedAccessors)
- (void)addCartItemsObject:(Item *)value;
- (void)removeCartItemsObject:(Item *)value;
- (void)addCartItems:(NSSet *)value;
- (void)removeCartItems:(NSSet *)value;

@end
