//
//  BBShoppingListViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 5/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

//View Controllers
#import "BBShoppingListViewController.h"
//#import "BBItemCategoryViewController.h"
#import "BBCategoriesTableViewController.h"
#import "BBShoppingListDetailsViewController.h"

//DB
#import "BBStorageManager.h"

//Cells
#import "BBShoppingListCell.h"

@interface BBShoppingListViewController (TableView)

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@interface BBShoppingListViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *searchFetchedResultsController;

@end

@implementation BBShoppingListViewController

@synthesize delegate;
@synthesize shoppingTableView = _shoppingTableView;
@synthesize itemSearchBar = _itemSearchBar;
@synthesize currentList = _currentList;

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize searchFetchedResultsController = _searchFetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:nil 
                                                                            action:nil];
    
    //setup the swipe gesture recognizer for the shopping table view to support crossing off items in list
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self 
                                                                                  action:@selector(shoppingCellSwipped:)];
    [self.shoppingTableView addGestureRecognizer:swipeGR];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setListsToolbarItemsAnimated:NO];
    
    NSError *error = nil;
    
    [self.fetchedResultsController performFetch:&error];
    
    self.fetchedResultsController.delegate = self;
    
    if(error != nil) {
        
        NSLog(@"Error fetching shopping items");
    }
    
    [self.shoppingTableView reloadData];
    
    self.shoppingTableView.contentOffset = CGPointMake(0, 44);
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.fetchedResultsController.delegate = nil;
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setShoppingTableView:nil];
    
    [self setItemSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"addItemsSegue"]) {
        
        BBCategoriesTableViewController *itemCategoryVC = (BBCategoriesTableViewController *)
                                                                [[segue destinationViewController] topViewController];
        
        itemCategoryVC.currentList = self.currentList;
    }
    else if([segue.identifier isEqualToString:@"shoppingListItemDetailsSegue"]) {
        
        BBShoppingItem *shoppingItem = (BBShoppingItem *)sender;
        BBShoppingListDetailsViewController *detailsVC = (BBShoppingListDetailsViewController *)
                                                                                    segue.destinationViewController;
        
        detailsVC.currentItem = shoppingItem;
    }
}

#pragma mark - Overrides

- (void)setCurrentList:(BBList *)currentList {
    
    _currentList = currentList;
    
    self.title = _currentList.name;
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if(_fetchedResultsController == nil) {
        
        NSManagedObjectContext *moc = [[BBStorageManager sharedManager] managedObjectContext];
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:BB_ENTITY_SHOPPING_ITEM 
                                                             inManagedObjectContext:moc];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentShoppingCart == %@", 
                                                                            [self.currentList currentShoppingCart]];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                    [NSSortDescriptor sortDescriptorWithKey:@"item.parentItemCategory.name" ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:@"item.name" ascending:YES],
                                    nil];
        
        [fetchRequest setEntity:entityDescription];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                        managedObjectContext:moc 
                                                                          sectionNameKeyPath:@"item.parentItemCategory.name"
                                                                                   cacheName:nil];
    }
    
    return _fetchedResultsController;
}

- (NSFetchedResultsController *)searchFetchedResultsController {
    
    if(_searchFetchedResultsController == nil) {
        
        NSManagedObjectContext *moc = [[BBStorageManager sharedManager] managedObjectContext];
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:BB_ENTITY_ITEM
                                                             inManagedObjectContext:moc];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@",
                                                                    self.searchDisplayController.searchBar.text];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
                                    nil];
        
        [fetchRequest setEntity:entityDescription];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        _searchFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:moc
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        
        [_searchFetchedResultsController performFetch:nil];
    }
    
    return _searchFetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate Methods

/*
 Assume self has a property 'tableView' -- as is the case for an instance of a UITableViewController
 subclass -- and a method configureCell:atIndexPath: which updates the contents of a given cell
 with information from a managed object at the given index path in the fetched results controller.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.shoppingTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller 
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.shoppingTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.shoppingTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.shoppingTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.shoppingTableView endUpdates];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSInteger sections = 0;
    
    if(tableView == self.shoppingTableView) {
        sections =  [[self.fetchedResultsController sections] count];
    }
    else {
        
        sections = [[self.searchFetchedResultsController sections] count];;
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    id <NSFetchedResultsSectionInfo> sectionInfo = nil;
    
    if(tableView == self.shoppingTableView) {
        
        sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    }
    else {

        sectionInfo = [[self.searchFetchedResultsController sections] objectAtIndex:section];
    }
    
    return [[sectionInfo objects] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    
    NSString *sectionTitle = nil;
    
    if(tableView == self.shoppingTableView) {
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        sectionTitle = [sectionInfo name];
    }

    return sectionTitle;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        BBShoppingItem *shoppingItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [[self.currentList currentShoppingCart] removeShoppingItem:shoppingItem];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, 
        //and add a new row to the table view
    }   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BBShoppingListCell";
    static NSString *SearchCellIdentifier = @"BBSearchCellIdentifier";
    
    UITableViewCell *cell = nil;
    
    if(tableView == self.shoppingTableView) {

        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [self configureCell:cell atIndexPath:indexPath];
    }
    else {
        
        BBItem *item = [self.searchFetchedResultsController objectAtIndexPath:indexPath];
        cell = [tableView dequeueReusableCellWithIdentifier:SearchCellIdentifier];
        
        if(cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:SearchCellIdentifier];
        }
        
        cell.textLabel.text = item.name;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.shoppingTableView) {
    
        BBShoppingListCell *cell = (BBShoppingListCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if(cell.selectionStyle == UITableViewCellSelectionStyleGray) {
         
            BBShoppingItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [self performSegueWithIdentifier:@"shoppingListItemDetailsSegue" sender:item];
        }
    }
    else {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Private Table View Methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    BBShoppingListCell *shoppingCell = (BBShoppingListCell *)cell;
    
    // Configure the cell...
    BBShoppingItem *shoppingItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //set item name
    shoppingCell.itemNameLabel.text = shoppingItem.item.name;
    
    //set item quantity
    if([shoppingItem.quantity length] > 0 && [shoppingItem.units length] > 0) {
        
        shoppingCell.itemQuantityUnitsLabel.text = [NSString stringWithFormat:@"x%@ %@", shoppingItem.quantity,
                                                shoppingItem.units];
    }
    else if([shoppingItem.quantity length] > 0) {
        
        shoppingCell.itemQuantityUnitsLabel.text = [NSString stringWithFormat:@"x%@", shoppingItem.quantity];
    }
    else {
        
        shoppingCell.itemQuantityUnitsLabel.text = @"";
    }
    
    if([shoppingItem.notes length] > 0 || shoppingItem.photo != nil) {
        
        shoppingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        shoppingCell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else {
        
        shoppingCell.accessoryType = UITableViewCellAccessoryNone;
        shoppingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //checked off?
    [shoppingCell itemCheckedOff:[shoppingItem.checkedOff boolValue]];
}

#pragma mark - UI Actions

- (IBAction)showMenuButtonPressed:(id)sender {

    [self.delegate showNavigationMenu];
}

- (void)editButtonPressed:(id)sender {
    
    if([self.shoppingTableView isEditing] == YES) {
        
        [self.shoppingTableView setEditing:NO animated:YES];
        [self setListsToolbarItemsAnimated:NO];
    }
    else {
        
        [self.shoppingTableView setEditing:YES animated:YES];
        [self setEditingListsToolbarItemsAnimated:YES];
    }
}

#pragma mark - UISearchDisplayDelegate Methods

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    self.fetchedResultsController.delegate = nil;
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    
    self.fetchedResultsController.delegate = self;
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
                                    shouldReloadTableForSearchString:(NSString *)searchString
{
    self.searchFetchedResultsController = nil;
    
    return YES;
}

#pragma Private Methods

- (void)shoppingCellSwipped:(id)sender {

    UISwipeGestureRecognizer *swipeGR = (UISwipeGestureRecognizer *)sender;
    
    CGPoint touch = [swipeGR locationOfTouch:0 inView:self.shoppingTableView];
    NSIndexPath *swipedIndexPath = [self.shoppingTableView indexPathForRowAtPoint:touch];
    
    //get the cell that was swipped
    BBShoppingListCell *cell = (BBShoppingListCell *)[self.shoppingTableView cellForRowAtIndexPath:swipedIndexPath];
    
    //check the managed object for the item's status
    BBShoppingItem *swippedItem = [self.fetchedResultsController objectAtIndexPath:swipedIndexPath];
    
    if([swippedItem.checkedOff boolValue] == YES) {
        
        swippedItem.checkedOff = [NSNumber numberWithBool:NO];
    }
    else {
        
        swippedItem.checkedOff = [NSNumber numberWithBool:YES];
    }
    
    [cell itemCheckedOff:[swippedItem.checkedOff boolValue]];
}

- (void)setListsToolbarItemsAnimated:(BOOL)animated {
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" 
                                                                   style:UIBarButtonItemStyleBordered 
                                                                  target:self 
                                                                  action:@selector(editButtonPressed:)];
    
    NSArray *items = [NSArray arrayWithObjects:editButton, nil];
    
    [self setToolbarItems:items animated:animated];
}

- (void)setEditingListsToolbarItemsAnimated:(BOOL)animated {
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
                                                                   style:UIBarButtonItemStyleBordered 
                                                                  target:self 
                                                                  action:@selector(editButtonPressed:)];
    
    NSArray *items = [NSArray arrayWithObject:doneButton];
    
    [self setToolbarItems:items animated:animated];
}

@end
