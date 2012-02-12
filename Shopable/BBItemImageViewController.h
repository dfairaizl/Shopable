//
//  BBItemImageViewController.h
//  Shopable
//
//  Created by Dan Fairaizl on 2/10/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBShoppingItem;

@interface BBItemImageViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) BBShoppingItem *currentItem;

@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;

@end
