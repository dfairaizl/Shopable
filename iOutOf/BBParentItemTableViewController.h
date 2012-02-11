//
//  BBParentItemTableViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 2/10/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBAddItemNotesViewController.h"

#define bbPickerNumberOfComponents  2
#define bbPickerComponentQuantity   0
#define bbPickerComponentUnits      1

@class BBStore, BBItemCategory, BBItem;

@interface BBParentItemTableViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDelegate, BBAddItemNotesDelegate> {
    
    NSInteger quantityRow;
    NSInteger unitsRow;
}

@property (weak, nonatomic) BBStore *currentStore;
@property (weak, nonatomic) BBItemCategory *currentItemCategory;

@property (strong, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *itemQuantityTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *quantityPickerView;
@property (strong, nonatomic) IBOutlet UIToolbar *quantityPickerViewToolbar;
@property (strong, nonatomic) IBOutlet UILabel *notesCellLabel;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;

@property (strong, nonatomic) BBItem *shoppingItem; 
@property (strong, nonatomic) NSDictionary *quantitiesUnitsPList;
@property (strong, nonatomic) NSArray *quantities;
@property (strong, nonatomic) NSArray *units;

- (void)updateQuantityAndUnits;

- (void)saveButtonPressed:(id)sender;
- (void)cancelButtonPressed:(id)sender;

- (IBAction)pickerClearButtonPressed:(id)sender;
- (IBAction)pickerDoneButtonPressed:(id)sender;

@end
