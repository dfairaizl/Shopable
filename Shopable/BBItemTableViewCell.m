//
//  BBItemTableViewCell.m
//  Shopable
//
//  Created by Dan Fairaizl on 5/14/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItemTableViewCell.h"

@implementation BBItemTableViewCell

@synthesize delegate;

@synthesize checkMarkImageView;
@synthesize itemNameLabel;

@synthesize quantityStepper;
@synthesize quantityLabel;
@synthesize unitsButton;
@synthesize notesButton;
@synthesize photoButton;

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

#pragma mark - Public Methods

- (void)checkItem:(BOOL)checked {
    
    if(checked == YES) {
        
        [self.checkMarkImageView setImage:[UIImage imageNamed:@"check_box_checked"]];
    }
    else {
        
        [self.checkMarkImageView setImage:[UIImage imageNamed:@"check_box_empty"]];
    }
}

- (IBAction)quanityStepperValueChanged:(UIStepper *)sender {
    
    self.quantityLabel.text = [NSString stringWithFormat:@"x %d", (int)[sender value]];
}

- (IBAction)itemDetailsDisclosureButtonPressed:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(showItemDetailsForCell:)]) {
     
        [self.delegate showItemDetailsForCell:self];
    }
}

@end
