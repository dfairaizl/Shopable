//
//  BBEditStoresViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/7/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBEditStoresViewController.h"

#import "BBStorageManager.h"

#import "BBEditStoreTableViewCell.h"

@interface BBEditStoresViewController ()

- (void)updateStoresFRC;
- (void)updateItemsFRC;
- (void)updateOrder;
- (void)update;

@end

@implementation BBEditStoresViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize storesTableView;

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
    
    [[self.storesTableView layer] setCornerRadius:10.0];
    
    [self updateStoresFRC];
    
    [self.storesTableView setEditing:YES];
    
    [self.storesTableView reloadData];
}

- (void)viewDidUnload
{
    [self setStoresTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if(displayMode == bbTableDisplayModeStores) {
         
            BBStore *deleteStore = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [[[BBStorageManager sharedManager] managedObjectContext] deleteObject:deleteStore];
        }
        else if(displayMode == bbTableDisplayModeItems) {

            BBItem *deleteItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [[[BBStorageManager sharedManager] managedObjectContext] deleteObject:deleteItem];
        }
        
        NSMutableArray *rows = [[self.fetchedResultsController fetchedObjects] mutableCopy];
        [rows removeObjectAtIndex:indexPath.row];
        
        [self update];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL move = NO;
    
    if(displayMode == bbTableDisplayModeStores) {

        move = YES;
    }
    
    return move;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSMutableArray *stores = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    BBStore *editingStore = [self.fetchedResultsController objectAtIndexPath:sourceIndexPath];
    
    [stores removeObjectAtIndex:sourceIndexPath.row];
    [stores insertObject:editingStore atIndex:destinationIndexPath.row];

    [self updateOrder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;
    
    if(displayMode == bbTableDisplayModeStores) {
        
        cellIdentifier = @"editStoreTableCell";
    }
    else if(displayMode == bbTableDisplayModeItems) {
        
        cellIdentifier = @"editItemsTableCell";
    }
    
    UITableViewCell *cell = nil;
    
    if(displayMode == bbTableDisplayModeStores) {
        
        BBEditStoreTableViewCell *storeCell = (BBEditStoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        BBStore *store = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        // Configure the cell...
        storeCell.storeNameTextField.text = store.name;
        storeCell.currentStore = store;
        
        cell = storeCell;
    }
    else if(displayMode == bbTableDisplayModeItems) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        BBItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        cell.textLabel.text = item.name;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"itemsForCategorySegue" sender:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

#pragma mark - UI Action Methods

- (IBAction)done:(id)sender {
    
    [self updateOrder];
    
    [[BBStorageManager sharedManager] saveContext];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)editingStateChanged:(id)sender {

    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if(control.selectedSegmentIndex == 0) {
        
        [self updateStoresFRC];
    }
    else if(control.selectedSegmentIndex == 1) {
        
        [self updateItemsFRC];
    }
    
    [self.storesTableView reloadData];
}

#pragma mark - Private Methods

- (void)updateStoresFRC {
    
    NSFetchRequest *categoriesFR = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_STORE];
    
    [categoriesFR setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:categoriesFR 
                                                                    managedObjectContext:[[BBStorageManager sharedManager] managedObjectContext] 
                                                                      sectionNameKeyPath:nil 
                                                                               cacheName:nil];
    
    displayMode = bbTableDisplayModeStores;
    
    [self update];
}

- (void)updateItemsFRC {

    NSFetchRequest *categoriesFR = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_ITEM];
    
    [categoriesFR setPredicate:[NSPredicate predicateWithFormat:@"isCustom == %d", YES]];
    
    [categoriesFR setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:categoriesFR 
                                                                    managedObjectContext:[[BBStorageManager sharedManager] managedObjectContext] 
                                                                      sectionNameKeyPath:nil 
                                                                               cacheName:nil];
    
    displayMode = bbTableDisplayModeItems;
    
    [self update];
}

- (void)updateOrder {

    if(displayMode == bbTableDisplayModeStores) {
        for(NSInteger index = 0; index < [self.storesTableView numberOfRowsInSection:0]; index++) {
            
            BBEditStoreTableViewCell *cell = (BBEditStoreTableViewCell *)[self.storesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            
            cell.currentStore.order = [NSNumber numberWithInt:index];
        }
    }
}

- (void)update {

    NSError *error = nil;
    
    [self.fetchedResultsController performFetch:&error];
    
    if(error != nil) {
        
        NSLog(@"Error fetching item categories");
    }
    
}

@end
