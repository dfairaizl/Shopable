//
//  BBShoppingListCell.h
//  Shopable
//
//  Created by Dan Fairaizl on 6/8/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

//Views
#import "BBDecoratorLabel.h"

@interface BBShoppingListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet BBDecoratorLabel *itemNameLabel;

- (void)itemCheckedOff:(BOOL)checkedOff;

@end
