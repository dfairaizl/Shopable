//
//  BBStoresViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 2/5/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBStoresViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *storesScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *storesPageControl;

@end
