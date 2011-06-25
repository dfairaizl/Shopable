//
//  ItemsListViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "ItemsListViewController.h"
#import "Persistence.h"
#import "Utilities.h"

#import "Store.h"
#import "Category.h"
#import "Item.h"
#import "ShoppingCart.h"

@interface ItemsListViewController (Private)
    - (void) addItemToCart:(Item *)item;
    - (void) removeItemFromCart:(Item *)item;
    - (void) addItem;
@end

@implementation ItemsListViewController

@synthesize currentCategory = _currentCategory;
@synthesize items = _items;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_items release];
    
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
    
    //Add the 'Add Item' button
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
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
    
    self.title = self.currentCategory.name;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    self.items = [[self.currentCategory.items allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    
    [sortDescriptor release];
    
    [self.tableView reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    Item *item = [self.items objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.name;
    
    if([item.selected boolValue])
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    else
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *currentItem = [self.items objectAtIndex:indexPath.row];
	
	//Check it
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	
	if(cell.accessoryType == UITableViewCellAccessoryNone) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		[self addItemToCart:currentItem];
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		[self removeItemFromCart:currentItem];
	}
    
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

- (void) addItem {
	
	AddItemViewController *addItem = [[AddItemViewController alloc] initWithNibName:@"AddItemViewController" bundle:nil];
	addItem.itemListDelegate = self;
	
	UINavigationController *modalNav = [[UINavigationController alloc] initWithRootViewController:addItem];
	[self.navigationController presentModalViewController:modalNav animated:YES];
	
    [addItem release];
	[modalNav release];
}

- (void) addItemToCart:(Item *)item {
    
    Store *currentStore = self.currentCategory.categoryToStore;
    ShoppingCart *currentShoppingCart = currentStore.shoppingCart;
    
    if(!currentShoppingCart) {
        currentShoppingCart = [Persistence entityOfType:@"ShoppingCart"];
    }
    
    [currentShoppingCart addCartItemsObject:item];
    
    //Set the shopping cart
    currentStore.shoppingCart = currentShoppingCart;
}

- (void) removeItemFromCart:(Item *)item {
    
    Store *currentStore = self.currentCategory.categoryToStore;
    ShoppingCart *currentShoppingCart = currentStore.shoppingCart; //will always have a shopping cart if we are removing an item
    
    [currentShoppingCart removeCartItemsObject:item];
}

#pragma mark - Add Item Delegate Methods

- (void) addItemToCategory:(NSString *)newItem withQuantity:(NSString *)quantity andNotes:(NSString *)notes {
    
    Item *item = (Item*)[Persistence entityOfType:@"Item"];
    
    item.name = newItem;
    item.quantity = quantity;
    item.notes = notes;
    item.selected = [NSNumber numberWithBool:YES];
    
    [self addItemToCart:item];
    [self.currentCategory addItemsObject:item];
}

@end
