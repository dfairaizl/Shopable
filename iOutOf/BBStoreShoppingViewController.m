//
//  BBStoreShoppingViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 2/5/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BBStoreShoppingViewController.h"

#import "BBItemCategoryViewController.h"

#import "BBStorageManager.h"

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //reassign the view to the content view becasue thats all we care about.
    //self.view right now is just because storyboard does not all views outside a view controller - df
    self.view = self.contentView;
    
    [[self.contentView layer] setCornerRadius:10.0f];
    
    self.storeNameLabel.text = self.currentStore.name;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSError *error = nil;
    NSFetchRequest *cartCategoryFR = [[NSFetchRequest alloc] init];
    
    cartCategoryFR.entity = [NSEntityDescription entityForName:BB_ENTITY_ITEM inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
    cartCategoryFR.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"itemCategoryName" ascending:YES], //NOTE sort descriptor keyname MUST match the section name in the FRC!
                                      [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"shoppingItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BBItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = item.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
