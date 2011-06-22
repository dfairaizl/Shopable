//
//  ItemTableViewCell.h
//  iOutOf
//
//  Created by Dan Fairaizl on 3/12/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBTextDecorationLabel.h"

@class Item, AtTheStoreViewController;

@protocol AtTheStoreTableViewDelegate

- (void) checkOffItem:(Item *)theItem checked:(BOOL)isChecked;

@end

@interface ItemTableViewCell : UITableViewCell <UIGestureRecognizerDelegate> {
	
	Item *cellItem;
	
	BOOL cellSelected;
	
	UILabel *quantityLabel;
	BBTextDecorationLabel *itemLabel;
	
	UISwipeGestureRecognizer *recognizer;
	
	AtTheStoreViewController *tableDelegate;
}

@property (nonatomic, retain) AtTheStoreViewController *tableDelegate;
@property (nonatomic, retain) Item *cellItem;
@property BOOL cellSelected;
@property (nonatomic, retain) IBOutlet BBTextDecorationLabel *itemLabel;
@property (nonatomic, retain) IBOutlet UILabel *quantityLabel;

- (void) setGesture;

@end
