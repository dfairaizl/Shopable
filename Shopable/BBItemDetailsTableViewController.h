//
//  BBItemDetailsTableViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 6/8/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBShoppingItem;

@interface BBItemDetailsTableViewController : UITableViewController

@property (weak, nonatomic) BBShoppingItem *currentItem;

@end
