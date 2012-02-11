//
//  BBAddItemTableViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBAddItemTableViewController.h"

#import "BBItemImageViewController.h"

#import "BBStorageManager.h"

@implementation BBAddItemTableViewController

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
    
    self.shoppingItem = [NSEntityDescription insertNewObjectForEntityForName:BB_ENTITY_ITEM inManagedObjectContext:[[BBStorageManager sharedManager] managedObjectContext]];
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
    
    if([segue.identifier isEqualToString:@"addImageSegue"]) {
        
        BBItemImageViewController *imageVC = (BBItemImageViewController *)segue.destinationViewController;
        
        imageVC.currentItem = self.shoppingItem;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
