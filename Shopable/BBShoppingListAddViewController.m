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

@synthesize addItemPullDownLabel;

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
    
    CGRect frame = self.view.frame;
    CGFloat yOffset = scrollView.contentOffset.y;
    
    if(yOffset < y) {
        
        frame.origin.y = frame.origin.y + fabsf(scrollView.contentOffset.y / CGRectGetHeight(frame)) * 4;
        self.view.frame = frame;
    }
    else {
        
        frame.origin.y = frame.origin.y - fabsf(scrollView.contentOffset.y / CGRectGetHeight(frame)) * 4;
        self.view.frame = frame;
    }
    
    if(scrollView.contentOffset.y <= -100) {
        
        if([self.delegate respondsToSelector:@selector(shoppingListWillAddItem)]) {
            
            //[self.delegate shoppingListWillAddItem];
            self.addItemPullDownLabel.text = @"Release To Add Item";
            
            currentState = BBShoppingListAddPullDownStateRelease;
        }
    }
    
    y = yOffset;
}

- (void)shoppingListScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if(currentState == BBShoppingListAddPullDownStateRelease) {
        
        [self.delegate shoppingListWillAddItem];
    }
    else if(currentState == BBShoppingListAddPullDownStateNormal ||
            currentState == BBShoppingListAddPullDownStateCancel) {
        
        [UIView animateWithDuration:0.4 animations:^ {
            
            CGRect frame = self.view.frame;
            frame.origin.y = -22;
            self.view.frame = frame;
        }];
    }
}

- (void)viewDidUnload {
    [self setAddItemPullDownLabel:nil];
    [super viewDidUnload];
}
@end
