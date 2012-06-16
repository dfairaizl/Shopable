//
//  BBShoppingListsViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 5/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBListsViewController.h"

//DB
#import "BBStorageManager.h"

//Views
#import "BBListTableViewCell.h"

@interface BBListsViewController (Data)

- (void)listInsertedAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BBListsViewController (TableView)

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@interface BBListsViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSIndexPath *insertIndexPath;
@property (weak, nonatomic) BBListTableViewCell *currentEditingCell;

- (void)setListsToolbarItemsAnimated:(BOOL)animated;
- (void)setEditingListsToolbarItemsAnimated:(BOOL)animated;

- (void)refreshUI:(NSNotification *)note;

@end

@implementation BBListsViewController

@synthesize delegate;
@synthesize tableView = _tableView;
@synthesize addNewListButton = _addNewListButton;
@synthesize editListsButton = _editListsButton;
@synthesize emailListsButton = _emailListsButton;

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize insertIndexPath;
@synthesize currentEditingCell;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setListsToolbarItemsAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUI:)
                                                 name:@"RefreshUI" object:nil];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setAddNewListButton:nil];
    
    [self setEditListsButton:nil];
    [self setEmailListsButton:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Actions

- (IBAction)editButtonPressed:(id)sender {

    if([self.tableView isEditing] == YES) {
        
        [self.tableView setEditing:NO animated:YES];
        
        [self setListsToolbarItemsAnimated:YES];
    }
    else {
        
        [self.tableView setEditing:YES animated:YES];
        
        [self setEditingListsToolbarItemsAnimated:YES];
    }
}

- (IBAction)addNewListButtonPressed:(id)sender {
    
    [self.tableView setEditing:YES animated:YES];
    
    [self.tableView.tableFooterView setHidden:YES];
    
    [BBList addList];
}

#pragma mark - Overrides

- (NSFetchedResultsController *)fetchedResultsController {
    
    if(_fetchedResultsController == nil) {
        
        NSManagedObjectContext *moc = [[BBStorageManager sharedManager] managedObjectContext];
        
        NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_LIST];
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor 
                                                             sortDescriptorWithKey:@"order" ascending:YES]];
        
        [fr setSortDescriptors:sortDescriptors];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fr 
                                     managedObjectContext:moc 
                                     sectionNameKeyPath:nil 
                                     cacheName:nil];
        
        _fetchedResultsController.delegate = self;
        
        [_fetchedResultsController performFetch:nil];
        
    }
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate Methods

/*
 Assume self has a property 'tableView' -- as is the case for an instance of a UITableViewController
 subclass -- and a method configureCell:atIndexPath: which updates the contents of a given cell
 with information from a managed object at the given index path in the fetched results controller.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller 
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            
            self.insertIndexPath = newIndexPath;
            
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
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
    
    [self.tableView endUpdates];
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
    static NSString *CellIdentifier = @"BBListCell";
    BBListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        BBList *list = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [list deleteList];
        
        [self.currentEditingCell.listTitleTextField resignFirstResponder];
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
      toIndexPath:(NSIndexPath *)toIndexPath
{

}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBList *selectedList = (BBList *)[self.fetchedResultsController objectAtIndexPath:indexPath];

    [self.delegate didSelectNavigationOptionWithObject:selectedList];
}

#pragma mark - Private Table View Methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    BBListTableViewCell *listCell = (BBListTableViewCell *)cell;
    
    BBList *store = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    listCell.listTitle.text = store.name;
    listCell.listTitleTextField.text = store.name;
    
    listCell.delegate = self;
    
    if(self.insertIndexPath != nil && indexPath.row == self.insertIndexPath.row) {
        
        [listCell.listTitleTextField becomeFirstResponder];
    }
}

#pragma mark - BBListTableViewCellDelegate Methods

- (void)cellWillBeginEditing:(UITableViewCell *)cell {
    
    [self.currentEditingCell.listTitleTextField resignFirstResponder];
    
    self.currentEditingCell = (BBListTableViewCell *)cell;
}

- (void)cellDidFinishEditing:(UITableViewCell *)cell {
    
    BBListTableViewCell *editingCell = (BBListTableViewCell *)cell;
    
    NSIndexPath *editingIndexPath = [self.tableView indexPathForCell:cell];
    
    BBList *editingStore = [self.fetchedResultsController objectAtIndexPath:editingIndexPath];
    
    if([editingCell.listTitleTextField.text length]) {
     
        [editingStore setName:editingCell.listTitleTextField.text];
        
        if(self.insertIndexPath != nil) {
            
            self.insertIndexPath = nil;
            [self.tableView setEditing:NO animated:YES];
        }
    }
    else {
        
        [editingStore deleteList];
        
        self.insertIndexPath = nil;
        [self.tableView setEditing:NO animated:YES];
    }
    
    [self setListsToolbarItemsAnimated:YES];
}

#pragma mark - Private Data Methods

- (void)listInsertedAtIndexPath:(NSIndexPath *)indexPath {

    BBListTableViewCell *cell = (BBListTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [cell.listTitleTextField becomeFirstResponder];
}

#pragma mark - Private Methods

- (void)setListsToolbarItemsAnimated:(BOOL)animated {

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" 
                                                                   style:UIBarButtonItemStyleBordered 
                                                                  target:self 
                                                                  action:@selector(editButtonPressed:)];
    
    NSArray *items = [NSArray arrayWithObjects:editButton, nil];

    //reset to defaults
    [self.tableView.tableFooterView setHidden:NO];
    
    [self setToolbarItems:items animated:animated];
}

- (void)setEditingListsToolbarItemsAnimated:(BOOL)animated {
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
                                                                   style:UIBarButtonItemStyleBordered 
                                                                  target:self 
                                                                  action:@selector(editButtonPressed:)];
    
    NSArray *items = [NSArray arrayWithObject:doneButton];
    
    [self setToolbarItems:items animated:animated];
}

- (void)refreshUI:(NSNotification *)note {
    
    [self.fetchedResultsController performFetch:nil];
    
    [self.tableView reloadData];
}

@end
