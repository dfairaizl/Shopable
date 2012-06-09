//
//  BBShoppingListCell.m
//  Shopable
//
//  Created by Dan Fairaizl on 6/8/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBShoppingListCell.h"

@implementation BBShoppingListCell {
    
    BOOL itemCheckedOff;
}

@synthesize itemNameLabel;

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

- (void)itemCheckedOff:(BOOL)checkedOff {
    
    itemCheckedOff = checkedOff;
    
    //update the cell display
    [self.itemNameLabel setStrikeThrough:checkedOff];
    
    [self.itemNameLabel setNeedsDisplay];
}

@end
