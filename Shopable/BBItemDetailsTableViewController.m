//
//  BBItemDetailsTableViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 6/8/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItemDetailsTableViewController.h"

//Controllers
#import "BBItemNotesViewController.h"

//DB
#import "BBStorageManager.h"

@interface BBItemDetailsTableViewController ()

//Private Properties
@property (strong, nonatomic) NSDictionary *quantitiesUnitsPList;
@property (strong, nonatomic) NSArray *quantities;
@property (strong, nonatomic) NSArray *units;

//Private Methods
- (void)updateQuantityAndUnits;

@end

@implementation BBItemDetailsTableViewController {
    
    __weak UITextField *currentTextField;
    
    NSInteger quantityRow;
    NSInteger unitsRow;
}

@synthesize currentItem;
@synthesize quantityUnitsTextField;
@synthesize quantityUnitsPicker;
@synthesize pickerToolBar;
@synthesize itemNotesLabel;
@synthesize addPhotoLabel;
@synthesize itemPhotoImageView;

@synthesize quantitiesUnitsPList, quantities, units;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:nil 
                                                                            action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = self.currentItem.item.name;
    
    if([self.currentItem.quantity length] > 0 && [self.currentItem.units length] > 0) {
     
        self.quantityUnitsTextField.text = [NSString stringWithFormat:@"%@ %@", self.currentItem.quantity,
                                                                            self.currentItem.units];
    }
    else if([self.currentItem.quantity length] > 0) {
        
        self.quantityUnitsTextField.text = [NSString stringWithFormat:@"%@", self.currentItem.quantity];
    }
    
    self.itemNotesLabel.text = self.currentItem.notes;
    
    if(self.currentItem.photo != nil) {
        
        self.addPhotoLabel.text = @"Loading...";
        
        dispatch_async(dispatch_get_main_queue(), ^() {                 
           
            UIImage *photo = [UIImage imageWithData:self.currentItem.photo];
            
            self.itemPhotoImageView.image = photo;
            [self.addPhotoLabel setHidden:YES];
        });
    }
}

- (void)viewDidUnload
{
    [self setQuantityUnitsPicker:nil];
    [self setPickerToolBar:nil];
    [self setQuantityUnitsTextField:nil];
    [self setItemNotesLabel:nil];
    
    [self setAddPhotoLabel:nil];
    [self setItemPhotoImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"itemDetailsAddNotesSegue"]) {
        
        BBItemNotesViewController *notesVC = (BBItemNotesViewController *)segue.destinationViewController;
        
        notesVC.currentItem = self.currentItem;
    }
}

#pragma mark - IB Actions

- (IBAction)doneButtonPressed:(id)sender {
    
    [currentTextField resignFirstResponder];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2) {
        
        UIActionSheet *actionSheet = nil;
        
        if(self.currentItem.photo == nil) {
         
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"" 
                                                      delegate:self 
                                             cancelButtonTitle:@"Cancel" 
                                        destructiveButtonTitle:nil 
                                             otherButtonTitles:@"Take Photo", @"Choose From Library",
                                                            nil];
        }
        else {
            
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"" 
                                                      delegate:self 
                                             cancelButtonTitle:@"Cancel" 
                                        destructiveButtonTitle:@"Remove Image" 
                                             otherButtonTitles:@"Take Photo", @"Choose From Library",
                           nil];
        }
        
        [actionSheet showInView:self.view];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(textField == self.quantityUnitsTextField) {
        
        if(self.quantitiesUnitsPList == nil) {
            
            self.quantitiesUnitsPList = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] 
                                                                                   URLForResource:@"QuantityUnits" 
                                                                                   withExtension:@"plist"]];
        }
        
        self.quantities = [NSArray arrayWithArray:(self.quantitiesUnitsPList)[@"Quantities"]];
        
        //load units based on prior selection (if any)
        if([self.currentItem.quantity isEqualToString:@"1"] == YES || self.currentItem.quantity == nil) {
          
            self.units = [NSArray arrayWithArray:(self.quantitiesUnitsPList)[@"UnitsSingular"]];
        }
        else {
            
            self.units = [NSArray arrayWithArray:(self.quantitiesUnitsPList)[@"UnitsPlural"]];
        }
        
        if([self.quantityUnitsTextField.text length] <= 0) {
 
            self.quantityUnitsTextField.text = [NSString stringWithFormat:@"%@", (self.quantities)[0]];
            self.currentItem.quantity = (self.quantities)[0];
        }
        
        textField.inputView = self.quantityUnitsPicker;
        textField.inputAccessoryView = self.pickerToolBar;
        
        currentTextField = textField;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if([self.currentItem.quantity length] > 0) {
        
        quantityRow = [self.currentItem.quantity intValue];
        
        [self.quantityUnitsPicker selectRow:quantityRow
                                inComponent:bbPickerComponentQuantity 
                                   animated:NO];
    }
    
    if([self.currentItem.units length] > 0) {
        
        unitsRow = [self.units indexOfObject:self.currentItem.units];
        
        [self.quantityUnitsPicker selectRow:unitsRow
                                inComponent:bbPickerComponentUnits 
                                   animated:NO];
    }

}

#pragma mark - UIPickerDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return bbPickerNumberOfComponents;
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(self.currentItem.photo == nil) {
     
        if(buttonIndex <= 1) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            if(buttonIndex == 0) {
                
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                }
                else  {
                    
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                }
            }
            else if(buttonIndex == 1) {
                
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            
            imagePicker.delegate = self;
            
            [self presentModalViewController:imagePicker animated:YES];
        }
    }
    else {
        
        if(buttonIndex == 0) {
            
            self.itemPhotoImageView.image = nil;
            [self.addPhotoLabel setHidden:NO];
            
            self.currentItem.photo = nil;
        }
        else if(buttonIndex > 0 && buttonIndex <= 2) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            if(buttonIndex == 1) {
                
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                }
                else  {
                    
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                }
            }
            else if(buttonIndex == 2) {
                
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            
            imagePicker.delegate = self;
            
            [self presentModalViewController:imagePicker animated:YES];
        }
    }
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
        title = (self.quantities)[row];
    }
    else if(component == bbPickerComponentUnits) {
        title = (self.units)[row];
    }
    
    return title;
}

#pragma mark - UIPickerDelegate Methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if(component == bbPickerComponentQuantity) {
        
        //check if quantity selected was greater than 1
        if([(self.quantities)[row] isEqualToString:@"1"] == NO) {
            
            self.units = [NSArray arrayWithArray:quantitiesUnitsPList[@"UnitsPlural"]];
            
            [self.quantityUnitsPicker reloadComponent:bbPickerComponentUnits];
        }
        else {
            
            self.units = [NSArray arrayWithArray:(self.quantitiesUnitsPList)[@"UnitsSingular"]];
            
            [self.quantityUnitsPicker reloadComponent:bbPickerComponentUnits];
        }
        
        quantityRow = row;
    }
    else if(component == bbPickerComponentUnits) {
        
        unitsRow = row;
    }
    
    [self updateQuantityAndUnits];
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissModalViewControllerAnimated:YES];
    
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(selectedImage);
    
    self.currentItem.photo = imageData;
    
    self.itemPhotoImageView.image = selectedImage;
    [self.addPhotoLabel setHidden:YES];
}

#pragma mark - Private Methods

- (void)updateQuantityAndUnits {
    
    NSString *quantity = [self pickerView:self.quantityUnitsPicker 
                              titleForRow:quantityRow 
                             forComponent:bbPickerComponentQuantity];

    NSString *unit = [self pickerView:self.quantityUnitsPicker 
                          titleForRow:unitsRow 
                         forComponent:bbPickerComponentUnits];
    
    if([quantity length] || [unit length]) {
        self.quantityUnitsTextField.text = [NSString stringWithFormat:@"%@ %@", quantity, unit];
    }
    
    self.currentItem.quantity = quantity;
    self.currentItem.units = unit;
}

@end
