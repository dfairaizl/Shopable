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
#import "BBShoppingListAddViewController.h"

//DB
#import "BBStorageManager.h"

//Cells
#import "BBShoppingListCell.h"

@interface BBShoppingListViewController (TableView)

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@interface BBShoppingListViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) BBShoppingListAddViewController *addViewController;

@end

@implementation BBShoppingListViewController

@synthesize delegate;
@synthesize shoppingTableView = _shoppingTableView;
@synthesize addItemTableHeader;
@synthesize currentList = _currentList;
@synthesize addViewController;

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
    
    //shopping list add item child view controller
    self.addViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil]
                                        instantiateViewControllerWithIdentifier:@"BBShoppingListAddViewController"];
    
    self.addViewController.delegate = self;
    
    CGRect frame = self.addViewController.view.frame;
    frame.origin.y = 0;
    self.addViewController.view.frame = frame;
    
    [self addChildViewController:self.addViewController];
    [self.view addSubview:self.addViewController.view];
    [self didMoveToParentViewController:self.addViewController];
    
    [self.view bringSubviewToFront:self.shoppingTableView];
    
    self.addViewController.view.hidden = YES;
    
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
    
    [self setAddItemTableHeader:nil];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBShoppingListCell *cell = (BBShoppingListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.selectionStyle == UITableViewCellSelectionStyleGray) {
     
        BBShoppingItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"shoppingListItemDetailsSegue" sender:item];
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

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.addViewController.view.hidden = NO;
    self.shoppingTableView.backgroundColor = [UIColor clearColor];
    
    //[self.addViewController scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.addViewController shoppingListScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self.addViewController shoppingListScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //y = 0;

    //reset scroll view
    
    
//    self.addViewController.view.hidden = YES;
//    self.shoppingTableView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - BBShoppingAddItemDelegate

- (void)shoppingListWillAddItem {
    
    [UIView animateWithDuration:0.4
                     animations:^ {
                     
                         self.shoppingTableView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
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
