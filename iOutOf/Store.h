//
//  Store.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright (c) 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, ShoppingCart;

@interface Store : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * selectedStore;
@property (nonatomic, retain) NSSet* categories;
@property (nonatomic, retain) ShoppingCart * shoppingCart;

@end
