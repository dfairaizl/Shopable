//
//  BBItemCategoryViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 5/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBList;

@interface BBItemCategoryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) BBList *currentList;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)categoryButtonPressed:(id)sender;

@end
