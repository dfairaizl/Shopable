//
//  StrikeThroughLabel.m
//  iOutOf
//
//  Created by Dan Fairaizl on 3/12/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "BBTextDecorationLabel.h"


@implementation BBTextDecorationLabel

@synthesize strikeThrough, underlined, lineThickness, color;

//initWithCoder since these labels get created from and IB xib
- (id) initWithCoder:(NSCoder *)aDecoder {

	if(self = [super initWithCoder:aDecoder]) {
		
		self.underlined = NO;
		self.strikeThrough = NO;
		
		self.lineThickness = 1.5f;
		self.color = [UIColor blackColor];
	}
	
	return self;
}

- (void) drawTextInRect:(CGRect)rect {
	
	if(self.strikeThrough || self.underlined) {
	
		CGRect textRect;
		CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) 
								lineBreakMode:UILineBreakModeWordWrap];
		
		if(self.strikeThrough)
			textRect = CGRectMake(0, 0, size.width, (self.frame.size.height / 2) + 2);
		else if(self.underlined)
			textRect = CGRectMake(0, 0, size.width, (self.frame.size.height * .75) + 3);
		
		CGContextRef c = UIGraphicsGetCurrentContext();
		CGContextSetStrokeColorWithColor(c, self.color.CGColor);
		CGContextBeginPath(c);
		CGContextMoveToPoint(c, textRect.origin.x, textRect.size.height);
		CGContextAddLineToPoint(c, textRect.size.width, textRect.size.height);
		CGContextSetLineWidth(c, self.lineThickness);
		CGContextStrokePath(c);
	}
	
	//always super drawTextInRect - even if we arn't drawing effects the label still needs to be drawn.
	[super drawTextInRect:rect];
}

- (void) dealloc {
	
	[color release];

	[super dealloc];
}

@end
