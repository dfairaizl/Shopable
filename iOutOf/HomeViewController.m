//
//  HomeViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "iOutOfAppDelegate.h"
#import "HomeViewController.h"
#import "AddStoreViewController.h"
#import "ShoppingListViewController.h"
#import "Persistence.h"
#import "Utilities.h"

//Entities
#import "Store.h"
#import "Category.h"

@implementation HomeViewController

@synthesize storesTableView = _storesTableView;
@synthesize otherStoreButton = _otherStoreButton;

@synthesize stores = _stores;

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
    [_storesTableView release];
    [_otherStoreButton release];
    
    [_stores release];
    
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
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.stores = [[Persistence fetchAllEntitiesOfType:kStore sortBy:@"name"] retain];
    
    UIView *storeFooter = [[[NSBundle mainBundle] loadNibNamed:@"AddStoreFooter" owner:self options:nil] lastObject];
    self.storesTableView.tableFooterView = storeFooter;
    
    [self.storesTableView reloadData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.storesTableView = nil;
    self.otherStoreButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Actions

- (IBAction) otherStoreButtonPress:(id)sender {
    
    AddStoreViewController *addStore = [[AddStoreViewController alloc] initWithNibName:@"AddStoreViewController" bundle:nil];
    
    UINavigationController *modalNav = [[UINavigationController alloc] initWithRootViewController:addStore];
	[self.navigationController presentModalViewController:modalNav animated:YES];
	
    [addStore release];
    [modalNav release];
}


#pragma mark -
#pragma mark Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.stores count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    Store *store = [self.stores objectAtIndex:indexPath.row];
    
    cell.textLabel.text = store.name;
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

#pragma mark -
#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    Store *selectedStore = [self.stores objectAtIndex:indexPath.row];
    selectedStore.selectedStore = [NSNumber numberWithBool:YES];
    
    ShoppingListViewController *shoppingList = [[Utilities appDelegate] shoppingListScreen];
    shoppingList.currentStore = selectedStore;
    
    [self.storesTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[[Utilities appDelegate] tabBarController] setSelectedIndex:1];
}

@end
