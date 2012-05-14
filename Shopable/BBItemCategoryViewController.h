//
//  BBItemCategoryViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 5/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBItemCategoryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)categoryButtonPressed:(id)sender;

@end
