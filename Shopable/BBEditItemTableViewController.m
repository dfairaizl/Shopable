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
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbar-button-background"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    self.navigationItem.rightBarButtonItem = nil;
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
        
    //If a user DOES NOT add quantity, notes or picture, remove it from the cart
    if([self.shoppingItem.quantity length] == 0 && [self.shoppingItem.notes length] == 0 && [self.shoppingItem.image length] == 0) {
        
        [[self.currentStore currentShoppingCart] removeItemFromCart:self.shoppingItem];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
