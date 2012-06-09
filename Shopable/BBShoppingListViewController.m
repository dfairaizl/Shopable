//
//  BBShoppingListViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 5/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

//View Controllers
#import "BBShoppingListViewController.h"
#import "BBItemCategoryViewController.h"

//DB
#import "BBStorageManager.h"

//Cells
#import "BBShoppingListCell.h"

@interface BBShoppingListViewController (TableView)

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@interface BBShoppingListViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation BBShoppingListViewController

@synthesize delegate;
@synthesize shoppingTableView = _shoppingTableView;
@synthesize currentList = _currentList;

@synthesize fetchedResultsController = _fetchedResultsController;

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
    
    //setup the swipe gesture recognizer for the shopping table view to support crossing off items in list
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self 
                                                                                  action:@selector(shoppingCellSwipped:)];
    [self.shoppingTableView addGestureRecognizer:swipeGR];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSError *error = nil;
    
    [self.fetchedResultsController performFetch:&error];
    
    if(error != nil) {
        
        NSLog(@"Error fetching shopping items");
    }
    
    [self.shoppingTableView reloadData];
}

- (void)viewDidUnload
{
    [self setShoppingTableView:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"addItemsSegue"]) {
        
        BBItemCategoryViewController *itemCategoryVC = (BBItemCategoryViewController *)
                                                                [[segue destinationViewController] topViewController];
        
        itemCategoryVC.currentList = self.currentList;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [[sectionInfo objects] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BBShoppingListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - NSFetchedResultsControllerDelegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.shoppingTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
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
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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

#pragma mark - Private Table View Methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    BBShoppingListCell *shoppingCell = (BBShoppingListCell *)cell;
    
    // Configure the cell...
    BBShoppingItem *shoppingItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //set item name
    shoppingCell.itemNameLabel.text = shoppingItem.item.name;
    
    //set item quantity
    if([shoppingItem.quantity length] > 0) {
        
        shoppingCell.itemQuantityUnitsLabel.text = [NSString stringWithFormat:@"x%@", shoppingItem.quantity];
    }
    else {
        
        shoppingCell.itemQuantityUnitsLabel.text = @"";
    }
    
    //checked off?
    [shoppingCell itemCheckedOff:[shoppingItem.checkedOff boolValue]];
}

#pragma mark - UI Actions

- (IBAction)showMenuButtonPressed:(id)sender {

    [self.delegate showNavigationMenu];
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

@end
