//
//  BBListTableViewCell.m
//  Shopable
//
//  Created by Dan Fairaizl on 5/12/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBListTableViewCell.h"

@implementation BBListTableViewCell

@synthesize listTitle;
@synthesize listTitleTextField;

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

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
 
    [super setEditing:editing animated:animated];
    
    if(editing == YES) {
        
        self.listTitle.hidden = YES;
        self.listTitleTextField.hidden = NO;
    }
    else {
        
        self.listTitle.hidden = NO;
        self.listTitleTextField.hidden = YES;
    }
}

@end
