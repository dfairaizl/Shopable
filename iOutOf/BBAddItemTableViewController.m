//
//  BBAddItemTableViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBAddItemTableViewController.h"

#import "BBStorageManager.h"

@interface BBAddItemTableViewController ()

@property (strong, nonatomic) BBItem *shoppingItem; 
@property (strong, nonatomic) NSDictionary *quantitiesUnitsPList;
@property (strong, nonatomic) NSArray *quantities;
@property (strong, nonatomic) NSArray *units;

- (void)updateQuantityAndUnits;

@end

@implementation BBAddItemTableViewController

@synthesize currentStore;
@synthesize currentItemCategory;
@synthesize itemNameTextField;
@synthesize itemQuantityTextField;
@synthesize quantityPickerView;
@synthesize quantityPickerViewToolbar;
@synthesize notesCellLabel;
@synthesize quantitiesUnitsPList;
@synthesize shoppingItem;
@synthesize quantities;
@synthesize units;

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
    
    self.shoppingItem = [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_ITEM inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
}

- (void)viewDidUnload
{
    [self setNotesCellLabel:nil];
    [self setItemNameTextField:nil];
    [self setItemQuantityTextField:nil];
    [self setQuantityPickerView:nil];
    [self setQuantityPickerViewToolbar:nil];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"addNotesSegue"]) {

        BBAddItemNotesViewController *vc = (BBAddItemNotesViewController *)segue.destinationViewController;
        
        vc.delegate = self;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - UI Action Methods

- (IBAction)saveButtonPressed:(id)sender {

    self.shoppingItem.parentItemCategory = self.currentItemCategory;
    self.shoppingItem.isCustom = [NSNumber numberWithBool:YES];
    
    [self.currentStore.shoppingCart addItemToCart:self.shoppingItem];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    [[[BBStorageManager sharedManager] managedObjectContext] deleteObject:self.shoppingItem];

    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)pickerClearButtonPressed:(id)sender {
 
    self.itemQuantityTextField.text = [NSString stringWithString:@""];
    
    self.shoppingItem.quantity = [NSString stringWithString:@""];
    self.shoppingItem.units = [NSString stringWithString:@""];
    
    quantityRow = 0;
    unitsRow = 0;
    
    [self.quantityPickerView selectRow:0 inComponent:bbPickerComponentQuantity animated:YES];
    [self.quantityPickerView selectRow:0 inComponent:bbPickerComponentUnits animated:YES];
    
    [self updateQuantityAndUnits];
}

- (IBAction)pickerDoneButtonPressed:(id)sender {
    
    [self updateQuantityAndUnits];
    
    [self.itemQuantityTextField resignFirstResponder];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(textField == self.itemQuantityTextField) {
        
        if(self.quantitiesUnitsPList == nil) {
            self.quantitiesUnitsPList = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"QuantityUnits" withExtension:@"plist"]];
        }
        
        self.quantities = [NSArray arrayWithArray:[self.quantitiesUnitsPList objectForKey:@"Quantities"]];
        
        //load units based on prior selection (if any)
        if([self.shoppingItem.quantity isEqualToString:@"1"] == YES || self.shoppingItem.quantity == nil) {
            self.units = [NSArray arrayWithArray:[self.quantitiesUnitsPList objectForKey:@"UnitsSingular"]];
        }
        else {
            self.units = [NSArray arrayWithArray:[self.quantitiesUnitsPList objectForKey:@"UnitsPlural"]];
        }
        
        if([self.itemQuantityTextField.text length] <= 0) {
            self.itemQuantityTextField.text = [NSString stringWithFormat:@"%@", [self.quantities objectAtIndex:0]];
            self.shoppingItem.quantity = [self.quantities objectAtIndex:0];
        }
                           
        textField.inputView = self.quantityPickerView;
        textField.inputAccessoryView = self.quantityPickerViewToolbar;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if(textField == self.itemNameTextField) {
        self.shoppingItem.name = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UIPickerView Delegate Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return bbPickerNumberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger count = 0;
    
    if(component == bbPickerComponentQuantity) {
        count = [self.quantities count];
    }
    else if(component == bbPickerComponentUnits) {
        count = [self.units count];
    }
    
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    NSString *title = nil;
    
    if(component == bbPickerComponentQuantity) {
        title = [self.quantities objectAtIndex:row];
    }
    else if(component == bbPickerComponentUnits) {
        title = [self.units objectAtIndex:row];
    }

    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if(component == bbPickerComponentQuantity) {
        
        //check if quantity selected was greater than 1
        if([[self.quantities objectAtIndex:row] isEqualToString:@"1"] == NO) {
            
            self.units = [NSArray arrayWithArray:[quantitiesUnitsPList objectForKey:@"UnitsPlural"]];
            
            [self.quantityPickerView reloadComponent:bbPickerComponentUnits];
        }
        else {
         
            self.units = [NSArray arrayWithArray:[self.quantitiesUnitsPList objectForKey:@"UnitsSingular"]];
            
            [self.quantityPickerView reloadComponent:bbPickerComponentUnits];
        }
        
        quantityRow = row;
    }
    else if(component == bbPickerComponentUnits) {
        
        unitsRow = row;
    }
    
    [self updateQuantityAndUnits];
}

#pragma mark - BBAddItemNotesDelegate Methods

- (void)addNotesToItem:(NSString *)notes {
    
    self.shoppingItem.notes = notes;
    
    self.notesCellLabel.text = notes;
}

#pragma mark - Private Methods

- (void)updateQuantityAndUnits {
    
    NSString *quantity = [self pickerView:self.quantityPickerView titleForRow:quantityRow forComponent:bbPickerComponentQuantity];
    NSString *unit = [self pickerView:self.quantityPickerView titleForRow:unitsRow forComponent:bbPickerComponentUnits];
    
    if([quantity length] || [unit length]) {
        self.itemQuantityTextField.text = [NSString stringWithFormat:@"%@ %@", quantity, unit];
    }
    
    self.shoppingItem.quantity = quantity;
    self.shoppingItem.units = unit;
}

@end
