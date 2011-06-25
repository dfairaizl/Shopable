//
//  ModalAddViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 6/24/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "ModalAddViewController.h"

@interface ModalAddViewController (PrivateMethods)

- (void) registerForKeyboardNotifications;
- (void)keyboardWillHide:(NSNotification *)n;
- (void)keyboardWillShow:(NSNotification *)n;

@end

@implementation ModalAddViewController

@synthesize scrollView = _scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_scrollView release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.scrollView setContentSize:CGSizeMake(320, 416)];
    
    [self registerForKeyboardNotifications];
    
    keyboardIsOpen = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Interface Actions

- (IBAction) doneEditingField:(id)sender {
	
}

#pragma mark -
#pragma mark Private Methods

- (void) registerForKeyboardNotifications {
    
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
											   object:nil];
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification 
											   object:nil];
}

- (void)keyboardWillShow:(NSNotification *)n {
	
}

- (void)keyboardWillHide:(NSNotification *)n {
	
}

@end
