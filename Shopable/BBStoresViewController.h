//
//  BBStoresViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 2/5/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBAddStoreTableViewController.h"

@interface BBStoresViewController : UIViewController <UIScrollViewDelegate, BBStoreDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *storesScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *storesPageControl;
@property (strong, nonatomic) IBOutlet UILabel *currentlyShoppingLabel;
@property (strong, nonatomic) IBOutlet UIButton *editStoresButton;
@property (strong, nonatomic) IBOutlet UIButton *editShoppingCartButton;

@property (strong, nonatomic) UIButton *toggleShoppingButton;
@property (strong, nonatomic) UIButton *addStoreButton;

- (IBAction)editShoppingCartButtonPressed:(id)sender;

@end
