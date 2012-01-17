//
//  BBItemCategory.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/16/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBItem;

@interface BBItemCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet *items;
@end

@interface BBItemCategory (CoreDataGeneratedAccessors)

- (void)addItemsObject:(BBItem *)value;
- (void)removeItemsObject:(BBItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
