//
//  BBShoppingListAddViewController.m
//  Shopable
//
//  Created by Daniel Fairaizl on 6/18/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBShoppingListAddViewController.h"

@interface BBShoppingListAddViewController ()

@end

@implementation BBShoppingListAddViewController {

    BBShoppingListAddPullDownState currentState;
    CGFloat y;
}

@synthesize addItemPullDownView;
@synthesize addItemPullDownLabel;
@synthesize addItemSearchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BBShoppingListAddItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIScrollViewDelegate Methods

- (void)shoppingListScrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.tableView setContentOffset:CGPointMake(0, scrollView.contentOffset.y / 4)];
    
    if(scrollView.contentOffset.y <= -100) {
        
        self.addItemPullDownLabel.text = @"Release To Add Item";
        currentState = BBShoppingListAddPullDownStateRelease;

    }
    else {
        
        self.addItemPullDownLabel.text = @"Pull Down To Add Item";
        currentState = BBShoppingListAddPullDownStateNormal;
    }
}

- (void)shoppingListScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if(currentState == BBShoppingListAddPullDownStateRelease) {
        
        if([self.delegate respondsToSelector:@selector(shoppingListWillAddItem)]) {
            
            [self.delegate shoppingListWillAddItem];
        }
        
        self.tableView.tableHeaderView = self.addItemSearchBar;
        
        [UIView animateWithDuration:0.4
                         animations:^{
                             
                             [self.tableView setContentOffset:CGPointZero animated:YES];
                         }
                         completion:^(BOOL finished) {
            
                             [self.addItemSearchBar becomeFirstResponder];
                         }];
    }
    else if(currentState == BBShoppingListAddPullDownStateNormal ||
            currentState == BBShoppingListAddPullDownStateCancel) {
        
        [UIView animateWithDuration:0.4 animations:^ {
            
           [self.tableView setContentOffset:CGPointZero animated:YES];
        }];
    }
}

- (void)viewDidUnload {
    [self setAddItemPullDownLabel:nil];
    [self setAddItemPullDownView:nil];
    [self setAddItemSearchBar:nil];
    [super viewDidUnload];
}
@end
