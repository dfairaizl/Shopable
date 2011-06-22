//
//  XmlDataParser.m
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "XmlDataParser.h"
#import "Persistence.h"

//Entities
#import "Store.h"
#import "Category.h"
#import "Item.h"

@implementation XmlDataParser

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	
    NSLog(@"Begin xml file.");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict 
{
	if([elementName isEqualToString:@"Store"]) {
		
		Store *store = (Store *)[Persistence entityOfType:elementName];
        store.name = [attributeDict objectForKey:@"name"];
        
        currentStore = store;
	}
    else if([elementName isEqualToString:@"Category"]) {
		
		Category *category = (Category *)[Persistence entityOfType:elementName];
        category.name = [attributeDict objectForKey:@"name"];
        
        currentCategory = category;
	}
    else if([elementName isEqualToString:@"Item"]) {
		
		Item *item = (Item *)[Persistence entityOfType:elementName];
        
        currentItem = item;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if (!currentValue) {
		currentValue = [[NSMutableString alloc] init];
    }
	
    [currentValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
{
	//trim out the bad characters from the xml file
	NSString *trim = [currentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if([elementName isEqualToString:@"Stores"]) {
        
        //Save all the data we just parsed into entities
        [Persistence save];
        
		return; //End of xml parsing - get out of here
	}
	else if([elementName isEqualToString:@"Store"]) {
        
	}
    else if([elementName isEqualToString:@"Category"]) {
		
        [currentStore addCategoriesObject:currentCategory];
	}
    else if([elementName isEqualToString:@"Item"]) {
		
        currentItem.name = trim;
        [currentCategory addItemsObject:currentItem];
	}
	
	[currentValue release];
	currentValue = nil;
}

- (void) dealloc {
	
	if(currentValue != nil)
		[currentValue release];
	
	[super dealloc];
}

@end
