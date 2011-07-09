//
//  Store.h
//  iOutOf
//
//  Created by Dan Fairaizl on 7/8/11.
//  Copyright (c) 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ShoppingCart, StoreCategory, StoreType;

@interface Store : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * selectedStore;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) ShoppingCart *shoppingCart;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) StoreType *type;
@end

@interface Store (CoreDataGeneratedAccessors)
- (void)addCategoriesObject:(StoreCategory *)value;
- (void)removeCategoriesObject:(StoreCategory *)value;
- (void)addCategories:(NSSet *)value;
- (void)removeCategories:(NSSet *)value;

@end
