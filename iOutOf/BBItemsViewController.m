//
//  BBItemsViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 2/7/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BBItemsViewController.h"

#import "BBStorageManager.h"

@implementation BBItemsViewController

@synthesize fetchedResultsController = _fetchedResultsController;

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
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbar-button-background"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    NSError *error = nil;
    NSFetchRequest *categoriesFR = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_ITEM];
    
    [categoriesFR setPredicate:[NSPredicate predicateWithFormat:@"parentItemCategory == %@", self.currentItemCategory]];
    
    [categoriesFR setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:categoriesFR 
                                                                    managedObjectContext:[[BBStorageManager sharedManager] managedObjectContext] 
                                                                      sectionNameKeyPath:nil 
                                                                               cacheName:nil];
    
    
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BBItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Configure the cell...
    
    if([self.currentShoppingCart containsItem:item] == YES) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = item.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BBItem *selectedItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        [self.currentShoppingCart removeItemFromCart:selectedItem];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        
        [self.currentShoppingCart addItemToCart:selectedItem];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIBarButtinItem Selector Methods

- (void)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
