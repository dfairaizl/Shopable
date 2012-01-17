//
//  BBToolbarShoppingView.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/12/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBToolbarSliderDelegate <NSObject>

@optional
- (void)toolbarSliderDidCrossThreshold;
- (void)toolbarSliderDidReturn;

@end

@interface BBToolbarShoppingView : UIView

@property (weak, nonatomic) UIView *toolbar;
@property (strong, nonatomic) IBOutlet UILabel *shoppingTextLabel;
@property (weak, nonatomic) IBOutlet id<BBToolbarSliderDelegate> delegate;

@end
