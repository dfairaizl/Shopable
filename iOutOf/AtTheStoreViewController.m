//
//  AtTheStoreViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "AtTheStoreViewController.h"
#import "Persistence.h"
#import "Utilities.h"

//Entities
#import "Store.h"
#import "Category.h"
#import "Item.h"
#import "ShoppingCart.h"

@interface AtTheStoreViewController ()
    - (void) loadShoppingCart;
@end

@implementation AtTheStoreViewController

@synthesize shoppingCartTableView = _shoppingCartTableView;
@synthesize cartItems = _cartItems;

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
    [_cartItems release];
    [_shoppingCartTableView release];
    
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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"At The Store";
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //at first, don't display the search bar
	[self.shoppingCartTableView setContentOffset:CGPointMake(0,44)];
    
    [self loadShoppingCart];
    
    [self.shoppingCartTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.shoppingCartTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSUInteger c  = [[self.cartItems allKeys] count];
    NSLog(@"sections: %i", c);
    return c;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSArray *allKeys = [self.cartItems allKeys];
    
	NSArray *sorted = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
    NSArray *d = [self.cartItems objectForKey:[sorted objectAtIndex:section]];
	
	return [d count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
	return [[[self.cartItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ItemTableViewCell *cell = (ItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemTableViewCellIdentifier"];
    
	if (cell == nil) {
        
		cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemTableViewCell" owner:self options:nil] objectAtIndex:0];
		
		cell.tableDelegate = self;
		[cell setGesture];
	}
    
    // Configure the cell...
	NSArray *allKeys = [self.cartItems allKeys];
	NSArray *sorted = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
    NSArray *items = [self.cartItems objectForKey:[sorted objectAtIndex:indexPath.section]];
    NSUInteger index = indexPath.row;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    items = [items sortedArrayUsingDescriptors:sortDescriptors];
    
    [sortDescriptor release];
    
	Item *item = [items objectAtIndex:index];
    
    cell.cellItem = item;
	
	if([item.checkedOff boolValue])
		cell.itemLabel.strikeThrough = YES;
	else
		cell.itemLabel.strikeThrough = NO;
	
	//cell.cellItem = item;
	cell.itemLabel.text = item.name;
	
	if([item.quantity length] > 0)
		cell.quantityLabel.text = [NSString stringWithFormat:@"x %@", item.quantity];
	else
		cell.quantityLabel.text = @"";
    
    //If the item has notes then show the disclosure icon and allow the cell to be selectable
    if([item.notes length] > 0) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
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
    
    NSArray *allKeys = [self.cartItems allKeys];
	NSArray *sorted = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
    NSArray *items = [self.cartItems objectForKey:[sorted objectAtIndex:indexPath.section]];
    NSUInteger index = indexPath.row;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    items = [items sortedArrayUsingDescriptors:sortDescriptors];
    
    [sortDescriptor release];
    
	Item *item = [items objectAtIndex:index];
    
    if([item.notes length] > 0) {
        
        EditItemViewController *editItem = [[EditItemViewController alloc] initWithNibName:@"EditItemViewController" bundle:nil];
        
        editItem.editingItem = item;
        
        UINavigationController *modalNav = [[UINavigationController alloc] initWithRootViewController:editItem];
        [self.navigationController presentModalViewController:modalNav animated:YES];
        [editItem release];
    }
}

#pragma mark - Private Methods

- (void) loadShoppingCart {
    
    _cartItems = [[NSMutableDictionary alloc] initWithCapacity:30];
    
    NSPredicate *selectedPred = [NSPredicate predicateWithFormat:@"selectedStore == %@", [NSNumber numberWithBool:YES]];
    
    //Get the current store
    NSArray *stores = [[Persistence fetchEntitiesOfType:@"Store" withPredicate:selectedPred] retain];
    Store *currentStore = [stores lastObject]; //should be only one...
    
    if(currentStore) {
        
        ShoppingCart *cart = currentStore.shoppingCart;
        
        for(Item *item in cart.cartItems) {
            
            NSString *key = item.itemToCategory.name;
            
            if([[self.cartItems allKeys] containsObject:key]) {
                
                NSMutableArray *a = [self.cartItems objectForKey:key];
                [a addObject:item];
                
            } else {
                
                NSMutableArray *a = [NSMutableArray arrayWithObject:item];
                [self.cartItems setObject:a forKey:key];
            }
        }
    }
    
    NSLog(@"items: %i", [self.cartItems count]);
}

#pragma mark - Edit Item Delegate

- (void) editItemInShoppingCart:(NSString *)newName withQuantity:(NSString *)newQuantity andNotes:(NSString *)newNotes {
    
    
}

@end
