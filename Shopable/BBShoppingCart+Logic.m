//
//  BBShoppingCart+Logic.m
//  Shopable
//
//  Created by Dan Fairaizl on 1/16/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBShoppingCart+Logic.h"
#import "BBStorageManager.h"

@implementation BBShoppingCart (Logic)

- (BOOL)containsItem:(BBItem *)item {
 
    __block BOOL itemFound = NO;
    
    [self.cartItems enumerateObjectsUsingBlock:^(BBShoppingItem *shoppingItem, BOOL *stop) {
       
        if(shoppingItem.item == item) {
            
            itemFound = YES;
            *stop = YES;
        }
    }];
    
    return itemFound;
}

- (BBShoppingItem *)shoppingItemForItem:(BBItem *)item {

    __block BBShoppingItem *foundShoppingItem = nil;
    
    [self.cartItems enumerateObjectsUsingBlock:^(BBShoppingItem *shoppingItem, BOOL *stop) {
        
        if(shoppingItem.item == item) {
            
            foundShoppingItem = shoppingItem;
            
            *stop = YES;
        }
    }];
    
    return foundShoppingItem;
}

- (BBShoppingItem *)addItem:(BBItem *)item {
    
    NSManagedObjectContext *moc = [[BBStorageManager sharedManager] managedObjectContext];
    
    BBShoppingItem *newShoppingItem = [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_SHOPPING_ITEM 
                                                                    inManagedObjectContext:moc];
    
    newShoppingItem.item = item;
    newShoppingItem.parentShoppingCart = self;
    
    [item addShoppingItemsObject:newShoppingItem];
    
    [self addCartItemsObject:newShoppingItem];
    
    return newShoppingItem;
}

- (void)removeItem:(BBItem *)item {
    
    [self.cartItems enumerateObjectsUsingBlock:^(BBShoppingItem *shoppingItem, BOOL *stop) {
        
        if(shoppingItem.item == item) {
            
            [[[BBStorageManager sharedManager] managedObjectContext] deleteObject:shoppingItem];
            [self removeCartItemsObject:shoppingItem];
            
            *stop = YES;
        }
    }];
}

- (void)removeShoppingItem:(BBShoppingItem *)shoppingItem {
    
    [[[BBStorageManager sharedManager] managedObjectContext] deleteObject:shoppingItem];
}

@end
