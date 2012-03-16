//
//  BBStorageManager+Initialize.m
//  Shopable
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStorageManager+Initialize.h"

#import "BBStorageManager+iCloud.h"

@implementation BBStorageManager (Initialize)

- (void)setupDatabase {
    
    [self createDefaults];
    
    /*BOOL cloudValue = [[NSUbiquitousKeyValueStore defaultStore] boolForKey:@"defaultDataCreated"];
    BOOL localValue = [[NSUserDefaults standardUserDefaults] boolForKey:@"defaultDataCreated"];
    
    if(cloudValue == NO && localValue == NO) {
                
        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"defaultDataCreated"];
        [[NSUbiquitousKeyValueStore defaultStore] setBool:YES forKey:@"defaultDataCreated"];
        
        //sync everything up
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
        
        NSLog(@"Default data created!");
    }
    
    //setup iCloud if applicable
    [self createUbiquityContainer];*/
}

- (void)createDefaults {
    
    //Create default Grocery Store
    /*BBStore *groceryStore = [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_STORE inManagedObjectContext:self.managedObjectContext];
    
    groceryStore.name = [NSString stringWithString:@"Grocery Store"];
    groceryStore.order = [NSNumber numberWithInt:0];
    
    //set the type
    groceryStore.type = [NSNumber numberWithInt:bbStoreTypeGrocery];*/
    
    [self createDefaultCategories];
    
    [self saveContext];
}

- (void)createDefaultCategories {
    
    //create item categories for this store
    NSDictionary *itemCategories = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CategoryItems" withExtension:@"plist"]];
    NSArray *categories = [itemCategories objectForKey:@"Categories"];
    
    for(NSString *category in categories) {
        
        BBItemCategory *itemCategory = [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_ITEM_CATEGORY inManagedObjectContext:self.managedObjectContext];
        
        itemCategory.type = [NSNumber numberWithInt:bbStoreTypeGrocery];
        itemCategory.name = category;
        
        [self createDefaultItemsForCategory:itemCategory fromDictionary:[itemCategories objectForKey:@"Items"]];
    }
}

- (void)createDefaultItemsForCategory:(BBItemCategory *)category fromDictionary:(NSDictionary *)itemsDict {
    
    NSArray *items = [itemsDict objectForKey:category.name];
    
    for(NSString *item in items) {
        
        BBItem *itemMO = [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_ITEM inManagedObjectContext:self.managedObjectContext];
        
        itemMO.name = item;
        itemMO.parentItemCategory = category;
        
        [category addItemsObject:itemMO];
    }
}

@end
