//
//  BBItemsListTableViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 5/14/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItemsListTableViewController.h"

//DB
#import "BBStorageManager.h"

//Cells
#import "BBItemTableViewCell.h"

@interface BBItemsListTableViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSMutableIndexSet *accordionIndexSet;

@end

@implementation BBItemsListTableViewController

@synthesize currentItemCategory;
@synthesize currentList;

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize accordionIndexSet = _accordionIndexSet;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] 
                                                 initWithTarget:self 
                                                         action:@selector(toggleAccordion:)];
    
    [self.view addGestureRecognizer:longPressGR];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = self.currentItemCategory.name;
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

#pragma mark - Overrides

- (NSFetchedResultsController *)fetchedResultsController {
    
    if(_fetchedResultsController == nil) {
    
        NSManagedObjectContext *moc = [[BBStorageManager sharedManager] managedObjectContext];
        
        NSFetchRequest *categoriesFR = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_ITEM];
        
        [categoriesFR setPredicate:[NSPredicate predicateWithFormat:@"parentItemCategory == %@", 
                                    self.currentItemCategory]];
        
        [categoriesFR setSortDescriptors:[NSArray arrayWithObject:
                                          [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:categoriesFR 
                                                                        managedObjectContext:moc 
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:nil];
        
        [_fetchedResultsController performFetch:nil];
    }
    
    return _fetchedResultsController;
}

- (NSMutableIndexSet *)accordionIndexSet {
    
    if(_accordionIndexSet == nil) {
        
        _accordionIndexSet = [[NSMutableIndexSet alloc] init];
    }
    
    return _accordionIndexSet;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 44;
    
    if([self.accordionIndexSet containsIndex:indexPath.row]) {
        
        height = 88;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BBItemCell";
    static NSString *AccordionCellIdentifier = @"BBAccordionItemCell";
    
    BBItemTableViewCell *cell = nil;
    
    if([self.accordionIndexSet containsIndex:indexPath.row] == NO) {
        
        cell = (BBItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    else {
        
        cell = (BBItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AccordionCellIdentifier];
    }

    // Configure the cell...
    BBItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if([[self.currentList currentShoppingCart] containsShoppingItemForItem:item] == YES) {
        
        [cell checkItem:YES];
    }
    else {
        
        [cell checkItem:NO];
    }

    cell.itemNameLabel.text = item.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    BBShoppingItem *shoppingItem = [[self.currentList currentShoppingCart] shoppingItemForItem:item 
                                                                            createIfNotPresent:NO];
    
    if([[self.currentList currentShoppingCart] containsShoppingItemForItem:item] == YES) {
        
        [[self.currentList currentShoppingCart] removeItemFromCart:shoppingItem];
    }
    else {
    
        [[self.currentList currentShoppingCart] addCartItemsObject:[[self.currentList currentShoppingCart] shoppingItemForItem:item 
                                                                                                           createIfNotPresent:YES]];
    }
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                          withRowAnimation:UITableViewRowAnimationFade];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

- (void)toggleAccordion:(UILongPressGestureRecognizer *)longPressGR {
    
    if (longPressGR.state == UIGestureRecognizerStateBegan) {
    
        CGPoint point = [longPressGR locationInView:self.tableView];
        
        NSIndexPath *pressIndexPath = [self.tableView indexPathForRowAtPoint:point];
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:2];
        
        //check if selected row is already open
        if(pressIndexPath.row == [self.accordionIndexSet lastIndex]) {
            
            [indexPaths addObject:pressIndexPath];
            [self.accordionIndexSet removeAllIndexes];
        }
        else if([self.accordionIndexSet count] > 0) {
            
            //set the current accordion to close
            NSIndexPath *currentAccordionIndexPath = [NSIndexPath indexPathForRow:[self.accordionIndexSet lastIndex] 
                                                                        inSection:0];
            
            [indexPaths addObject:currentAccordionIndexPath];
            [self.accordionIndexSet removeAllIndexes];
            
            //open the new one
            [indexPaths addObject:pressIndexPath];
            [self.accordionIndexSet addIndex:pressIndexPath.row];
        }
        else {
            
            [indexPaths addObject:pressIndexPath];
            [self.accordionIndexSet addIndex:pressIndexPath.row];
        }
        
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end