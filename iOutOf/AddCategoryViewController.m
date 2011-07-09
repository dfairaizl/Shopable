//
//  AddCategoryViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 7/8/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "AddCategoryViewController.h"

@interface AddCategoryViewController (Private)
- (void) done;
@end

@implementation AddCategoryViewController

@synthesize categoryNameTextField = _categoryNameTextField;
@synthesize shoppingListDelegate = _shoppingListDelegate;

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
    [_categoryNameTextField release];
    [_shoppingListDelegate release];
    
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
    
    self.title = @"Add Category";
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    self.navigationItem.rightBarButtonItem = done;
    
    [done release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.categoryNameTextField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Interface Actions

- (IBAction) doneEditingField:(id)sender {
    
    [self.categoryNameTextField resignFirstResponder];
}

#pragma mark -
#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
	currentTextField = textField;
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
}

#pragma mark - Private Methods

- (void) done {
    
    [self.shoppingListDelegate addCategoryWithName:self.categoryNameTextField.text];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
