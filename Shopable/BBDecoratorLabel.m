//
//  BBDecoratorLabel.m
//  Shopable
//
//  Created by Dan Fairaizl on 1/16/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBDecoratorLabel.h"

@implementation BBDecoratorLabel

@synthesize strikeThrough;
@synthesize underline;

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGSize textWidth = [self.text sizeWithFont:self.font];
    
    if(self.strikeThrough) {
        
        CGContextSetLineWidth(context, 2.0);
        
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        
        CGContextMoveToPoint(context, 0, CGRectGetMinY(self.frame) + 1);
        CGContextAddLineToPoint(context, textWidth.width, CGRectGetMinY(self.frame) + 1);
        
        CGContextStrokePath(context);
    }
}

@end