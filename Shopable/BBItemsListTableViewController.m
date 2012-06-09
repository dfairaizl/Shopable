//
//  BBItemsListTableViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 5/14/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItemsListTableViewController.h"

//Controllers
#import "BBItemDetailsTableViewController.h"

//DB
#import "BBStorageManager.h"

//Cells
#import "BBItemTableViewCell.h"

@interface BBItemsListTableViewController (TableView)

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

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

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:nil 
                                                                            action:nil];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"itemDetailsSegue"]) {
        
        BBShoppingItem *item = (BBShoppingItem *)sender;
        BBItemDetailsTableViewController *detailsVC = (BBItemDetailsTableViewController *)[segue 
                                                                                           destinationViewController];
        
        detailsVC.currentItem = item;
    }
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

#pragma mark - IB Actions

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
        
        cell.delegate = self;
    }

    // Configure the cell...
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if([[self.currentList currentShoppingCart] containsItem:item] == YES) {
        
        [[self.currentList currentShoppingCart] removeItem:item];
    }
    else {
    
        [[self.currentList currentShoppingCart] addItem:item];
    }
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                          withRowAnimation:UITableViewRowAnimationFade];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Table View Methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    BBItemTableViewCell *itemCell = (BBItemTableViewCell *)cell;
    BBItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    BBShoppingItem *shoppingItem = nil;
    
    if([[self.currentList currentShoppingCart] containsItem:item] == YES) {
    
        [itemCell checkItem:YES];
        shoppingItem = [[self.currentList currentShoppingCart] shoppingItemForItem:item];
    }
    else {
        
        [itemCell checkItem:NO];
    }
    
    //Set cell name
    itemCell.itemNameLabel.text = item.name;
    
    //show quantity if accordion is NOT open
    if([self.accordionIndexSet containsIndex:indexPath.row] == NO) {
    
        if([shoppingItem.quantity length] > 0) {
         
            itemCell.itemQuantityUnitsLabel.text = [NSString stringWithFormat:@"x%@", shoppingItem.quantity];
        }
        else {
            
            itemCell.itemQuantityUnitsLabel.text = @"";
        }
    }
}

#pragma mark - Private Methods

- (void)toggleAccordion:(UILongPressGestureRecognizer *)longPressGR {
    
    if (longPressGR.state == UIGestureRecognizerStateBegan) {
    
        CGPoint point = [longPressGR locationInView:self.tableView];
        
        NSIndexPath *pressIndexPath = [self.tableView indexPathForRowAtPoint:point];
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:1];
        
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

#pragma mark - BBItemsListTableViewCellDelegate Methods

- (void)showItemDetailsForCell:(UITableViewCell *)cell {
    
    NSIndexPath *detailsIndexPath = [self.tableView indexPathForCell:cell];
    BBItem *item = [self.fetchedResultsController objectAtIndexPath:detailsIndexPath];
    BBShoppingItem *detailsItem = nil;
    
    if([[self.currentList currentShoppingCart] containsItem:item] == NO) {
        
        detailsItem = [[self.currentList currentShoppingCart] addItem:item];
    }
    else {
     
        detailsItem = [[self.currentList currentShoppingCart] shoppingItemForItem:item];
    }
    
    [self performSegueWithIdentifier:@"itemDetailsSegue" sender:detailsItem];
}

- (void)itemQuantityDidChange:(NSInteger)quantity {    
    
    NSIndexPath *currentAccordionIndexPath = [NSIndexPath indexPathForRow:[self.accordionIndexSet lastIndex] 
                                                                inSection:0];
    BBItem *item = [self.fetchedResultsController objectAtIndexPath:currentAccordionIndexPath];
    BBShoppingItem *detailsItem = nil;
    
    if([[self.currentList currentShoppingCart] containsItem:item] == NO) {
        
        detailsItem = [[self.currentList currentShoppingCart] addItem:item];
    }
    else {
        
        detailsItem = [[self.currentList currentShoppingCart] shoppingItemForItem:item];
    }
    
    detailsItem.quantity = [NSString stringWithFormat:@"%d", quantity];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:currentAccordionIndexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}

@end
