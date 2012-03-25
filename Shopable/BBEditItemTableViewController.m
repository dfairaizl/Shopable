//
//  BBEditItemTableViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/10/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBEditItemTableViewController.h"

#import "BBStorageManager.h"

@implementation BBEditItemTableViewController

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
    
    self.title = self.shoppingItem.item.name;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    if([self.shoppingItem.quantity length] || [self.shoppingItem.units length]) {
        self.itemQuantityTextField.text = [NSString stringWithFormat:@"%@ %@", self.shoppingItem.quantity , self.shoppingItem.units];
    }
    
    if([self.shoppingItem.notes length]) {
        self.notesCellLabel.text = self.shoppingItem.notes;
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //If a user DOES NOT add quantity, notes or picture, remove it from the cart
    if([self.shoppingItem.quantity length] == 0 && [self.shoppingItem.notes length] == 0 && [self.shoppingItem.image length] == 0) {
        
        [[self.currentStore currentShoppingCart] removeItemFromCart:self.shoppingItem];
    }
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

- (void)backButtonPressed:(id)sender {
        
    
}

@end
