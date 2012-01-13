//
//  BBStorageManager+Initialize.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStorageManager.h"

@interface BBStorageManager (Initialize)

- (void)createDefaults;
- (void)createDefaultCategories;
- (void)createDefaultItemsForCategory:(BBItemCategory *)category fromDictionary:(NSDictionary *)itemsDict;

@end
