//
//  XmlDataParser.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Store, Category, Item;

@interface XmlDataParser : NSObject <NSXMLParserDelegate> {
    
    Store *currentStore;
    Category *currentCategory;
    Item *currentItem;
    
    NSMutableString *currentValue;
}

@end
