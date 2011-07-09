//
//  AddCategoryViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 7/8/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalAddViewController.h"

@protocol AddCategoryDelegate <NSObject>

- (void) addCategoryWithName:(NSString *) name;

@end

@class ShoppingListViewController;

@interface AddCategoryViewController : ModalAddViewController <UITextFieldDelegate> {
    
}

@property (nonatomic, retain) ShoppingListViewController *shoppingListDelegate;
@property (nonatomic, retain) IBOutlet UITextField *categoryNameTextField;

@end
