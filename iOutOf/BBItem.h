//
//  BBItem.h
//  iOutOf
//
//  Created by Dan Fairaizl on 2/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBItemCategory, BBShoppingItem;

@interface BBItem : NSManagedObject

@property (nonatomic, retain) NSNumber * isCustom;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) BBItemCategory *parentItemCategory;
@property (nonatomic, retain) NSSet *shoppingItems;
@end

@interface BBItem (CoreDataGeneratedAccessors)

- (void)addShoppingItemsObject:(BBShoppingItem *)value;
- (void)removeShoppingItemsObject:(BBShoppingItem *)value;
- (void)addShoppingItems:(NSSet *)values;
- (void)removeShoppingItems:(NSSet *)values;

@end
