//
//  ItemTableViewCell.m
//  iOutOf
//
//  Created by Dan Fairaizl on 3/12/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "ItemTableViewCell.h"

#import "Item.h"

@implementation ItemTableViewCell

@synthesize tableDelegate, cellItem, cellSelected, itemLabel, quantityLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
    if (self) {
    
	}
	
    return self;
}

- (void) swipeRight {
    
    BOOL checkedOff = [self.cellItem.checkedOff boolValue];
	
	if(!checkedOff) {
		self.itemLabel.strikeThrough = YES;
		self.cellItem.checkedOff = [NSNumber numberWithBool:YES];
	}
	else {
		self.itemLabel.strikeThrough = NO;
		self.cellItem.checkedOff = [NSNumber numberWithBool:NO];
	}
	
	[self.itemLabel setNeedsDisplay];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

#pragma mark -
#pragma mark Gesture Recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void) setGesture {

	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
	[self.contentView addGestureRecognizer:recognizer];
	recognizer.delegate = self;
	[recognizer release];
}

- (void)dealloc {
	
	[itemLabel release];
	[cellItem release];
	[quantityLabel release];
	[tableDelegate release];
	
    [super dealloc];
}


@end
