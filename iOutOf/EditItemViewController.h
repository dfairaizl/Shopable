//
//  EditItemViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/10/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddItemViewController.h"

@class Item;

@interface EditItemViewController : AddItemViewController {
    
}

@property (nonatomic, retain) Item *editingItem;

@end
