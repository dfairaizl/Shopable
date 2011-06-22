//
//  AddItemViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 3/11/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddItemDelegate

- (void) addItemToCategory:(NSString *)newItem withQuantity:(NSString *)quantity andNotes:(NSString *)notes;

@end

@class ItemsListViewController;

@interface AddItemViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	
	UIScrollView *scrollView;
	
	ItemsListViewController *itemListDelegate;
	UITextField *itemNameTextField;
	UITextField *itemQuantityTextField;
	UITextView *itemNotesTextView;
	
	UIPickerView *quantityPicker;
	
	BOOL keyboardIsOpen;
	UIView *currentTextField;
	
	NSDictionary *quantitiesAndUnits;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITextField *itemNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *itemQuantityTextField;
@property (nonatomic, retain) IBOutlet UITextView *itemNotesTextView;
@property (nonatomic, retain) IBOutlet UIPickerView *quantityPicker;
@property (nonatomic, retain) ItemsListViewController *itemListDelegate;

- (IBAction) doneEditingField:(id)sender;
- (void) showQuantityInputPicker;

@end
