//
//  BBItemsViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 2/7/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBItemCategory, BBShoppingCart;

@interface BBItemsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) BBShoppingCart *currentShoppingCart;
@property (strong, nonatomic) BBItemCategory *currentItemCategory;

@property (strong, nonatomic) IBOutlet UITableView *itemsTableView;

@end
