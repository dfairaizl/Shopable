//
//  BBItemCategoryTableViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBToolbarShoppingView.h"

@class BBStore;

@interface BBShoppingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BBToolbarSliderDelegate>

@property (weak, nonatomic) BBStore *currentStore;

@property (strong, nonatomic) NSFetchedResultsController *frc;

@property (strong, nonatomic) IBOutlet UITableView *itemsTableView;
@property (strong, nonatomic) IBOutlet UITableView *shoppingTableView;
@property (strong, nonatomic) IBOutlet UIView *toolbar;
@property (strong, nonatomic) IBOutlet BBToolbarShoppingView *toolbarShoppingSlider;

@end
