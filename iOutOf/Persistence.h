//
//  Persistence.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/19/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Store.h"
#import "Category.h"
#import "Item.h"
#import "ShoppingCart.h"

//Entity Macros
#define kStore      @"Store"
#define kCategory   @"Category"
#define kItem       @"Item"

//Core Data Categories
@interface Store (CategoryAccessors)
- (void)addCategoriesObject:(Category *)value;
- (void)removeCategoriesObject:(Category *)value;
- (void)addCategories:(NSSet *)value;
- (void)removeCategories:(NSSet *)value;
@end

@interface Category (ItemAccessors)
- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;
@end

@interface ShoppingCart (CartItemsAccessors)
- (void)addCartItemsObject:(Item *)value;
- (void)removeCartItemsObject:(Item *)value;
- (void)addCartItems:(NSSet *)value;
- (void)removeCartItems:(NSSet *)value;
@end

@interface Persistence : NSObject {
    
}

//Operations
+ (void) save;

//Inserting
+ (id) entityOfType:(NSString *)entity;

//Fetching
+ (NSArray *) fetchEntites:(NSString *)entity withPredicate:(NSPredicate *)predicate andSortBy:(NSString *)sortBy ascending:(BOOL)ascending;
+ (NSArray *) fetchEntitiesOfType:(NSString *)entity withPredicate:(NSPredicate *)predicate;
+ (NSArray *) fetchAllEntitiesOfType:(NSString *)entity sortBy:(NSString *)sort;

@end
