//
//  BBShoppingListDetailsViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 6/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBShoppingListDetailsViewController.h"

//DB
#import "BBStorageManager.h"

//Cells
#import "BBShoppingItemDetailsCell.h"

@interface BBShoppingListDetailsViewController ()

@property (strong, nonatomic) NSMutableArray *cells;

@end

@implementation BBShoppingListDetailsViewController

@synthesize currentItem;

@synthesize cells = _cells;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = self.currentItem.item.name;
    
    if([self.currentItem.notes length] > 0) {
        
        [self.cells addObject:BBShoppingDetailsCellTypeNotes];
    }
    
    if(self.currentItem.photo != nil) {
        
        [self.cells addObject:BBShoppingDetailsCellTypePhoto];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Overrides

- (NSMutableArray *)cells {
    
    if(_cells == nil) {
        
        _cells = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    return _cells;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 0;
    
    if([self.currentItem.notes length] > 0) {
        
        sections++;
    }
    
    if(self.currentItem.photo != nil) {
        
        sections++;
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = @"";
    NSInteger sections = [tableView numberOfSections];
    
    if(section == 0) {
     
        if(sections == 1) {
            
            if([self.currentItem.notes length] > 0) {
                
                title = @"Notes";
                
            }
            else if(self.currentItem.photo != nil) {
                
                title = @"Photo";
                
            }
        }
        else if(sections > 1) {
            
            if(section == 0) {
                
                title = @"Notes";
            }
            else if(section == 1) {

                title = @"Photo";
            }
        }
    }
    else if(section == 1) {
        
        title = @"Photo";
    }
    
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0.0f;
    
    if([[self.cells objectAtIndex:indexPath.section] isEqualToString:BBShoppingDetailsCellTypeNotes]) {
        
        CGSize labelSize = [self.currentItem.notes sizeWithFont:[UIFont systemFontOfSize:15] 
                                              constrainedToSize:CGSizeMake(260, MAXFLOAT) 
                                                  lineBreakMode:UILineBreakModeWordWrap];
        
        height = labelSize.height + 22;
    }
    else if([[self.cells objectAtIndex:indexPath.section] isEqualToString:BBShoppingDetailsCellTypePhoto]) {
        
        height = 320.0;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;
    
    // Configure the cell...
    
    if([[self.cells objectAtIndex:indexPath.section] isEqualToString:BBShoppingDetailsCellTypeNotes]) {
        
        cellIdentifier = @"shoppingItemDetailsCellNotes";
    }
    else if([[self.cells objectAtIndex:indexPath.section] isEqualToString:BBShoppingDetailsCellTypePhoto]) {
     
        cellIdentifier = @"shoppingItemDetailsCellPhoto";
    }
    
    BBShoppingItemDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if([[self.cells objectAtIndex:indexPath.section] isEqualToString:BBShoppingDetailsCellTypeNotes]) {
        
        cell.itemNotesLabel.text = self.currentItem.notes;
        
        CGSize labelSize = [self.currentItem.notes sizeWithFont:[UIFont systemFontOfSize:15] 
                                              constrainedToSize:CGSizeMake(260, MAXFLOAT) 
                                                  lineBreakMode:UILineBreakModeWordWrap];
        
        CGRect frame = cell.itemNotesLabel.frame;
        frame.size.height = labelSize.height;
        cell.itemNotesLabel.frame = frame;
    }
    else if([[self.cells objectAtIndex:indexPath.section] isEqualToString:BBShoppingDetailsCellTypePhoto]) {
        
        dispatch_async(dispatch_get_main_queue(), ^ {
           
            cell.itemPhotoImageView.image = [self.currentItem itemPhoto];
        });
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
