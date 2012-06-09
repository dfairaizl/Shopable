//
//  BBItemTableViewCell.h
//  Shopable
//
//  Created by Dan Fairaizl on 5/14/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBProtocols.h"

@interface BBItemTableViewCell : UITableViewCell

@property (weak, nonatomic) id <BBItemsListTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *checkMarkImageView;
@property (strong, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemQuantityUnitsLabel;

//accordion controls
@property (strong, nonatomic) IBOutlet UIStepper *quantityStepper;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UIButton *unitsButton;
@property (strong, nonatomic) IBOutlet UIButton *notesButton;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;

- (IBAction)quanityStepperValueChanged:(UIStepper *)sender;
- (IBAction)itemDetailsDisclosureButtonPressed:(id)sender;

- (void)checkItem:(BOOL)checked;

@end
