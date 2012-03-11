//
//  BBStorageManager+iCloud.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/18/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStorageManager+iCloud.h"

@implementation BBStorageManager (iCloud)

- (void)createUbiquityContainer {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if([[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] != nil) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"iCloudEnabledNotification" object:self userInfo:nil];
                
            });
        }
    });
}

- (void)migratePersistentStoreForiCloud {
    
    [self saveContext];
    
    self.persistentStoreCoordinator = nil;
    self.managedObjectContext = nil;
    
    // reset the managedObjectContext
    self.managedObjectContext = [self managedObjectContext];
}

- (void)updateUbiquitousContent:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BBUbiquitousUpdateNotification" object:nil];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"iCloud Content Imported" 
                                                        message:@"iCloud has updated content in this applciation" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Okay" 
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
    
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:BB_ENTITY_SHOPPING_ITEM];
    NSArray *shoppingItems = [self.managedObjectContext executeFetchRequest:fr error:nil];
    
    for(BBShoppingItem *shoppingItem in shoppingItems) {
        
        NSLog(@"item name: %@", shoppingItem.item.name);
    }
}

@end
