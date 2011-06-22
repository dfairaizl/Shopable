//
//  StrikeThroughLabel.h
//  iOutOf
//
//  Created by Dan Fairaizl on 3/12/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BBTextDecorationLabel : UILabel {

	//text effects
	BOOL strikeThrough;
	BOOL underlined;
	
	//attributes for text effect
	CGFloat lineThickness;
	UIColor *color;
}

@property BOOL strikeThrough;
@property BOOL underlined;
@property CGFloat lineThickness;
@property (nonatomic, retain) UIColor *color;

@end
