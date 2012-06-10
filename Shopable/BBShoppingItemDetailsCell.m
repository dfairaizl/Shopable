//
//  BBShoppingItemDetailsCell.m
//  Shopable
//
//  Created by Dan Fairaizl on 6/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBShoppingItemDetailsCell.h"

@implementation BBShoppingItemDetailsCell

@synthesize itemNotesLabel, itemPhotoImageView;

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

@end
