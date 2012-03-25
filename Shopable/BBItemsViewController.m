//
//  BBItemsViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/7/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItemsViewController.h"

#import "BBStorageManager.h"

#import "BBItemTableViewCell.h"

#import "BBEditItemTableViewController.h"
#import "BBAddItemTableViewController.h"

@implementation BBItemsViewController

@synthesize fetchedResultsController = _fetchedResultsController;

@synthesize currentStore;
@synthesize currentShoppingCart;
@synthesize currentItemCategory;

@synthesize itemsTableView;

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
    
    [[self.itemsTableView layer] setCornerRadius:10.0f];
    
    self.title = self.currentItemCategory.name;
    
    NSFetchRequest *categoriesFR = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_ITEM];
    
    [categoriesFR setPredicate:[NSPredicate predicateWithFormat:@"parentItemCategory == %@", self.currentItemCategory]];
    
    [categoriesFR setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:categoriesFR 
                                                                    managedObjectContext:[[BBStorageManager sharedManager] managedObjectContext] 
                                                                      sectionNameKeyPath:nil 
                                                                               cacheName:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSError *error = nil;
    
    [self.fetchedResultsController performFetch:&error];
    
    if(error != nil) {
        
        NSLog(@"Error fetching item categories");
    }
    
    [self.itemsTableView reloadData];
}

- (void)viewDidUnload
{
    [self setItemsTableView:nil];
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
    
    if([segue.identifier isEqualToString:@"addItemSegue"]) {
        
        BBAddItemTableViewController *addVC = (BBAddItemTableViewController *)[segue.destinationViewController topViewController];
        
        addVC.currentStore = self.currentStore;
        addVC.currentItemCategory = self.currentItemCategory;
    }
    else if([segue.identifier isEqualToString:@"editItemDetailsSegue"]) {
        
        BBShoppingItem *selectedItem = (BBShoppingItem *)sender;
        BBEditItemTableViewController *editVC = (BBEditItemTableViewController *)segue.destinationViewController;
        
        editVC.currentStore = self.currentStore;
        editVC.shoppingItem = selectedItem;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    
    BBItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BBItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.currentShoppingCart = self.currentShoppingCart;
    cell.currentItem = item;
    
    // Configure the cell...
    
    if([self.currentShoppingCart containsShoppingItemForItem:item] == YES) {
        
        [cell setItemSelected:YES];
    }
    else {
        
        [cell setItemSelected:NO];
    }
    
    cell.itemName.text = item.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    BBItem *selectedItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    BBShoppingItem *shoppingItem = [self.currentShoppingCart shoppingItemForItem:selectedItem createIfNotPresent:YES];
    
    [self performSegueWithIdentifier:@"editItemDetailsSegue" sender:shoppingItem];
}

#pragma mark - UIBarButtinItem Selector Methods

- (IBAction)addItem:(id)sender {
    
    [self performSegueWithIdentifier:@"addItemSegue" sender:nil];
}

@end
