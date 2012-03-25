//
//  BBAddItemTableViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBAddItemTableViewController.h"

#import "BBStorageManager.h"

@implementation BBAddItemTableViewController

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
 
    self.addedItem = [BBItem newItem];
    self.addedItem.parentItemCategory = self.currentItemCategory;
    
    self.shoppingItem = [[self.currentStore currentShoppingCart] addItemToCart:self.addedItem];
}

- (void)viewDidUnload
{
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

#pragma mark - UI Action Methods

- (IBAction)saveButtonPressed:(id)sender {
    
    if([self.addedItem.name length] <= 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Save Item" 
                                                        message:@"Please enter a name for this item" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"okay" 
                                              otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else {
     
        [super saveButtonPressed:sender];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    [[[BBStorageManager sharedManager] managedObjectContext] deleteObject:self.shoppingItem];
    [[[BBStorageManager sharedManager] managedObjectContext] deleteObject:self.addedItem];
    
    [super saveButtonPressed:sender];
}

@end
