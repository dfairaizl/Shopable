//
//  BBEditStoreTableViewCell.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBEditStoreTableViewCell.h"

#import "BBStorageManager.h"

@implementation BBEditStoreTableViewCell

@synthesize currentStore;
@synthesize storeNameTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    currentStore.name = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)layoutSubviews {
    
    if(self.showingDeleteConfirmation == YES) {

        [UIView animateWithDuration:0.5 animations:^() {
          
            CGRect frame = self.storeNameTextField.frame;
            frame.size.width = CGRectGetWidth(self.contentView.frame) - 80;
            self.storeNameTextField.frame = frame;
            
        }];
    }
    else {

        [UIView animateWithDuration:0.5 animations:^() {
            
            CGRect frame = self.storeNameTextField.frame;
            frame.size.width = 195.0;
            self.storeNameTextField.frame = frame;
            
        }];
    }
    
    [super layoutSubviews];
}

@end
