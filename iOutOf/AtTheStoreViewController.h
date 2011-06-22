//
//  AtTheStoreViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemTableViewCell.h"

@interface AtTheStoreViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UITableView *shoppingCartTableView;

@property (nonatomic, retain) NSMutableDictionary *cartItems;

@end
