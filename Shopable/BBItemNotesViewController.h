//
//  BBItemNotesViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 6/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBShoppingItem;

@interface BBItemNotesViewController : UIViewController

@property (weak, nonatomic) BBShoppingItem *currentItem;

@property (strong, nonatomic) IBOutlet UITextView *itemNotesTextView;

@end
