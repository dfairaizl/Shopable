//
//  BBItemsListTableViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 5/14/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBItemCategory, BBList;

@interface BBItemsListTableViewController : UITableViewController

@property (weak, nonatomic) BBItemCategory *currentItemCategory;
@property (weak, nonatomic) BBList *currentList;

@end
