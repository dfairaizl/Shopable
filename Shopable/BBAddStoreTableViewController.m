//
//  BBAddStoreTableViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBAddStoreTableViewController.h"
#import "BBStoresViewController.h"

@interface BBAddStoreTableViewController ()

@property (strong, nonatomic) BBStore *shoppingStore;
@property (strong, nonatomic) NSArray *storeTypes;

@end

@implementation BBAddStoreTableViewController

@synthesize storeDelegate;
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
    
    self.shoppingStore = [BBStore addStore];
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
    
    if(self.shoppingStore != nil && [self.storeDelegate respondsToSelector:@selector(addStore:)]) {
        
        [self.storeDelegate addStore:self.shoppingStore];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        return YES;
    }
    else {
     
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UI Actions

- (IBAction)cancelButtonPressed:(id)sender {
    
    [[[BBStorageManager sharedManager] managedObjectContext] deleteObject:self.shoppingStore];
    
    self.shoppingStore = nil;
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    if([self.shoppingStore.name length] <= 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Store Name" message:@"Please enter a store name" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else {
        
        [[BBStorageManager sharedManager] saveContext];
     
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
