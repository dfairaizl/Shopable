//
//  BBItemQuickAddViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 2/12/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBStoreShoppingViewController, BBShoppingCart;

@interface BBItemQuickAddViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *quickAddView;
@property (strong, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) BBStoreShoppingViewController *storeShoppingVC;
@property (weak, nonatomic) BBShoppingCart *currentShoppingCart;

- (IBAction)closeButtonPressed:(id)sender;

@end
