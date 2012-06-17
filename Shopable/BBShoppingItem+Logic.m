//
//  BBShoppingItem+Logic.m
//  Shopable
//
//  Created by Daniel Fairaizl on 6/15/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBShoppingItem+Logic.h"

//DB
#import "BBStorageManager.h"

@implementation BBShoppingItem (Logic)

- (void)addPhoto:(UIImage *)photo {
 
    NSData *imageData = UIImageJPEGRepresentation(photo, 60);
    
    if(self.photo == nil) {
        
        BBItemImage *photo = [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_ITEM_IMAGE
                                      inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
        
        self.photo = photo;
        
    }
    
    self.photo.itemImage = imageData;
}

- (UIImage *)itemPhoto {
    
    return [UIImage imageWithData:self.photo.itemImage];
}

@end
