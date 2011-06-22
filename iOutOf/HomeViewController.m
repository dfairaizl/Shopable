//
//  HomeViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 3/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "iOutOfAppDelegate.h"

#import "HomeViewController.h"
#import "ShoppingListViewController.h"

#import "Utilities.h"
#import "Persistence.h"

//Entities
#import "Store.h"
#import "StoreCategory.h"

@implementation HomeViewController

@synthesize storeTableView = _storeTableView;

@synthesize stores = _stores;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    Store *store = (Store *)[NSEntityDescription insertNewObjectForEntityForName:@"Store" inManagedObjectContext:[Utilities managedObjectContext]];
    store.Name = @"Grocery Store";
    
    StoreCategory *c = (StoreCategory *)[NSEntityDescription insertNewObjectForEntityForName:@"StoreCategory" inManagedObjectContext:[Utilities managedObjectContext]];
    c.Name = @"Baking";
    
    [store addCategoriesObject:c];
    
    [[Utilities managedObjectContext] save:nil];
    
    self.stores = [[Persistence fetchAllEntitiesOfType:@"Store" sortBy:@"Name"] retain];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Table view data source

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
    
    Store *store = [self.stores objectAtIndex:[indexPath row]];
	
	cell.textLabel.text = store.Name;
    
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


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Store *selectedStore = [self.stores objectAtIndex:indexPath.row];
    
    //ShoppingListViewController *storeShoppingList
    //storeShoppingList.currentStore = selectedStore;
    
    //Move to the Shopping List tab
    //[[[Utilities appDelegate] tabBarController] setSelectedIndex:1];
    
    //[storeShoppingList release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.storeTableView = nil;
}


- (void)dealloc {
    
    [_storeTableView release];
    [_storeTableView release];
    
    [super dealloc];
}


@end
