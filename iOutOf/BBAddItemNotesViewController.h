//
//  BBAddItemNotesViewController.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/17/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBAddItemNotesDelegate <NSObject>

- (NSString *)itemNotes;
- (void)addNotesToItem:(NSString *)notes;

@end

@class BBParentItemTableViewController;

@interface BBAddItemNotesViewController : UIViewController

@property (weak, nonatomic) BBParentItemTableViewController <BBAddItemNotesDelegate> *delegate;

@property (strong, nonatomic) IBOutlet UITextView *notesTextView;

@end
