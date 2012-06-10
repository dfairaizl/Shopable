//
//  BBCategoriesTableViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 6/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBList;

@interface BBCategoriesTableViewController : UITableViewController

@property (weak, nonatomic) BBList *currentList;

- (IBAction)doneButtonPressed:(id)sender;

@end
