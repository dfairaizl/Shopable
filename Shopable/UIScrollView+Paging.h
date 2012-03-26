//
//  UIScrollView+Paging.h
//  Shopable
//
//  Created by Dan Fairaizl on 2/7/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Paging)

- (NSInteger)currentPage;
- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated;

@end
