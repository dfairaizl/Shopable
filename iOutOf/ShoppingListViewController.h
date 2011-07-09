//
//  ShoppingListViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddCategoryViewController.h"

@class Store;

@interface ShoppingListViewController : UITableViewController <AddCategoryDelegate> {
    
}

@property (nonatomic, retain) Store *currentStore;

@property (nonatomic, retain) NSArray *categories;

@end
