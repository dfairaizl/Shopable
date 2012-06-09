//
//  BBItemDetailsTableViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 6/8/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define bbPickerNumberOfComponents  2
#define bbPickerComponentQuantity   0
#define bbPickerComponentUnits      1

@class BBShoppingItem;

@interface BBItemDetailsTableViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate,
                                                                    UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) BBShoppingItem *currentItem;

@property (strong, nonatomic) IBOutlet UITextField *quantityUnitsTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *quantityUnitsPicker;
@property (strong, nonatomic) IBOutlet UIToolbar *pickerToolBar;

- (IBAction)doneButtonPressed:(id)sender;

@end
