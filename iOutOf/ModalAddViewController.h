//
//  ModalAddViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/24/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddItemDelegate

- (void) addItemToCategory:(NSString *)newItem withQuantity:(NSString *)quantity andNotes:(NSString *)notes;

@end


@interface ModalAddViewController : UIViewController {
    
    BOOL keyboardIsOpen;
	UIView *currentTextField;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (IBAction) doneEditingField:(id)sender; //Closes keyboard when field loses focus

@end
