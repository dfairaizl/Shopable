//
//  UIScrollView+Paging.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/7/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "UIScrollView+Paging.h"

@implementation UIScrollView (Paging)

- (NSInteger)currentPage {
    
    CGFloat pageWidth = self.frame.size.width;
    return floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated {
    
    CGRect pageFrame = CGRectMake(CGRectGetWidth(self.frame) * page, 
                                  0, 
                                  CGRectGetWidth(self.frame), 
                                  CGRectGetHeight(self.frame));
    
    [self scrollRectToVisible:pageFrame animated:animated];
    
}

@end
