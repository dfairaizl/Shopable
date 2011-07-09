//
//  ShoppingCategory.h
//  iOutOf
//
//  Created by Dan Fairaizl on 7/8/11.
//  Copyright (c) 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Store;

@interface ShoppingCategory : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Store *categoryToStore;
@property (nonatomic, retain) NSSet *items;
@end

@interface ShoppingCategory (CoreDataGeneratedAccessors)
- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end
