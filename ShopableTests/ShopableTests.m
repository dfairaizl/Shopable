//
//  ShopableTests.m
//  ShopableTests
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "ShopableTests.h"

#import "BBStorageManager.h"

@implementation ShopableTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testStoreExists
{
    STAssertTrue([[BBStorageManager sharedManager] storeExists] == YES, @"Database exists");
}

- (void)testDefaultStores
{
    NSArray *stores = [BBStore stores];
    
    STAssertTrue([stores count] == 2, @"Two stores exist by default");
    
    //grocery store
    BBStore *groceryStore = [stores objectAtIndex:0];

    STAssertTrue([groceryStore.name isEqualToString:@"Grocery Store"], @"Grocery store name");
    STAssertTrue([groceryStore.order intValue] == 0 , @"Grocery store is first in display order");
    STAssertTrue([groceryStore.type intValue] == bbStoreTypeGrocery, @"Grocery store is of correct type");
}

@end
