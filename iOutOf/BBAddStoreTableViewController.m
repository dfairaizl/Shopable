//
//  BBAddStoreTableViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBAddStoreTableViewController.h"

#import "BBStorageManager.h"

@interface BBAddStoreTableViewController ()

@property (strong, nonatomic) BBStore *shoppingStore;
@property (strong, nonatomic) NSArray *storeTypes;

@end

@implementation BBAddStoreTableViewController
@synthesize typeTextField;
@synthesize storeTypePicker;
@synthesize nameTextField;

@synthesize shoppingStore;
@synthesize storeTypes = _storeTypes;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"navbar-button-background"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"navbar-button-background"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    self.navigationItem.leftBarButtonItem = cancelBarButton;
    self.navigationItem.rightBarButtonItem = saveBarButton;
    
    self.shoppingStore = [[BBStorageManager sharedManager] addStore];
}

- (void)viewDidUnload
{
    [self setTypeTextField:nil];
    [self setNameTextField:nil];
    [self setStoreTypePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UI Actions

- (IBAction)cancelButtonPressed:(id)sender {
    
    [[[BBStorageManager sharedManager] managedObjectContext] deleteObject:self.shoppingStore];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    if([self.shoppingStore.name length] <= 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Store Name" message:@"Please enter a store name" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else {
     
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(textField == self.typeTextField) {
        
        //load the store type values from pList
        NSDictionary *storeTypesPList = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"StoreTypes" withExtension:@"plist"]];
        self.storeTypes = [NSArray arrayWithArray:[storeTypesPList objectForKey:@"StoreTypes"]];
        
        textField.inputView = self.storeTypePicker;
        
        textField.text = [self.storeTypes objectAtIndex:0];
        
        //set the initial values in the store object
        self.shoppingStore.type = [NSNumber numberWithInt:bbStoreTypeDepartment];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if(textField == self.nameTextField) {
        self.shoppingStore.name = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
     
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UIPickerView Delegate Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
 
    return [self.storeTypes count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self.storeTypes objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.typeTextField.text = [self.storeTypes objectAtIndex:row];
    self.shoppingStore.type = [NSNumber numberWithInt:row];
}

@end
