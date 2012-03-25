//
//  BBItemsTableViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItemCategoryViewController.h"
#import "BBAddItemTableViewController.h"
#import "BBItemsViewController.h"

#import "BBStorageManager.h"
#import "BBStorageManager+Initialize.h"

@implementation BBItemCategoryViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize currentStore;
@synthesize categoriesTableView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.categoriesTableView layer] setCornerRadius:10.0f];
    
    self.title = self.currentStore.name;
    
    NSError *error = nil;
    NSFetchRequest *categoriesFR = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_ITEM_CATEGORY];
    
    [categoriesFR setPredicate:[NSPredicate predicateWithFormat:@"type == %d", [self.currentStore.type intValue]]];
    
    [categoriesFR setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:categoriesFR 
                                                                    managedObjectContext:[[BBStorageManager sharedManager] managedObjectContext] 
                                                                      sectionNameKeyPath:nil 
                                                                               cacheName:nil];
    
    
    [self.fetchedResultsController performFetch:&error];
    
    if([[self.fetchedResultsController fetchedObjects] count] <= 0) {
        
        [[BBStorageManager sharedManager] setupDatabase];
        
        [self.fetchedResultsController performFetch:&error];
    }
    
    if(error != nil) {
     
        NSLog(@"Error fetching item categories");
    }
    
    [self.categoriesTableView reloadData];
}

- (void)viewDidUnload
{
    [self setCategoriesTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    NSLog(@"Fetched objects %d", [[self.fetchedResultsController fetchedObjects] count]);
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"itemsForCategorySegue"]) {
            
        BBItemsViewController *itemsVC = (BBItemsViewController *)segue.destinationViewController;
        
        itemsVC.currentStore = self.currentStore;
        itemsVC.currentShoppingCart = [self.currentStore currentShoppingCart];
        itemsVC.currentItemCategory = (BBItemCategory *)sender;
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
    static NSString *CellIdentifier = @"ItemCategoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    BBItemCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];

    // Configure the cell...
    cell.textLabel.text = category.name;
    
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
    
    [[BBStorageManager sharedManager] saveContext];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
