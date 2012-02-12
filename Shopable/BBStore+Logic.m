//
//  BBStore+Logic.m
//  Shopable
//
//  Created by Dan Fairaizl on 1/16/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStore+Logic.h"

#import "BBStorageManager.h"

@implementation BBStore (Logic)

+ (NSArray *)stores {
    
    NSArray *stores = nil;
    NSError *error = nil;
    
    NSFetchRequest *storesFR = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_STORE];
    
    [storesFR setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    
    stores = [ [[BBStorageManager sharedManager] managedObjectContext] executeFetchRequest:storesFR error:&error];
    
    if(error != nil) {
        
        NSLog(@"Error fetching stores!");
    }
    
    return stores;
}

+ (BBStore *)addStore {
    
    BBStore *newStore = [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_STORE inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
    
    NSError *error = nil;
    
    NSFetchRequest *storesFR = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_STORE];
    
    [storesFR setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    
    NSInteger storesCount = [[[BBStorageManager sharedManager] managedObjectContext] countForFetchRequest:storesFR error:&error];
    
    if(error != nil) {
        
        NSLog(@"Error fetching stores!");
    }
    
    newStore.order = [NSNumber numberWithInt:storesCount - 1];
    
    return newStore;
}

- (BBShoppingCart *)currentShoppingCart {
    
    BBShoppingCart *cart = self.shoppingCart;
    
    if(cart == nil) {
        
        cart = [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_SHOPPING_CART inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
        cart.parentStore = self;
    }
    
    return cart;
}

@end
