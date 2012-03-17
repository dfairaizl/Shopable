//
//  BBAddStoreTableViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBStorageManager.h"

@protocol BBStoreDelegate <NSObject>

- (void)addStore:(BBStore *)store;

@end

@interface BBAddStoreTableViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDelegate>

@property (weak, nonatomic) id<BBStoreDelegate> storeDelegate;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *typeTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *storeTypePicker;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end
