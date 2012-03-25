//
//  BBItemsTableViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBStore, BBItemCategory;

@interface BBItemCategoryViewController : UIViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) BBStore *currentStore;

@property (strong, nonatomic) IBOutlet UITableView *categoriesTableView;

- (IBAction)done:(id)sender;

@end
