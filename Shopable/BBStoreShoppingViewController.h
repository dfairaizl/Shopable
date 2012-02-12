//
//  BBStoreShoppingViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 2/5/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBStore;

@interface BBStoreShoppingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UITableView *storeTableView;
@property (strong, nonatomic) IBOutlet UILabel *storeNameLabel;

@property (strong, nonatomic) BBStore *currentStore;

@end
