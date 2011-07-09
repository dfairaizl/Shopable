//
//  ShoppingListViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "ItemsListViewController.h"

#import "Persistence.h"
#import "Utilities.h"

//Entities
#import "Store.h"
#import "StoreCategory.h"

@interface ShoppingListViewController(Private) 
- (void) addCustomCategory;
@end

@implementation ShoppingListViewController

@synthesize currentStore = _currentStore;
@synthesize categories = _categories;

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
    [_categories release];
    
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(self.currentStore == nil) {
        
        NSPredicate *search = [NSPredicate predicateWithFormat:@"selectedStore == %@", [NSNumber numberWithBool:YES]];
        
        NSArray *stores = [[Persistence fetchEntitiesOfType:@"Store" withPredicate:search] retain];
        
        self.currentStore = (Store *)[stores lastObject];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    self.categories = [[self.currentStore.categories allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    
    [sortDescriptor release];
	
    //Custom category button
    UIBarButtonItem *addCategory = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCustomCategory)];
    
    self.navigationItem.rightBarButtonItem = addCategory;
    
    [addCategory release];
    
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
    return [self.categories count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    StoreCategory *category = [self.categories objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.textLabel.text = category.name;
    
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
    // Navigation logic may go here. Create and push another view controller.
    ItemsListViewController *itemsList = [[ItemsListViewController alloc] initWithNibName:@"ItemsListViewController" bundle:nil];
    
    itemsList.currentCategory = [self.categories objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:itemsList animated:YES];
    [itemsList release];
}

#pragma mark - Private Methods

- (void) addCustomCategory {

    AddCategoryViewController *addCategory = [[AddCategoryViewController alloc] initWithNibName:@"AddCategoryViewController" bundle:nil];
    addCategory.shoppingListDelegate = self;
	
	UINavigationController *modalNav = [[UINavigationController alloc] initWithRootViewController:addCategory];
	[self.navigationController presentModalViewController:modalNav animated:YES];
	
    [addCategory release];
	[modalNav release];
}

#pragma mark - AddCategoryDelegate

- (void) addCategoryWithName:(NSString *) name {
    
    StoreCategory *newCategory = (StoreCategory *)[[Persistence entityOfType:@"StoreCategory"] retain];
    
    newCategory.name = name;
   
    [self.currentStore addCategoriesObject:newCategory];
    
    //[self.tableView reloadData];
}


@end
