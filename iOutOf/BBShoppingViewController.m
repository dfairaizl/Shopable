//
//  BBItemCategoryTableViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBShoppingViewController.h"
#import "BBItemsTableViewController.h"

#import "BBShoppingTableViewCell.h"
#import "BBToolbarShoppingView.h"
#import "BBDecoratorLabel.h"

#import "BBStorageManager.h"

@interface BBShoppingViewController ()

@property BOOL shoppingMode;

- (void)createItemsFRCWithFetch:(BOOL)fetch;
- (void)createCartFRCWithFetch:(BOOL)fetch;
- (void)shoppingCellSwipped:(id)sender;
- (void)setupForShoppingMode;

@end

@interface BBShoppingViewController (TableCustomization)

- (UITableViewCell *)configureItemsCell:(UITableViewCell *)cell withCategory:(BBItemCategory *)category;
- (UITableViewCell *)configureShoppingCell:(BBShoppingTableViewCell *)cell withItem:(BBItem *)item;

@end

@implementation BBShoppingViewController

@synthesize currentStore;
@synthesize itemsFetchedResultsController = _itemsFetchedResultsController;
@synthesize cartFetchedResultsController = _cartFetchedResultsController;
@synthesize currentFetchedResultsController = _currentFetchedResultsController;
@synthesize itemsTableView = _itemsTableView;
@synthesize shoppingTableView = _shoppingTableView;
@synthesize toolbar = _toolbar;
@synthesize toolbarShoppingSlider = _toolbarShoppingSlider;
@synthesize shoppingMode;

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
    
    self.toolbarShoppingSlider.toolbar = self.toolbar;
    
    //setup the swipe gesture recognizer for the shopping table view to support crossing off items in list
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shoppingCellSwipped:)];
    [self.shoppingTableView addGestureRecognizer:swipeGR];
    
    [self createItemsFRCWithFetch:YES];
    
    [self.itemsTableView reloadData];
}

- (void)viewDidUnload
{
    [self setItemsTableView:nil];
    [self setShoppingTableView:nil];
    [self setToolbarShoppingSlider:nil];
    [self setToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = self.currentStore.name;
    
    shoppingMode = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
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
        
        BBItemsTableViewController *itemsVC = (BBItemsTableViewController *)segue.destinationViewController;

        itemsVC.currentStore = self.currentStore;
        itemsVC.currentItemCategory = (BBItemCategory *)sender;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.currentFetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.currentFetchedResultsController sections] objectAtIndex:section];

    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.currentFetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *itemCellIdentifier = @"ItemCategoryCell";
    static NSString *shoppingCellIdentifier = @"ShoppingCartItemCell";
    
    UITableViewCell *cell = nil;
    
    if(self.shoppingMode == NO) {
        cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
    }
    else {
        cell = (BBShoppingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:shoppingCellIdentifier];
    }
    
    // Configure the cell...
    if(self.shoppingMode == NO) {

        BBItemCategory *category = (BBItemCategory *)[self.currentFetchedResultsController objectAtIndexPath:indexPath];

        cell = [self configureItemsCell:cell withCategory:category];
    }
    else {
        
        BBItem *item = (BBItem *)[self.currentFetchedResultsController objectAtIndexPath:indexPath];
        cell = [self configureShoppingCell:(BBShoppingTableViewCell *)cell withItem:item];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.shoppingMode == NO) { 
        BBItemCategory *selectedCategory = [self.itemsFetchedResultsController objectAtIndexPath:indexPath];
     
        [self performSegueWithIdentifier:@"itemsForCategorySegue" sender:selectedCategory];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Table Customization Methods

- (UITableViewCell *)configureItemsCell:(UITableViewCell *)cell withCategory:(BBItemCategory *)category {
    
    cell.textLabel.text = category.name;
    
    return cell;
}

- (UITableViewCell *)configureShoppingCell:(BBShoppingTableViewCell *)cell withItem:(BBItem *)item {
    
    cell.itemLabel.text = item.name;
    
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

#pragma mark - BBToolbarSlider Delegate Methods

- (void)toolbarSliderDidCrossThreshold {
    
    self.shoppingTableView.alpha = 0.0;
    
    [UIView animateWithDuration:0.6 
                          delay:0.0 
                        options:UIViewAnimationOptionCurveEaseIn 
                     animations:^() {
                         
                         self.shoppingTableView.alpha = 1.0;
                         self.itemsTableView.alpha = 0.0;
                         
                         self.shoppingTableView.frame = self.itemsTableView.frame;
                     } 
                     completion:^(BOOL finished) {
                         
                         [self setupForShoppingMode];
                     }
     ];
}

- (void)toolbarSliderDidReturn {
    
    if(self.shoppingMode == YES) {
            
        self.itemsTableView.alpha = 0.0;
        
        [UIView animateWithDuration:0.6 
                              delay:0.0 
                            options:UIViewAnimationOptionCurveEaseIn 
                         animations:^() {
                             
                             self.itemsTableView.alpha = 1.0;
                             self.shoppingTableView.alpha = 0.0;
                         } 
                         completion:^(BOOL finished) {
                             
                             [self.shoppingTableView removeFromSuperview];
                             [self.view addSubview:self.itemsTableView];
                             self.shoppingMode = NO;
                             
                             [self createItemsFRCWithFetch:YES];
                             self.currentFetchedResultsController = self.itemsFetchedResultsController;
                             [self.itemsTableView reloadData];
                         }
         ];
    }
}

#pragma mark - Private Methods

- (void)createItemsFRCWithFetch:(BOOL)fetch {

    NSFetchRequest *itemCategoryFR = [[NSFetchRequest alloc] init];
    
    itemCategoryFR.entity = [NSEntityDescription entityForName:BB_ENTITY_ITEM_CATEGORY inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
    itemCategoryFR.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    itemCategoryFR.predicate = [NSPredicate predicateWithFormat:@"type == %@", self.currentStore.type];
    
    _itemsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:itemCategoryFR managedObjectContext:[[BBStorageManager sharedManager] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    self.currentFetchedResultsController = self.itemsFetchedResultsController;
    
    if(fetch) {
        [self.itemsFetchedResultsController performFetch:nil];
    }
}

- (void)createCartFRCWithFetch:(BOOL)fetch {
    
    NSFetchRequest *cartCategoryFR = [[NSFetchRequest alloc] init];
    
    cartCategoryFR.entity = [NSEntityDescription entityForName:BB_ENTITY_ITEM inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
    cartCategoryFR.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"itemCategoryName" ascending:YES], //NOTE sort descriptor keyname MUST match the section name in the FRC!
                                      [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    cartCategoryFR.predicate = [NSPredicate predicateWithFormat:@"parentShoppingCart == %@", [self.currentStore currentShoppingCart]];
    
    _cartFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:cartCategoryFR 
                                                                         managedObjectContext:[[BBStorageManager sharedManager] managedObjectContext] 
                                                                           sectionNameKeyPath:@"itemCategoryName" 
                                                                                    cacheName:nil];
    
    if(fetch) {
        [self.cartFetchedResultsController performFetch:nil];
    }
    
}

- (void)shoppingCellSwipped:(id)sender {
    
    UISwipeGestureRecognizer *swipeGR = (UISwipeGestureRecognizer *)sender;
    
    CGPoint touch = [swipeGR locationOfTouch:0 inView:self.shoppingTableView];
    NSIndexPath *swipedIndexPath = [self.shoppingTableView indexPathForRowAtPoint:touch];
    
    //get the cell that was swipped
    BBShoppingTableViewCell *cell = (BBShoppingTableViewCell *)[self.shoppingTableView cellForRowAtIndexPath:swipedIndexPath];
    
    //check the managed object for the item's status
    BBItem *swippedItem = [self.cartFetchedResultsController objectAtIndexPath:swipedIndexPath];
    
    if([swippedItem.checkedOff boolValue] == YES) {
     
        swippedItem.checkedOff = [NSNumber numberWithBool:NO];
    }
    else {
        
        swippedItem.checkedOff = [NSNumber numberWithBool:YES];
    }
    
    [cell cellCheckedOff:[swippedItem.checkedOff boolValue]];
}

- (void)setupForShoppingMode {

    [self.itemsTableView removeFromSuperview];
    [self.view addSubview:self.shoppingTableView];
    self.shoppingMode = YES;
    
    [self createCartFRCWithFetch:YES];
    self.currentFetchedResultsController = self.cartFetchedResultsController;
    [self.shoppingTableView reloadData];
    
    UIBarButtonItem *doneShoppingButton = [[UIBarButtonItem alloc] initWithTitle:@"Finish" style:UIBarButtonItemStyleBordered target:self action:@selector(doneShopping)];
    self.navigationItem.rightBarButtonItem = doneShoppingButton;
    
}

- (void)doneShopping {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you finished shopping?" 
                                                             delegate:self 
                                                    cancelButtonTitle:@"No, not yet" 
                                               destructiveButtonTitle:@"Yes, clear this list" 
                                                    otherButtonTitles:nil, nil];

    [actionSheet showInView:self.navigationController.view];
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if(buttonIndex == 0) {

        [[[BBStorageManager sharedManager] managedObjectContext] deleteObject:self.currentStore.shoppingCart];
        
        [self createCartFRCWithFetch:YES];
        [self.shoppingTableView reloadData];
        
    }
}

@end
