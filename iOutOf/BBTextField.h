//
//  BBTextField.h
//  iOutOf
//
//  Created by Dan Fairaizl on 3/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BBTextField : UITextField {
	
	UIView *_responderView;

}

@property (readwrite, retain) UIView *inputView;

@end
