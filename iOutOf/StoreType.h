//
//  StoreType.h
//  iOutOf
//
//  Created by Dan Fairaizl on 7/8/11.
//  Copyright (c) 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Store;

@interface StoreType : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Store *typeOfStore;

@end
