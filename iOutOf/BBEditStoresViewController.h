//
//  BBEditStoresViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 2/7/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    bbTableDisplayModeStores = 0,
    bbTableDisplayModeItems,
} BBTableDisplayMode;

@interface BBEditStoresViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate>
{
    BBTableDisplayMode displayMode;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UITableView *storesTableView;

- (IBAction)editingStateChanged:(id)sender;

@end
