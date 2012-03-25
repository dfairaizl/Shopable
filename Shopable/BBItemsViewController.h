//
//  BBItemsViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 2/7/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBStore, BBItemCategory, BBShoppingCart;

@interface BBItemsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) BBStore *currentStore;
@property (strong, nonatomic) BBShoppingCart *currentShoppingCart;
@property (strong, nonatomic) BBItemCategory *currentItemCategory;

@property (strong, nonatomic) IBOutlet UITableView *itemsTableView;

- (IBAction)addItem:(id)sender;

@end
