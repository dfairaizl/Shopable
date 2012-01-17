//
//  BBToolbarShoppingView.m
//  iOutOf
//
//  Created by Dan Fairaizl on 1/12/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBToolbarShoppingView.h"

@interface BBToolbarShoppingView ()

@property CGPoint lastPosition;

@end

@implementation BBToolbarShoppingView

@synthesize toolbar;
@synthesize shoppingTextLabel;
@synthesize delegate;
@synthesize lastPosition;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - UIView Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touches began, view at %@", NSStringFromCGPoint(self.frame.origin));
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint pos = [[touches anyObject] locationInView:self.toolbar];
    
    //determine if we are still in bounds
    
    if(pos.x < 7) {
        pos.x = 7;
    }
    
    if((pos.x + CGRectGetWidth(self.frame)) > self.toolbar.frame.size.width - 7) {
        pos.x = self.toolbar.frame.size.width - 7 - CGRectGetWidth(self.frame);
    }
    
    //update the frames location
    CGRect frame = self.frame;
    frame.origin = CGPointMake(pos.x, frame.origin.y);
    self.frame = frame;
    
    self.lastPosition = pos;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //determine user moved the view across the trigger threshold
    CGFloat threshold = self.toolbar.frame.size.width - 7 - (CGRectGetWidth(self.frame) * 2); //somewhat arbitrary
    
    if(self.lastPosition.x >= threshold) {
        
        [UIView animateWithDuration:0.2 
                         animations:^() {
                             
                             CGRect frame = self.frame;
                             frame.origin.x = self.toolbar.frame.size.width - 7 - CGRectGetWidth(self.frame);
                             self.frame = frame;
                             
                             self.shoppingTextLabel.text = [NSString stringWithString:@"Slide cart back to plan!"];
                         }
                         completion:^(BOOL finished) {
                             [self.delegate toolbarSliderDidCrossThreshold];
                         }
         ];
        
    }
    else {
        
        //move the view back to beginning        
        [UIView animateWithDuration:0.2 
                         animations:^() {
            
                             CGRect frame = self.frame;
                             frame.origin.x = 7;
                             self.frame = frame;
                             
                             self.shoppingTextLabel.text = [NSString stringWithString:@"Slide cart to go shopping!"];
                         }
                         completion:^(BOOL finished) {
                             [self.delegate toolbarSliderDidReturn];
                         }
         ];
    }
}

@end
