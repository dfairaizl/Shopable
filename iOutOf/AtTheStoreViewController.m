//
//  AtTheStoreViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "AtTheStoreViewController.h"
#import "AtTheStoreSectionHeader.h"

#import "Persistence.h"
#import "Utilities.h"

//Entities
#import "Store.h"
#import "Category.h"
#import "Item.h"
#import "ShoppingCart.h"

@interface AtTheStoreViewController ()
- (void) loadShoppingCart;
- (void) finishedShopping;
- (Store *) getCurrentStore;
- (void) resetShoppingCart;
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
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"At The Store";
    
    [self loadShoppingCart];
    
    //at first, don't display the search bar
	[self.shoppingCartTableView setContentOffset:CGPointMake(0,44)];
    
    if([self.cartItems count] > 0) {
       
        UIBarButtonItem *finishedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishedShopping)];
        
        self.navigationItem.rightBarButtonItem = finishedButton;
        
        [finishedButton release];
    }
    
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
    return [[self.cartItems allKeys] count];
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

/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 280, 20)];
    headerTitle.text = [self tableView:self.shoppingCartTableView titleForHeaderInSection:section];
    
    [headerView addSubview:headerTitle];
    
    return headerView;
}*/

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}*/

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

#pragma mark - UIActionSheet Delegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0) { //destructive button
        
        [self resetShoppingCart];
        
        [self.shoppingCartTableView reloadData];
    }
}

#pragma mark - Private Methods

- (void) loadShoppingCart {
    
    self.cartItems = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    Store *currentStore = [self getCurrentStore];
    
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
}

- (Store *) getCurrentStore {
    
    NSPredicate *selectedPred = [NSPredicate predicateWithFormat:@"selectedStore == %@", [NSNumber numberWithBool:YES]];
    
    //Get the current store
    NSArray *stores = [[Persistence fetchEntitiesOfType:@"Store" withPredicate:selectedPred] retain];
    Store *store = [stores lastObject]; //should be only one...
    
    return store;
}

- (void) finishedShopping {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Finished Shopping?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Empty Shopping Cart" otherButtonTitles:nil, nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [actionSheet showFromTabBar:[[[Utilities appDelegate] tabBarController] tabBar]];
    
    [actionSheet release];
}

- (void) resetShoppingCart {
    
    //clear this shopping cart
    Store *currentStore = [self getCurrentStore];
    
    ShoppingCart *currentCart = currentStore.shoppingCart;
    
    //unselect all the items
    for(Item *i in currentCart.cartItems) {
        
        i.selected = [NSNumber numberWithBool:NO];
        
    }
    
    //clean up the shopping cart
    [[Utilities managedObjectContext] deleteObject:currentStore.shoppingCart];
    [self.cartItems removeAllObjects];
}

@end
