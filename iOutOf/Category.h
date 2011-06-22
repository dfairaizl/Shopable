//
//  Category.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright (c) 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Store;

@interface Category : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Store * categoryToStore;
@property (nonatomic, retain) NSSet* items;

@end
