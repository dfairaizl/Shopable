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
#import "StoreType.h"

@implementation AddStoreViewController

@synthesize storeNameTextField = _storeNameTextField;
@synthesize storeTypeTextField = _storeTypeTextField;
@synthesize storeTypePicker = _storeTypePicker;

@synthesize storeTypes = _storeTypes;

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
    [_storeTypeTextField release];
    [_storeTypePicker release];
    
    [_storeTypes release];
    
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
    
    self.storeTypes = [[Persistence fetchAllEntitiesOfType:@"StoreType" sortBy:@"type"] retain];
    NSLog(@"Number of types: %i", [self.storeTypes count]);
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
         
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.rightBarButtonItem = done;
    
    [cancel release];
    [done release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.storeNameTextField = nil;
    self.storeTypeTextField = nil;
    self.storeTypePicker = nil;
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
#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
	currentTextField = textField;
	
	if(textField == self.storeTypeTextField) {
        
		[self showStoreTypePicker];
	}
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
}

#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
	currentTextField = textView;
	
	return YES;
}

#pragma mark -
#pragma mark Private Methods

- (void)keyboardWillShow:(NSNotification *)n {
	
	if (keyboardIsOpen) {
        return;
    }
	
    NSDictionary* userInfo = [n userInfo];
	
	// Get animation info from userInfo
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	CGRect keyboardEndFrame;
	
	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
	
	if(currentTextField.frame.origin.y >= keyboardFrame.size.height) {
		CGPoint offset = CGPointMake(self.view.frame.origin.x, currentTextField.frame.origin.y - 108 + currentTextField.frame.size.height);
		[self.scrollView setContentOffset:offset animated:NO];
	}
	
	self.scrollView.bounces = YES;
	
	[self.scrollView setContentSize:CGSizeMake(320, 416)];
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    [self.scrollView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 
										 self.scrollView.frame.size.height - keyboardFrame.size.height)];
	
    [UIView commitAnimations];
	
    keyboardIsOpen = YES;
}

- (void)keyboardWillHide:(NSNotification *)n {
	
	NSDictionary* userInfo = [n userInfo];
	
	// Get animation info from userInfo
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	CGRect keyboardEndFrame;
	
	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
	
	self.scrollView.bounces = NO;
	
	[self.scrollView setContentSize:CGSizeMake(320, 416)];
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    [self.scrollView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 
										 self.scrollView.frame.size.height + keyboardFrame.size.height)];
    [UIView commitAnimations];
	
    keyboardIsOpen = NO;
}

#pragma mark -
#pragma mark UIPicker Methods

- (void) showStoreTypePicker {
	
	self.storeTypeTextField.inputView = self.storeTypePicker;
	
	//put in the first value
	[self pickerView:self.storeTypePicker didSelectRow:0 inComponent:0];
}

#pragma mark -
#pragma mark UIPicker Delegate and Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	
    return [self.storeTypes count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    StoreType *storeType = [self.storeTypes objectAtIndex:row];
    
    return storeType.type;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
	NSString *typeString = [self pickerView:self.storeTypePicker titleForRow:row forComponent:0];
    
    self.storeTypeTextField.text = typeString;
}

#pragma mark -
#pragma mark Interface Actions

- (IBAction) doneEditingField:(id)sender {
	
	[self.storeNameTextField resignFirstResponder];
    [self.storeTypeTextField resignFirstResponder];
}

@end
