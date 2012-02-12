//
//  BBEditStoreTableViewCell.h
//  Shopable
//
//  Created by Dan Fairaizl on 2/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBStore;

@interface BBEditStoreTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) BBStore *currentStore;
@property (strong, nonatomic) IBOutlet UITextField *storeNameTextField;

@end
