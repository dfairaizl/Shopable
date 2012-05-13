//
//  BBShoppingListsViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 5/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBProtocols.h"

@interface BBListsViewController : UIViewController <BBListTableViewCellDelegate, UITableViewDelegate, 
                                                    UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) id <BBNavigationDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *addNewListButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editListsButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *emailListsButton;

- (IBAction)editButtonPressed:(id)sender;
- (IBAction)addNewListButtonPressed:(id)sender;

@end
