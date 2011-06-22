//
//  ItemListViewController.h
//  AllOutOf
//
//  Created by Dan Fairaizl on 3/8/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddItemViewController.h"

@interface ItemListViewController : UITableViewController <AddItemDelegate, UITextFieldDelegate> {
	
@private
	NSString *_currentCategory;
	NSString *_categoryID;
	
	NSMutableDictionary *_itemList;
	NSMutableSet *_itemsInShoppingCart;

}

- (id) initWithCategory:(NSString *)category andId:(NSString *)theId;

@end
