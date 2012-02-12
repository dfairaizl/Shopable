//
//  BBItem+Logic.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItem+Logic.h"

#import "BBStorageManager.h"

@implementation BBItem (Logic)

+ (BBItem *)newItem {
    
    BBItem *newItem = [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_ITEM inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
    
    newItem.isCustom = [NSNumber numberWithBool:YES];
    
    return newItem;
}

@end
