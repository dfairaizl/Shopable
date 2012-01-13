//
//  BBItem.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/12/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBItemCategory;

@interface BBItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) BBItemCategory *parentItemCategory;

@end
