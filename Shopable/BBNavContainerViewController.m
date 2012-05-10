//
//  BBNavContainerViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 5/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBNavContainerViewController.h"

//View Controllers
#import "BBListsTableViewController.h"
#import "BBShoppingListViewController.h"

@interface BBNavContainerViewController ()

@property (strong, nonatomic) BBListsTableViewController *listsTableViewController;
@property (strong, nonatomic) UINavigationController *shoppingListViewController;

@end

@implementation BBNavContainerViewController {
    
    BOOL showingNavigationMenu;
}

@synthesize listsTableViewController = _listsTableViewController;
@synthesize shoppingListViewController = _shoppingListViewController;

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
    
    self.listsTableViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil]
                                     instantiateViewControllerWithIdentifier:@"BBListsTableViewController"];
    
    self.shoppingListViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil]
                                     instantiateViewControllerWithIdentifier:@"BBShoppingListViewController"];
    
    BBShoppingListViewController *shoppingList = (BBShoppingListViewController *)[self.shoppingListViewController 
                                                                                  topViewController];
    
    //setup delegates
    shoppingList.delegate = self;
    
    //child view controllers
    [self addChildViewController:self.listsTableViewController];
    [self addChildViewController:self.shoppingListViewController];
    
    //child views
    [self.view addSubview:self.listsTableViewController.view];
    [self.view addSubview:self.shoppingListViewController.view];
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

#pragma mark - BBNavigationDelegate Methods

- (void)showNavigationMenu {
    
    if(showingNavigationMenu == NO) {
     
        [UIView animateWithDuration:0.4 
                              delay:0.0 
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^() {
                             
                             CGRect frame = self.shoppingListViewController.view.frame;
                             frame.origin.x = CGRectGetWidth(self.view.frame) * 0.80;
                             self.shoppingListViewController.view.frame = frame;
                             
                         }
                         completion:^(BOOL finished) {
                            
                             showingNavigationMenu = YES;
                         }];
    }
    else {

        [UIView animateWithDuration:0.4 
                              delay:0.0 
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^() {
                             
                             CGRect frame = self.shoppingListViewController.view.frame;
                             frame.origin.x = 0;
                             self.shoppingListViewController.view.frame = frame;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             showingNavigationMenu = NO;
                         }];
    }
}

@end
