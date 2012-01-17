//
//  BBItemsTableViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBStore, BBItemCategory;

@interface BBItemsTableViewController : UITableViewController

@property (weak, nonatomic) BBStore *currentStore;
@property (weak, nonatomic) BBItemCategory *currentItemCategory;

@end
