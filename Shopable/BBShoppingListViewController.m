//
//  BBShoppingListViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 5/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBShoppingListViewController.h"

@interface BBShoppingListViewController ()

@end

@implementation BBShoppingListViewController

@synthesize delegate;
@synthesize currentList = _currentList;

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Overrides

- (void)setCurrentList:(BBList *)currentList {
    
    _currentList = currentList;
    
    self.title = _currentList.name;
}

#pragma mark - UI Actions

- (IBAction)showMenuButtonPressed:(id)sender {

    [self.delegate showNavigationMenu];
}

@end
