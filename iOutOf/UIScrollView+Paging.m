//
//  UIScrollView+Paging.m
//  iOutOf
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

@end
