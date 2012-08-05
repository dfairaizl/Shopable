//
//  BBNavContainerViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 5/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBNavContainerViewController.h"

//View Controllers
#import "BBListsViewController.h"
#import "BBShoppingListViewController.h"

@interface BBNavContainerViewController ()

@property (strong, nonatomic) UINavigationController *listsNavController;
@property (strong, nonatomic) UINavigationController *shoppingNavController;

@end

@implementation BBNavContainerViewController {
    
    BOOL showingNavigationMenu;
}

@synthesize listsNavController = _listsNavController;
@synthesize shoppingNavController = _shoppingNavController;

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
    
    [self addChildViewController:self.listsNavController];
    
    [self.view addSubview:self.listsNavController.view];
    
    [self didMoveToParentViewController:self.listsNavController];
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
    
    
}

- (void)didSelectNavigationOptionWithObject:(BBList *)selectedStore {
    
    UINavigationController *pageNav = [self shoppingListViewController];
    
    BBShoppingListViewController *controller = (BBShoppingListViewController *)pageNav.topViewController;
    
    controller.currentList = selectedStore;
    
//    NSArray *pages = @[pageNav];
//    
//    [self.pageController setViewControllers:pages 
//                                  direction:UIPageViewControllerNavigationDirectionForward 
//                                   animated:YES 
//                                 completion:^(BOOL finished) {
//                                     
//                                 }]; 
}

#pragma mark - Private Controller Methods

- (UINavigationController *)listsNavController {
    
    if(_listsNavController == nil) {
        
        _listsNavController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil]
                                                  instantiateViewControllerWithIdentifier:@"BBListsViewController"];
        
        BBListsViewController *listsViewController = (BBListsViewController *)[_listsNavController topViewController];
        
        listsViewController.delegate = self;
    }
    
    return _listsNavController;
}

- (UINavigationController *)shoppingListViewController {

    UINavigationController *pageNav = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil]
                                       instantiateViewControllerWithIdentifier:@"BBShoppingListViewController"];
    
    BBShoppingListViewController *controller = (BBShoppingListViewController *)pageNav.topViewController;
    
    controller.delegate = self;
    
    return pageNav;
}

@end
