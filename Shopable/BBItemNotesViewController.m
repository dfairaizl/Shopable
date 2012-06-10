//
//  BBItemNotesViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 6/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItemNotesViewController.h"

//DB
#import "BBStorageManager.h"

@interface BBItemNotesViewController ()

@end

@implementation BBItemNotesViewController

@synthesize currentItem;
@synthesize itemNotesTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.itemNotesTextView becomeFirstResponder];
    
    //assign the text from the current item, if any
    self.itemNotesTextView.text = self.currentItem.notes;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.currentItem.notes = self.itemNotesTextView.text;
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setItemNotesTextView:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IB Actions

- (IBAction)clearButtonPressed:(id)sender {

    self.itemNotesTextView.text = @"";
}

@end
