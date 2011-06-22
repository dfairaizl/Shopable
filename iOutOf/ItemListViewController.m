//
//  ItemListViewController.m
//  AllOutOf
//
//  Created by Dan Fairaizl on 3/8/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "ItemListViewController.h"
#import "AddItemViewController.h"
#import "Utilities.h"

#pragma mark -
#pragma mark Private Extention Methods

@interface ItemListViewController()

@property (nonatomic, retain) NSString *_currentCategory;
@property (nonatomic, retain) NSString *_categoryID;
@property (nonatomic, retain) NSMutableDictionary *_itemList;
@property (nonatomic, retain) NSMutableSet *_itemsInShoppingCart;

- (void) addItemToCart:(NSUInteger)itemId;
- (void) removeItemToCart:(NSUInteger)itemId;
- (void) loadItemsFromCategory;
- (void) loadItemsFromShoppingList;

@end

#pragma mark -
#pragma mark ItemListViewController

@implementation ItemListViewController

@synthesize _currentCategory, _categoryID, _itemList, _itemsInShoppingCart;

- (id) initWithCategory:(NSString *)category andId:(NSString *)theId {
	
	if((self = [super initWithNibName:@"ItemListViewController" bundle:nil])) {
	
		self._currentCategory = category;
		self._categoryID = theId;
	}
	
	return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
 
	[super viewDidLoad];
	
	//Add the 'Add Item' button
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
}

- (void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];
	
	//get the items in this category
	_itemList = [[NSMutableDictionary alloc] initWithCapacity:20];
	[self loadItemsFromCategory];
	
	//get any items from this category that might be in the shopping list already
	_itemsInShoppingCart = [[NSMutableSet alloc] initWithCapacity:10];
	[self loadItemsFromShoppingList];
	
	self.title = self._currentCategory;
	
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
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
    return [self._itemList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	//cell.textLabel.text = //[[[self._itemList allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.row];
	
	/*NSArray *allKeys = [self._itemList allKeys];
	NSArray *sorted = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
    Item *currentItem = [self._itemList objectForKey:[sorted objectAtIndex:indexPath.row]];
	
	cell.textLabel.text = currentItem.itemName;
	
	if(currentItem.inCart)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;*/
	
    return cell;
}


// Override to support conditional editing of the table view.
/*- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	
	NSArray *allKeys = [self._itemList allKeys];
	NSArray *sorted = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
    Item *currentItem = [self._itemList objectForKey:[sorted objectAtIndex:indexPath.row]];
	
	if(currentItem.userAdded)
		return YES;
	else
		return NO;
}*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

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
	
	/*NSArray *sortedKeys = [[self._itemList allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
    Item *currentItem = [self._itemList objectForKey:[sortedKeys objectAtIndex:indexPath.row]];
	
	//Check it
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	
	if(cell.accessoryType == UITableViewCellAccessoryNone) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		[self addItemToCart:currentItem.itemId];
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		[self removeItemToCart:currentItem.itemId];
	}
		
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];*/
}

#pragma mark -
#pragma mark Private Methods

- (void) addItem {
	
	AddItemViewController *addItem = [[AddItemViewController alloc] initWithNibName:@"AddItemViewController" bundle:nil];
	addItem.itemListDelegate = self;
	
	UINavigationController *modalNav = [[UINavigationController alloc] initWithRootViewController:addItem];
	[self.navigationController presentModalViewController:modalNav animated:YES];
	[addItem release];
	
}

- (void) addItemToCart:(NSUInteger)itemId {

	//add the selected item into the cart table.
	
	//[[DbAdapter sharedDbAdapter] runInsert:[NSString stringWithFormat:@"INSERT INTO shopping_list (item_id, category_id) VALUES (%i, %i)", itemId, [self._categoryID intValue]]];
}

- (void) removeItemToCart:(NSUInteger)itemId {
	
	//remove the selected item from the cart table.
	
	//[[DbAdapter sharedDbAdapter] runDelete:[NSString stringWithFormat:@"DELETE FROM shopping_list WHERE item_id=%@", [NSNumber numberWithInt:itemId]]];
	
}

- (void) loadItemsFromCategory {
	
	/*FMResultSet *rs = [[DbAdapter sharedDbAdapter] runSelect:[NSString stringWithFormat:@"SELECT * FROM items WHERE category_id=%@", self._categoryID]];
	
    while ([rs next]) {
		
		Item *item = [[Item alloc] init];
		
		NSString *itemId = [NSString stringWithUTF8String:(const char*)[rs UTF8StringForColumnName:@"serial"]];
		
		item.itemId = [itemId intValue];
		item.itemName = [NSString stringWithUTF8String:(const char*)[rs UTF8StringForColumnName:@"item_name"]];
		
		[self._itemList setObject:item forKey:itemId];
	}
	
	[rs close];
	//[db close];*/
}

- (void) loadItemsFromShoppingList {
	
	/*FMResultSet *rs = [[DbAdapter sharedDbAdapter] runSelect:
										[NSString stringWithFormat:@"SELECT * FROM shopping_list WHERE category_id=%@", self._categoryID]];
	
    while([rs next]) {
		
		NSString *item_id = [NSString stringWithUTF8String:(const char*)[rs UTF8StringForColumnName:@"item_id"]];
		
		if([[self._itemList allKeys] containsObject:item_id])
			[(Item *)[self._itemList objectForKey:item_id] setInCart:YES];
	}
	
	[rs close];*/
}

#pragma mark -
#pragma mark AddItemDelegate Methods

- (void) addItemToCategory:(NSString *)newItem withQuantity:(NSString *)quantity andNotes:(NSString *)notes {
	
	/*[[DbAdapter sharedDbAdapter] runInsert:
	 [NSString stringWithFormat:@"INSERT INTO items (category_id, item_name, user_added, quantity, notes) VALUES('%@', '%@', '%@', '%@', '%@')",
								self._categoryID, newItem, [NSNumber numberWithBool:YES], quantity, notes]];
	
	//added a user defined item, now lets select it for them
	FMResultSet *rs = [[DbAdapter sharedDbAdapter] runSelect:[NSString stringWithFormat:@"SELECT serial FROM items WHERE item_name='%@'", newItem]];
	
	NSString *newItemId;
	
    if([rs next]) {
		
		newItemId = [NSString stringWithUTF8String:(const char*)[rs UTF8StringForColumnName:@"serial"]];
	}
	
	[rs close];
	
	[self addItemToCart:[newItemId intValue]];*/
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	
	[_currentCategory release];
	[_categoryID release];
	[_itemList release];
	[_itemsInShoppingCart release];
	
    [super dealloc];
}


@end

