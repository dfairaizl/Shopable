//
//  ItemsListViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddItemViewController.h"

@class Category;

@interface ItemsListViewController : UITableViewController <AddItemDelegate> {
    
}

@property (nonatomic, retain) Category *currentCategory;
@property (nonatomic, retain) NSArray *items;

@end
