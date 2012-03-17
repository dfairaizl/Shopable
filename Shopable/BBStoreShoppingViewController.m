//
//  BBStoreShoppingViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/5/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStoreShoppingViewController.h"
#import "BBItemCategoryViewController.h"
#import "BBItemQuickAddViewController.h"

//Support
#import "BBStorageManager.h"
#import "BBShoppingTableViewCell.h"
#import "BBDecoratorLabel.h"

@interface BBStoreShoppingViewController ()

@property (strong, nonatomic) BBItemQuickAddViewController *quickAddVC;

- (void)refreshStores;
- (void)shoppingCellSwipped:(id)sender;
- (void)update;

@end

@interface BBStoreShoppingViewController (TableCustomization)

- (UITableViewCell *)configureCell:(BBShoppingTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation BBStoreShoppingViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize currentStore;
@synthesize addItemsButton;
@synthesize contentView;
@synthesize storeTableView;
@synthesize storeNameLabel;
@synthesize parentStoresViewController;
@synthesize quickAddVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //reassign the view to the content view becasue thats all we care about.
    //self.view right now is just because storyboard does not all views outside a view controller - df
    self.view = self.contentView;
    
    [[self.contentView layer] setCornerRadius:10.0f];
    
    //setup the swipe gesture recognizer for the shopping table view to support crossing off items in list
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shoppingCellSwipped:)];
    [self.storeTableView addGestureRecognizer:swipeGR];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.storeNameLabel.text = self.currentStore.name;
    
    [self refreshStores];
}

- (void)viewDidUnload
{
    [self setContentView:nil];
    [self setStoreNameLabel:nil];
    [self setStoreTableView:nil];
    [self setAddItemsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showItemCategoriesSegue"]) {
        
        BBItemCategoryViewController *itemsVC = (BBItemCategoryViewController *)[segue.destinationViewController topViewController];
        
        itemsVC.currentStore = self.currentStore;
    }
    else if([segue.identifier isEqualToString:@"itemQuickAddSegue"]) {
     
        self.quickAddVC = (BBItemQuickAddViewController *)segue.destinationViewController;
        
        self.quickAddVC.currentShoppingCart = [self.currentStore currentShoppingCart];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects]; 
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo name];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([tableView isEditing] == YES) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([tableView isEditing] == YES) {
        
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            BBShoppingItem *deleteItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [[self.currentStore currentShoppingCart] removeItemFromCart:deleteItem];
            
            NSMutableArray *rows = [[self.fetchedResultsController fetchedObjects] mutableCopy];
            [rows removeObjectAtIndex:indexPath.row];
            
            /*[self update];
            
            if([tableView numberOfRowsInSection:indexPath.section] <= 1) {
             
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
            else {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }*/
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"shoppingItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    cell = [self configureCell:(BBShoppingTableViewCell *)cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - NSFetchedResultsControllerDelegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.storeTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.storeTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.storeTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.storeTableView;
    
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
            [self configureCell:(BBShoppingTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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
    [self.storeTableView endUpdates];
}

#pragma mark - Public Methods

- (void)refresh {
    
    //[self update];
    
    //[self.storeTableView reloadData];
}

#pragma mark - Table Customization Methods

- (UITableViewCell *)configureCell:(BBShoppingTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    BBShoppingItem *item = (BBShoppingItem *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.itemLabel.text = item.item.name;

    if([item.quantity length]) {
        
        cell.itemQuantityLabel.text = [NSString stringWithFormat:@"x%@ %@", item.quantity, item.units];
    }
    else {
        
        cell.itemQuantityLabel.text = @"";
    }

    if([item.notes length]) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    [cell cellCheckedOff:[item.checkedOff boolValue]];

    return cell;
}

#pragma mark - Private Methods

- (void)refreshStores {

    NSError *error = nil;
    NSFetchRequest *cartCategoryFR = [[NSFetchRequest alloc] init];

    if(self.fetchedResultsController == nil) {

        cartCategoryFR.entity = [NSEntityDescription entityForName:BB_ENTITY_SHOPPING_ITEM inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
        cartCategoryFR.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"itemCategoryName" ascending:YES], //NOTE sort descriptor keyname MUST match the section name in the FRC!
                                          [NSSortDescriptor sortDescriptorWithKey:@"item.name" ascending:YES], nil];
        cartCategoryFR.predicate = [NSPredicate predicateWithFormat:@"parentShoppingCart == %@", [self.currentStore currentShoppingCart]];

        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:cartCategoryFR 
                                                                        managedObjectContext:[[BBStorageManager sharedManager] managedObjectContext] 
                                                                          sectionNameKeyPath:@"itemCategoryName" 
                                                                                   cacheName:nil];

        self.fetchedResultsController.delegate = self;
    }

    [self.fetchedResultsController performFetch:&error];

    if(error != nil) {
        
        NSLog(@"Error fetching!");
    }

    [self.storeTableView reloadData];
}

- (void)shoppingCellSwipped:(id)sender {
    
    if([self.currentStore.currentlyShopping boolValue] == YES) {
        UISwipeGestureRecognizer *swipeGR = (UISwipeGestureRecognizer *)sender;
        
        CGPoint touch = [swipeGR locationOfTouch:0 inView:self.storeTableView];
        NSIndexPath *swipedIndexPath = [self.storeTableView indexPathForRowAtPoint:touch];
        
        //get the cell that was swipped
        BBShoppingTableViewCell *cell = (BBShoppingTableViewCell *)[self.storeTableView cellForRowAtIndexPath:swipedIndexPath];
        
        //check the managed object for the item's status
        BBShoppingItem *swippedItem = [self.fetchedResultsController objectAtIndexPath:swipedIndexPath];
        
        if([swippedItem.checkedOff boolValue] == YES) {
            
            swippedItem.checkedOff = [NSNumber numberWithBool:NO];
        }
        else {
            
            swippedItem.checkedOff = [NSNumber numberWithBool:YES];
        }
        
        [cell cellCheckedOff:[swippedItem.checkedOff boolValue]];
    }
}

- (void)update {
    
    NSError *error = nil;
    
    [self.fetchedResultsController performFetch:&error];
    
    if(error != nil) {
        
        NSLog(@"Error fetching!");
    }
}

#pragma mark - UI Action Methods

- (IBAction)addItemsButtonPressed:(id)sender {

    if([[self.currentStore currentlyShopping] boolValue] == YES) {
        
        [self performSegueWithIdentifier:@"itemQuickAddSegue" sender:nil];
    }
    else {
        
        [self performSegueWithIdentifier:@"showItemCategoriesSegue" sender:nil];
    }
}

@end
