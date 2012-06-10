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
                                                                    UIPickerViewDataSource, UIPickerViewDelegate,
                                                                    UIImagePickerControllerDelegate, 
                                                                    UINavigationControllerDelegate, 
                                                                    UIActionSheetDelegate>

@property (weak, nonatomic) BBShoppingItem *currentItem;

@property (strong, nonatomic) IBOutlet UITextField *quantityUnitsTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *quantityUnitsPicker;
@property (strong, nonatomic) IBOutlet UIToolbar *pickerToolBar;
@property (strong, nonatomic) IBOutlet UILabel *itemNotesLabel;
@property (strong, nonatomic) IBOutlet UILabel *addPhotoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *itemPhotoImageView;

- (IBAction)doneButtonPressed:(id)sender;

@end
