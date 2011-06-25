//
//  AddStoreViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/24/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddItemViewController.h"


@interface AddStoreViewController : AddItemViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    
}

@property (nonatomic, retain) IBOutlet UITextField *storeNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *storeTypeTextField;
@property (nonatomic, retain) IBOutlet UIPickerView *storeTypePicker;

@property (nonatomic, retain) NSArray *storeTypes;

- (void) showStoreTypePicker;

@end
