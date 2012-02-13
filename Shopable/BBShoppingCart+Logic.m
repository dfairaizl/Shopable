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

- (BBShoppingItem *)addItemToCart:(BBItem *)item {
    
    BBShoppingItem *shoppingItem = [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_SHOPPING_ITEM inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
    
    shoppingItem.item = item;
    
    //add the new BBShoppingItem to this cart
    [self addCartItemsObject:shoppingItem];
    
    //add the new BBShoppingItem to the item's colletion of shoppingItems
    [item addShoppingItemsObject:shoppingItem];
    
    shoppingItem.itemCategoryName = item.parentItemCategory.name;
    
    return shoppingItem;
}

- (void)addUncategorizedItem:(BBItem *)newItem {
    
    BBShoppingItem *shoppingItem = [self addItemToCart:newItem];
    
    shoppingItem.itemCategoryName = [NSString stringWithString:@"Uncategorized"];
}

- (void)removeItemFromCart:(BBShoppingItem *)item {
    
    [self removeCartItemsObject:item];
}

- (BOOL)containsItem:(BBShoppingItem *)item {
    
    return [self.cartItems containsObject:item];
}

- (BBShoppingItem *)shoppingItemForItem:(BBItem *)item createIfNotPresent:(BOOL)create {
    
    NSError *error = nil;
    
    NSFetchRequest *itemsFR = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_SHOPPING_ITEM];
    
    [itemsFR setPredicate:[NSPredicate predicateWithFormat:@"item == %@ AND parentShoppingCart == %@", item, self]];
    
    NSArray *shoppingItems = [[[BBStorageManager sharedManager] managedObjectContext] executeFetchRequest:itemsFR error:&error];
    
    
    BBShoppingItem *shoppingItem = [shoppingItems lastObject];
    
    if(shoppingItem == nil && create == YES) {
        
        shoppingItem = [self addItemToCart:item];
    }
    
    return shoppingItem;
}

- (BOOL)containsShoppingItemForItem:(BBItem *)item {

    NSError *error = nil;
    
    NSFetchRequest *itemsFR = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_SHOPPING_ITEM];
    
    [itemsFR setPredicate:[NSPredicate predicateWithFormat:@"item == %@ AND parentShoppingCart == %@", item, self]];
    
    NSInteger items = [[[BBStorageManager sharedManager] managedObjectContext] countForFetchRequest:itemsFR error:&error];

    return items == 1;
}

@end
