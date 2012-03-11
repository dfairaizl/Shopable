//
//  BBImageTransformer.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/19/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBImageTransformer.h"

@implementation BBImageTransformer

+ (Class)transformedValueClass { 
 
    return [UIImage class]; 
}

+ (BOOL)allowsReverseTransformation { 

    return NO; 
}

- (id)transformedValue:(id)value {
 
    return (value == nil) ? nil : [UIImage imageWithData:(NSData *)value];
}

- (id)reverseTransformedValue:(id)value {
    
    return UIImageJPEGRepresentation((UIImage *)value, 60);
}

@end
