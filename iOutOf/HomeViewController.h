//
//  HomeViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UITableView *storesTableView;

@property (nonatomic, retain) IBOutlet UIButton *otherStoreButton;

@property (nonatomic, retain) NSArray *stores;

//UI Actions
- (IBAction) otherStoreButtonPress:(id)sender;

@end
