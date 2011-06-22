//
//  AtTheStoreViewController.m
//  AllOutOf
//
//  Created by Dan Fairaizl on 3/7/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "AtTheStoreViewController.h"

#import "EditItemViewController.h"

//Support
#import "Utilities.h"

//Entities

@interface AtTheStoreViewController ()

@property (nonatomic, retain) NSMutableDictionary *_items;

- (void) loadShoppingList;
- (NSString *) getCategoryNameWithId:(NSUInteger) categoryId;
- (NSArray *) getItemsInCategory:(NSUInteger)categoryId;

@end

@implementation AtTheStoreViewController

@synthesize _items, searchBar;

#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)viewWillAppear:(BOOL)animated {
   
	[super viewWillAppear:animated];
	
	self.title = @"At The Store";
	
	//load the data into the shopping list
	self._items = [[NSMutableDictionary alloc] initWithCapacity:30];
	[self loadShoppingList];
	
	//at first, don't display the search bar
	[self.tableView setContentOffset:CGPointMake(0,44)];
	
	//load our data into the table
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
    return [[self._items allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSArray *allKeys = [self._items allKeys];
	NSArray *sorted = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
    NSArray *d = [self._items objectForKey:[sorted objectAtIndex:section]];
	
	return [d count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

	return [[[self._items allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
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
	/*NSArray *allKeys = [self._items allKeys];
	NSArray *sorted = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
    NSArray *items = [self._items objectForKey:[sorted objectAtIndex:indexPath.section]];
    
	Item *item = [items objectAtIndex:indexPath.row];
	
	if(item.checkedOff)
		cell.itemLabel.strikeThrough = YES;
	else
		cell.itemLabel.strikeThrough = NO;
	
	cell.cellItem = item;
	cell.itemLabel.text = item.itemName;
	
	if(![item.quantity isEqualToString:@""])
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
    }*/
	
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
    
    //see if the cell is selectable with (has notes)
	/*NSArray *allKeys = [self._items allKeys];
	NSArray *sorted = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
    NSArray *items = [self._items objectForKey:[sorted objectAtIndex:indexPath.section]];
    
	Item *item = [items objectAtIndex:indexPath.row];
    
    if([item.notes length] > 0) {
     
        EditItemViewController *editItem = [[EditItemViewController alloc] initWithNibName:@"AddItemViewController" bundle:nil];
        
        UINavigationController *modalNav = [[UINavigationController alloc] initWithRootViewController:editItem];
        [self.navigationController presentModalViewController:modalNav animated:YES];
        [editItem release];
    }*/
}

#pragma mark -
#pragma mark Private Methods

- (void) loadShoppingList {

	/*FMResultSet *sections = [[DbAdapter sharedDbAdapter] runSelect:@"SELECT * FROM shopping_list"];
	
    while ([sections next]) {
		
		NSString *cat_id = [NSString stringWithUTF8String:(const char*)[sections UTF8StringForColumnName:@"category_id"]];
		
		NSString *categoryName = [self getCategoryNameWithId:[cat_id intValue]];
		
		NSArray *tempItems = [NSArray arrayWithArray:[self getItemsInCategory:[cat_id intValue]]];
		NSMutableArray *itemsForSection = [[NSMutableArray alloc] initWithCapacity:[tempItems count]];
		
		[itemsForSection addObjectsFromArray:tempItems];
		
		[self._items setObject:itemsForSection forKey:categoryName];
		
		[itemsForSection release];
	}
	
	[sections close];*/
}

- (NSString *) getCategoryNameWithId:(NSUInteger) categoryId {

	/*NSString *category_name;
	
	FMResultSet *rs = [[DbAdapter sharedDbAdapter] runSelect:[NSString stringWithFormat:@"SELECT category_name FROM categories WHERE serial=%i", categoryId]];
	
    while ([rs next]) {
		
		category_name = [NSString stringWithUTF8String:(const char*)[rs UTF8StringForColumnName:@"category_name"]];
	}
	
	[rs close];
	
	return category_name;*/
}

- (NSArray *) getItemsInCategory:(NSUInteger)categoryId {
	
	/*FMResultSet *rs;
	rs = [[DbAdapter sharedDbAdapter] runSelect:[NSString stringWithFormat:@"SELECT * FROM shopping_list WHERE category_id=%i", categoryId]];
	
	NSMutableArray *items = [[[NSMutableArray alloc] initWithCapacity:30] autorelease];
	
	while ([rs next]) {
		
		NSUInteger itemId = [rs intForColumn:@"item_id"];
		
		Item *item = [[Item alloc] init];
		
		//get the item name
		FMResultSet *itemResults = [[DbAdapter sharedDbAdapter] runSelect:
						   [NSString stringWithFormat:@"SELECT item_name, quantity, notes FROM items WHERE serial=%i", itemId]];
		
		if([itemResults next]) {
			item.itemName = [NSString stringWithUTF8String:(const char*)[itemResults UTF8StringForColumnName:@"item_name"]];
			item.quantity = [NSString stringWithUTF8String:(const char*)[itemResults UTF8StringForColumnName:@"quantity"]];
			item.notes = [NSString stringWithUTF8String:(const char*)[itemResults UTF8StringForColumnName:@"notes"]];
		}
		
		[itemResults close];
		
		item.itemId = itemId;
		item.checkedOff = [rs boolForColumn:@"checked_off"] == 0 ? NO : YES;
		
		[items addObject:item];
		[item release];
	}
	
	[rs close];
	
	return items;*/
}

#pragma mark -
#pragma mark AtTheStoreTableViewDelegate

- (void) checkOffItem:(Item *)theItem checked:(BOOL)isChecked {
	
	/*[[DbAdapter sharedDbAdapter] runUpdate:[NSString stringWithFormat:@"UPDATE shopping_list SET checked_off=%i WHERE item_id=%i", 
											isChecked ? 1 : 0,
											theItem.itemId]];*/
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
	
	self.searchBar = nil;
}


- (void)dealloc {
	
	[_items release];
	[searchBar release];
	
    [super dealloc];
}


@end

