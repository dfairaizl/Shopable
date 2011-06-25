//
//  AddStoreViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 6/24/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "AddStoreViewController.h"
#import "Persistence.h"

//Entities
#import "Store.h"

@implementation AddStoreViewController

@synthesize storeNameTextField = _storeNameTextField;

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
    [_storeNameTextField release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"Add Store";
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
         
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.rightBarButtonItem = done;
    
    [self.storeNameTextField becomeFirstResponder];
    
    [cancel release];
    [done release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.storeNameTextField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Navbar Button Methods

- (void) cancel {
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void) done {
    
    if([self.storeNameTextField.text length] > 0) {
    
        Store *newStore = [Persistence entityOfType:@"Store"];
        newStore.name = self.storeNameTextField.text;
        
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark Interface Actions

- (IBAction) doneEditingField:(id)sender {
	
	[self.storeNameTextField resignFirstResponder];
}

@end
