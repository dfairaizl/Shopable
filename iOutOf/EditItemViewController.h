//
//  EditItemViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddItemViewController.h"

@protocol EditItemDelegate

- (void) editItemInShoppingCart:(NSString *)newName withQuantity:(NSString *)newQuantity andNotes:(NSString *)newNotes;

@end

@class Item;

@interface EditItemViewController : AddItemViewController {
    
}

@property (nonatomic, retain) Item *editingItem;

@end
