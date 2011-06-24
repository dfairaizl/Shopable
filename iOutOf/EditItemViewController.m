//
//  EditItemViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditItemViewController.h"

#import "Item.h"

@implementation EditItemViewController

@synthesize editingItem;

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
	
	self.title = @"Edit Item";
    
    NSLog(@"name: %@", self.editingItem.name);
    
    self.itemNameTextField.text = self.editingItem.name;
    self.itemQuantityTextField.text = self.editingItem.quantity;
    self.itemNotesTextView.text = self.editingItem.notes;
    
    [self.itemNameTextField resignFirstResponder];
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
#pragma mark Navbar Button Methods

- (BOOL) done {
	
	if([self.itemNameTextField.text length] > 0) {
        
        self.editingItem.name = self.itemNameTextField.text;
        self.editingItem.quantity = self.itemQuantityTextField.text;
        self.editingItem.notes = self.itemNotesTextView.text;
		
		[self dismissModalViewControllerAnimated:YES];
		
		return YES;
	}
	
	return NO;
}

@end
