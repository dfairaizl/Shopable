//
//  BBItemImage.h
//  Shopable
//
//  Created by Daniel Fairaizl on 6/15/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBShoppingItem;

@interface BBItemImage : NSManagedObject

@property (nonatomic, retain) NSData * itemImage;
@property (nonatomic, retain) BBShoppingItem *shoppingItem;

@end
