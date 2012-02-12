//
//  BBStoreShoppingViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/5/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStoreShoppingViewController.h"
#import "BBItemCategoryViewController.h"

//Support
#import "BBStorageManager.h"
#import "BBShoppingTableViewCell.h"
#import "BBDecoratorLabel.h"

@interface BBStoreShoppingViewController ()

- (void)shoppingCellSwipped:(id)sender;
- (void)update;

@end

@interface BBStoreShoppingViewController (TableCustomization)

- (UITableViewCell *)configureShoppingCell:(BBShoppingTableViewCell *)cell withItem:(BBShoppingItem *)item;

@end

@implementation BBStoreShoppingViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize currentStore;
@synthesize contentView;
@synthesize storeTableView;
@synthesize storeNameLabel;

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
    
    self.storeNameLabel.text = self.currentStore.name;
    
    //setup the swipe gesture recognizer for the shopping table view to support crossing off items in list
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shoppingCellSwipped:)];
    [self.storeTableView addGestureRecognizer:swipeGR];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSError *error = nil;
    NSFetchRequest *cartCategoryFR = [[NSFetchRequest alloc] init];
    
    cartCategoryFR.entity = [NSEntityDescription entityForName:BB_ENTITY_SHOPPING_ITEM inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
    cartCategoryFR.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"itemCategoryName" ascending:YES], //NOTE sort descriptor keyname MUST match the section name in the FRC!
                                      [NSSortDescriptor sortDescriptorWithKey:@"item.name" ascending:YES], nil];
    cartCategoryFR.predicate = [NSPredicate predicateWithFormat:@"parentShoppingCart == %@", [self.currentStore currentShoppingCart]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:cartCategoryFR 
                                                                    managedObjectContext:[[BBStorageManager sharedManager] managedObjectContext] 
                                                                      sectionNameKeyPath:@"itemCategoryName" 
                                                                               cacheName:nil];
    
    [self.fetchedResultsController performFetch:&error];
    
    if(error != nil) {
        
        NSLog(@"Error fetching!");
    }
    
    [self.storeTableView reloadData];
}

- (void)viewDidUnload
{
    [self setContentView:nil];
    [self setStoreNameLabel:nil];
    [self setStoreTableView:nil];
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
            
            [self update];
            
            if([tableView numberOfRowsInSection:indexPath.section] <= 1) {
             
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
            else {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"shoppingItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BBShoppingItem *item = (BBShoppingItem *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Configure the cell...
    
    cell = [self configureShoppingCell:(BBShoppingTableViewCell *)cell withItem:item];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Table Customization Methods

- (UITableViewCell *)configureShoppingCell:(BBShoppingTableViewCell *)cell withItem:(BBShoppingItem *)item {
    
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

@end
