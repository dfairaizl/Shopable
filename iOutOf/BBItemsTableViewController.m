//
//  BBItemsTableViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItemsTableViewController.h"

#import "BBStorageManager.h"

@interface BBItemsTableViewController ()

@property (strong, nonatomic) NSArray *items;

@end

@implementation BBItemsTableViewController

@synthesize currentStore;
@synthesize currentItemCategory;
@synthesize items;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    self.items = [[self.currentItemCategory.items allObjects] sortedArrayUsingComparator:^NSComparisonResult(BBItem *item1, BBItem *item2) {

        return [item1.name compare:item2.name];
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = self.currentItemCategory.name;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BBShoppingCart *currentCart = [self.currentStore currentShoppingCart];
    BBItem *item = [self.items objectAtIndex:indexPath.row];
    
    if([currentCart containsItem:item] == YES) {
     
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    // Configure the cell...
    cell.textLabel.text = item.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    BBShoppingCart *currentCart = [self.currentStore currentShoppingCart];
    BBItem *item = [self.items objectAtIndex:indexPath.row];
    
    if([currentCart containsItem:item] == NO) {
        
        [currentCart addItemToCart:item];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        
        [currentCart removeItemFromCart:item];
       
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
