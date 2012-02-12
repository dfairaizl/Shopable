//
//  ShopableTests.m
//  ShopableTests
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

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

- (void)testDefaultStore
{
    NSArray *stores = [BBStore stores];
    
    STAssertTrue([stores count] == 1, @"One store exists by default");
    
    //grocery store
    BBStore *groceryStore = [stores objectAtIndex:0];

    STAssertTrue([groceryStore.name isEqualToString:@"Grocery Store"], @"Grocery store name");
    STAssertTrue([groceryStore.order intValue] == 0 , @"Grocery store is first in display order");
    STAssertTrue([groceryStore.type intValue] == bbStoreTypeGrocery, @"Grocery store is of correct type");
}

- (void)testDefaultShoppingCart {
    
    NSError *error = nil;
    BBStore *groceryStore = [[BBStore stores] lastObject];
    
    //create a shopping cart for this store
    STAssertTrue([groceryStore currentShoppingCart] != nil, @"Grocery store has a valid shopping cart");
    
    //Add all items in the 'Dairy' category to the current shopping cart
    NSFetchRequest *itemsFR = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_ITEM];
    [itemsFR setPredicate:[NSPredicate predicateWithFormat:@"parentItemCategory.name == %@", @"Dairy"]];
    NSArray *items = [[[BBStorageManager sharedManager] managedObjectContext] executeFetchRequest:itemsFR error:&error];
    
    STAssertTrue(error == nil, @"Properly fetch all 'Dairy' items");
    
    //Add all items in the 'Dairy' category to the current shopping cart
    for(BBItem *item in items) {
        
        BBShoppingItem *shoppingItem = [[groceryStore currentShoppingCart] addItemToCart:item];
        
        STAssertTrue(shoppingItem.item == item, @"BBShoppingItem properly created from BBItem");
    }
    
    BBShoppingCart *currentShoppingCart = [groceryStore currentShoppingCart];
    
    STAssertTrue([currentShoppingCart.cartItems count] == [items count], @"Items in cart equal items in 'Dairy Category'");
}

@end
