//
//  BBTextField.m
//  iOutOf
//
//  Created by Dan Fairaizl on 3/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "BBTextField.h"


@implementation BBTextField

@synthesize inputView = _responderView;

- (BOOL) canBecomeFirstResponder {
    return YES;
}

@end
