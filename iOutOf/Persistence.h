//
//  Persistence.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/19/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Store.h"
#import "StoreCategory.h"
#import "Item.h"
#import "ShoppingCart.h"

//Entity Macros
#define kStore      @"Store"
#define kCategory   @"StoreCategory"
#define kItem       @"Item"

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
