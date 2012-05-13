//
//  BBListTableViewCell.h
//  Shopable
//
//  Created by Dan Fairaizl on 5/12/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBProtocols.h"

@interface BBListTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) id <BBListTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *listTitle;
@property (strong, nonatomic) IBOutlet UITextField *listTitleTextField;

@end
