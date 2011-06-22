//
//  Store.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/19/11.
//  Copyright (c) 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StoreCategory;

@interface Store : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSSet* Categories;

@end
