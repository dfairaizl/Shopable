//
//  BBShoppingListViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 5/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBProtocols.h"

@interface BBShoppingListViewController : UIViewController

@property (weak, nonatomic) id <BBNavigationDelegate> delegate;

@property (strong, nonatomic) BBList *currentList;

- (IBAction)showMenuButtonPressed:(id)sender;

@end
