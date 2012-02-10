//
//  BBItemTableViewCell.m
//  iOutOf
//
//  Created by Dan Fairaizl on 2/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItemTableViewCell.h"

#import "BBStorageManager.h"

@implementation BBItemTableViewCell

@synthesize currentShoppingCart, currentItem;
@synthesize itemName, itemSelectionButton;

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

- (IBAction)itemSelectionButtonPress:(id)sender {
    
    if([self.currentShoppingCart containsItem:self.currentItem] == YES) {
        
        [self.currentShoppingCart removeItemFromCart:self.currentItem];
    }
    else {
        
        [self.currentShoppingCart addItemToCart:self.currentItem];
    }
    
    [self setItemSelected:[self.currentShoppingCart containsItem:self.currentItem]];
}

- (void)setItemSelected:(BOOL)selected {
    
    [self.itemSelectionButton setSelected:selected];
}

@end
