//
//  BBItemCategoryTableViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBShoppingViewController.h"
#import "BBItemsTableViewController.h"

#import "BBToolbarShoppingView.h"

#import "BBStorageManager.h"

@interface BBShoppingViewController ()

@property BOOL shoppingMode;

@end

@interface BBShoppingViewController (TableCustomization)

- (UITableViewCell *)configureItemsCell:(UITableViewCell *)cell withCategory:(BBItemCategory *)category;
- (UITableViewCell *)configureShoppingCell:(UITableViewCell *)cell;

@end

@implementation BBShoppingViewController

@synthesize currentStore;
@synthesize frc = _frc;
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
    
    NSFetchRequest *itemCategoryFR = [[NSFetchRequest alloc] init];
    
    itemCategoryFR.entity = [NSEntityDescription entityForName:BB_ENTITY_ITEM_CATEGORY inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
    itemCategoryFR.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    itemCategoryFR.predicate = [NSPredicate predicateWithFormat:@"type == %@", self.currentStore.type];
    
    _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:itemCategoryFR managedObjectContext:[[BBStorageManager sharedManager] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    [self.frc performFetch:nil];
    
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
        itemsVC.currentItemCategory = (BBItemCategory *)sender;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.frc sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.frc sections] objectAtIndex:section];

    return [sectionInfo numberOfObjects];
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
        cell = [tableView dequeueReusableCellWithIdentifier:shoppingCellIdentifier];
    }
    
    // Configure the cell...
    if(self.shoppingMode == NO) {

        BBItemCategory *category = (BBItemCategory *)[self.frc objectAtIndexPath:indexPath];

        cell = [self configureItemsCell:cell withCategory:category];
    }
    else {
        
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBItemCategory *selectedCategory = [self.frc objectAtIndexPath:indexPath];
 
    [self performSegueWithIdentifier:@"itemsForCategorySegue" sender:selectedCategory];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table Customization Methods

- (UITableViewCell *)configureItemsCell:(UITableViewCell *)cell withCategory:(BBItemCategory *)category {
    
    cell.textLabel.text = category.name;
    
    return cell;
}

- (UITableViewCell *)configureShoppingCell:(UITableViewCell *)cell {
    
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
                         
                         [self.itemsTableView removeFromSuperview];
                         [self.view addSubview:self.shoppingTableView];
                         self.shoppingMode = YES;
                     }
     ];
}

@end
