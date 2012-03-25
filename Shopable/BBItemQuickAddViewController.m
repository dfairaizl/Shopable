//
//  BBItemQuickAddViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/12/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItemQuickAddViewController.h"
#import "BBStoresViewController.h"
#import "BBStoreShoppingViewController.h"

//Support
#import "BBStorageManager.h"

@interface BBItemQuickAddViewController ()

- (void)closeQuickAdd;

@end

@implementation BBItemQuickAddViewController

@synthesize quickAddView;
@synthesize itemNameTextField;
@synthesize closeButton;
@synthesize storeShoppingVC;
@synthesize currentShoppingCart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.quickAddView layer] setCornerRadius:10.0];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.itemNameTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setQuickAddView:nil];
    [self setItemNameTextField:nil];
    [self setCloseButton:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeButtonPressed:(id)sender {
    
    [self.itemNameTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate Methods 

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if([textField.text length] > 0) {
     
        BBItem *newItem = [BBItem newItem];
        
        newItem.name = textField.text;
        
        [self.currentShoppingCart addUncategorizedItem:newItem];
    }
    
    [self closeQuickAdd];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.itemNameTextField resignFirstResponder];
    
    return YES;
}

#pragma mark - Private Methods

- (void)closeQuickAdd {
    
    BBStoresViewController *storesVC = self.storeShoppingVC.parentStoresViewController;
    
    [UIView animateWithDuration:0.4 
                          delay:0.0 
                        options:UIViewAnimationOptionCurveLinear 
                     animations:^() {
                         
                         [storesVC.toggleShoppingButton setAlpha:1.0];
                         
                         [self.view setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         
                         [storesVC.toggleShoppingButton setEnabled:YES];
                         
                         [self.view removeFromSuperview];
                         
                         [self.storeShoppingVC refresh];
                         
                         [[BBStorageManager sharedManager] saveContext];
                     }];
}

@end
