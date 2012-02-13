//
//  BBItemQuickAddSegue.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/12/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItemQuickAddSegue.h"

#import "BBStoresViewController.h"
#import "BBStoreShoppingViewController.h"
#import "BBItemQuickAddViewController.h"

@implementation BBItemQuickAddSegue

- (void)perform {
    
    BBStoreShoppingViewController *srcVC = (BBStoreShoppingViewController *)self.sourceViewController;
    BBStoresViewController *parentSrcVC = (BBStoresViewController *)srcVC.parentViewController;
    BBItemQuickAddViewController *destVC = (BBItemQuickAddViewController *)self.destinationViewController;
    
    destVC.storeShoppingVC = srcVC;
    
    CGRect frame = destVC.view.frame;
    frame.origin = CGPointMake(0, -44);
    destVC.view.frame = frame;
    
    [UIView animateWithDuration:0.4 
                          delay:0.0 
                        options:UIViewAnimationOptionCurveLinear 
                     animations:^() {
                         
                         [parentSrcVC.toggleShoppingButton setAlpha:0.0];
                         
                         [srcVC.parentViewController.view addSubview:destVC.view];
                         [destVC.view setAlpha:1.0];
                     }
                     completion:^(BOOL finished) {
                         
                         [parentSrcVC.toggleShoppingButton setEnabled:NO];
                     }];
}

@end
