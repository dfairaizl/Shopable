//
//  BBShoppingListDetailsViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 6/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BBShoppingDetailsCellTypeNotes @"BBShoppingDetailsCellTypeNotes"
#define BBShoppingDetailsCellTypePhoto @"BBShoppingDetailsCellTypePhoto"

@class BBShoppingItem;

@interface BBShoppingListDetailsViewController : UITableViewController

@property (weak, nonatomic) BBShoppingItem *currentItem;

@end
