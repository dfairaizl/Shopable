//
//  BBStorageManager+Initialize.m
//  iOutOf
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStorageManager+Initialize.h"

//Entities
#import "BBStore.h"

@implementation BBStorageManager (Initialize)

- (void)createDefaults {
    
    NSLog(@"First launch of app after install. Creating default data");
    
    //Create default Grocery Store
    BBStore *entity = [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_STORE inManagedObjectContext:[self managedObjectContext]];
    
    entity.name = [NSString stringWithString:@"Dan's Grocery Store"];
    
    [self saveContext];
}

@end
