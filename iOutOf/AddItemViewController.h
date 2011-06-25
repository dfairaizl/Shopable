//
//  AddItemViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 3/11/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalAddViewController.h"

@class ItemsListViewController;

@interface AddItemViewController : ModalAddViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	
	ItemsListViewController *itemListDelegate;
	UITextField *itemNameTextField;
	UITextField *itemQuantityTextField;
	UITextView *itemNotesTextView;
	
	UIPickerView *quantityPicker;
	
	NSDictionary *quantitiesAndUnits;
}

@property (nonatomic, retain) IBOutlet UITextField *itemNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *itemQuantityTextField;
@property (nonatomic, retain) IBOutlet UITextView *itemNotesTextView;
@property (nonatomic, retain) IBOutlet UIPickerView *quantityPicker;
@property (nonatomic, retain) ItemsListViewController *itemListDelegate;

- (void) showQuantityInputPicker;

@end
