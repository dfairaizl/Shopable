//
//  AddItemViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 3/11/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "AddItemViewController.h"

#define kFirstRow 0
#define kQuantityComponet 0
#define kUnitComponent 1

@interface AddItemViewController (PrivateMethods)

- (void) registerForKeyboardNotifications;
- (void)keyboardWillHide:(NSNotification *)n;
- (void)keyboardWillShow:(NSNotification *)n;
- (NSDictionary *) quantitiesAndUnits:(BOOL)plural;

@end

@implementation AddItemViewController

@synthesize scrollView, itemNameTextField, itemQuantityTextField, itemNotesTextView, quantityPicker, itemListDelegate;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];
	
	[self registerForKeyboardNotifications];
	
	self.title = @"Add Item";
	self.navigationController.navigationBarHidden = NO;
	
	[self.scrollView setContentSize:CGSizeMake(320, 416)];

	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
	
	self.navigationItem.leftBarButtonItem = cancelButton;
	self.navigationItem.rightBarButtonItem = doneButton;
	
	[cancelButton release];
	[doneButton release];
	
	keyboardIsOpen = NO;
	[self.itemNameTextField becomeFirstResponder];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Interface Actions

- (IBAction) doneEditingField:(id)sender {
	
	[self.itemNameTextField resignFirstResponder];
	[self.itemQuantityTextField resignFirstResponder];
	[self.itemNotesTextView resignFirstResponder];
}

#pragma mark -
#pragma mark Navbar Button Methods

- (void) cancel {
	
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL) done {
	
	if([self.itemNameTextField.text length] > 0) {
		
		[self.itemListDelegate addItemToCategory:self.itemNameTextField.text 
									withQuantity:self.itemQuantityTextField.text 
										andNotes:self.itemNotesTextView.text];
		
		[self dismissModalViewControllerAnimated:YES];
		
		return YES;
	}
	
	return NO;
}

#pragma mark -
#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

	currentTextField = textField;
	
	if(textField == self.itemQuantityTextField) {
	
		[self showQuantityInputPicker];
		//return NO;
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
		CGPoint offset = CGPointMake(self.view.frame.origin.x, currentTextField.frame.origin.y - 68 + currentTextField.frame.size.height);
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

- (NSDictionary *) quantitiesAndUnits:(BOOL)plural {
    
    if(!plural)
        return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ItemQuantitiesSingular" ofType:@"plist"]];
    else
        return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ItemQuantitiesPlural" ofType:@"plist"]];
}

#pragma mark -
#pragma mark UIPicker Methods

- (void) showQuantityInputPicker {
	
	self.itemQuantityTextField.inputView = self.quantityPicker;
	
	//put in the first value
	[self pickerView:self.quantityPicker didSelectRow:0 inComponent:0];
}

#pragma mark -
#pragma mark UIPicker Delegate and Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return [[[self quantitiesAndUnits:YES] allKeys] count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	
	NSString *key = component == kFirstRow ? @"Quantity" : @"Unit";
	return [[[self quantitiesAndUnits:YES] objectForKey:key] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
	NSString *key = component == kFirstRow ? @"Quantity" : @"Unit";
    
    NSInteger quantityRow = [self.quantityPicker selectedRowInComponent:0];
    
    if(quantityRow == 0)
        return [[[self quantitiesAndUnits:NO] objectForKey:key] objectAtIndex:row];
    else
        return [[[self quantitiesAndUnits:YES] objectForKey:key] objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

	NSInteger quantityRow = [self.quantityPicker selectedRowInComponent:0];
	NSInteger unitRow = [self.quantityPicker selectedRowInComponent:1];
	
	NSString *quantity = [self pickerView:self.quantityPicker titleForRow:quantityRow forComponent:0];
	NSString *unit = [self pickerView:self.quantityPicker titleForRow:unitRow forComponent:1];
	
	if(unitRow != kFirstRow)
		self.itemQuantityTextField.text = [NSString stringWithFormat:@"%@ %@", quantity, unit];
	else
		self.itemQuantityTextField.text = [NSString stringWithFormat:@"%@", quantity];
    
    [self.quantityPicker reloadComponent:kUnitComponent];
}

#pragma mark -
#pragma mark Memory Management

- (void) viewWillDisappear:(BOOL)animated {

	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.scrollView = nil;
	self.itemNameTextField = nil;
	self.itemQuantityTextField = nil;
	self.itemNotesTextView = nil;
	self.quantityPicker = nil;
}


- (void)dealloc {
	
	[itemNotesTextView release];
	[itemQuantityTextField release];
	[itemNameTextField release];
	[itemListDelegate release];
	[quantityPicker release];
	[scrollView release];
	[quantitiesAndUnits release];
	
    [super dealloc];
}


@end
