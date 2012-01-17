//
//  BBShoppingTableViewCell.m
//  iOutOf
//
//  Created by Dan Fairaizl on 1/16/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBShoppingTableViewCell.h"

#import "BBDecoratorLabel.h"

@implementation BBShoppingTableViewCell

@synthesize itemLabel;

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

- (void)cellCheckedOff:(BOOL)checkedOff {
    
    //set the new state
    isCheckedOff = checkedOff;
    
    //update the cell display
    [self.itemLabel setStrikeThrough:checkedOff];
    
    [self.itemLabel setNeedsDisplay];
}

@end
