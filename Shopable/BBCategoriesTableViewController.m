//
//  BBCategoriesTableViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 6/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBCategoriesTableViewController.h"

//DB
#import "BBStorageManager.h"

//Controllers
#import "BBItemsListTableViewController.h"

@interface BBCategoriesTableViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation BBCategoriesTableViewController

@synthesize currentList;

@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:nil 
                                                                            action:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"categoryItemsSegue"]) {
        
        BBItemsListTableViewController *itemsList = (BBItemsListTableViewController *)segue.destinationViewController;
        
        itemsList.currentItemCategory = (BBItemCategory *)sender;
        itemsList.currentList = self.currentList;
    }
}

#pragma mark - Overrides

- (NSFetchedResultsController *)fetchedResultsController {
    
    if(_fetchedResultsController == nil) {
        
        NSManagedObjectContext *moc = [[BBStorageManager sharedManager] managedObjectContext];
        
        NSFetchRequest *categoriesFR = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_ITEM_CATEGORY];
        
        [categoriesFR setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:categoriesFR 
                                                                        managedObjectContext:moc 
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:nil];
        
        [_fetchedResultsController performFetch:nil];
    }
    
    return _fetchedResultsController;
}

#pragma mark - UI Actions

- (IBAction)doneButtonPressed:(id)sender {
    
    [[BBStorageManager sharedManager] saveContext];
    
    [self dismissModalViewControllerAnimated:YES];
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
    return [[sectionInfo objects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShoppingCategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    BBItemCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = category.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBItemCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"categoryItemsSegue" sender:category];
}

@end
