//
//  BBItemTableViewCell.h
//  iOutOf
//
//  Created by Dan Fairaizl on 2/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBShoppingCart, BBItem;

@interface BBItemTableViewCell : UITableViewCell

@property (weak, nonatomic) BBShoppingCart *currentShoppingCart;
@property (weak, nonatomic) BBItem *currentItem;

@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UIButton *itemSelectionButton;

- (IBAction)itemSelectionButtonPress:(id)sender;
- (void)setItemSelected:(BOOL)selected;

@end
