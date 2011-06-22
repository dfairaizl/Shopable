//
//  AtTheStoreViewController.h
//  AllOutOf
//
//  Created by Dan Fairaizl on 3/7/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemTableViewCell.h"

@interface AtTheStoreViewController : UITableViewController <AtTheStoreTableViewDelegate> {
	
	NSMutableDictionary *_items;
	
	UISearchBar *searchBar;
}

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@end
