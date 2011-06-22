//
//  HomeViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 3/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

}

@property (nonatomic, retain) IBOutlet UITableView *storeTableView;

@property (nonatomic, retain) NSArray *stores;

@end
