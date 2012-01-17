//
//  BBShoppingTableViewCell.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/16/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBDecoratorLabel;

@interface BBShoppingTableViewCell : UITableViewCell {
    
@private
    BOOL isCheckedOff;
    
}

@property (strong, nonatomic) IBOutlet BBDecoratorLabel *itemLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemQuantityLabel;

- (void)cellCheckedOff:(BOOL)checkedOff;

@end
