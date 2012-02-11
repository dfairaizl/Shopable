//
//  BBItem+Logic.m
//  iOutOf
//
//  Created by Dan Fairaizl on 2/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItem+Logic.h"

#import "BBStorageManager.h"

@implementation BBItem (Logic)

+ (BBItem *)newItem {
    
    return [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_ITEM inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
}

- (BOOL)itemContainedInShoppingCart {
    
    NSError *error = nil;
    
    NSFetchRequest *itemsFR = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_SHOPPING_ITEM];
    
    [itemsFR setPredicate:[NSPredicate predicateWithFormat:@"item == %@", self]];
    
    NSInteger matchingItems = [[[BBStorageManager sharedManager] managedObjectContext] countForFetchRequest:itemsFR error:&error];
    
    return matchingItems == 1;
}

@end
