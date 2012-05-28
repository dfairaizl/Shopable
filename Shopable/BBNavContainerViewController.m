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

@property (strong, nonatomic) UIPageViewController *pageController;

@property (strong, nonatomic) UINavigationController *listsTableViewController;
@property (strong, nonatomic) UINavigationController *shoppingListViewController;

@end

@interface BBNavContainerViewController (Controllers)

- (UINavigationController *)listsViewController;
- (UINavigationController *)shoppingListViewController;

@end

@implementation BBNavContainerViewController {
    
    BOOL showingNavigationMenu;
}

@synthesize pageController = _pageController;

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
    
    //First page is the lists menu
    
    UIViewController *listsController = [self listsViewController];
    
    NSArray *pages = [NSArray arrayWithObject:listsController];
    
    [self.pageController setViewControllers:pages 
                                  direction:UIPageViewControllerNavigationDirectionForward 
                                   animated:YES 
                                 completion:^(BOOL finished) {
        
                                 }];
    
    [self.pageController.gestureRecognizers enumerateObjectsUsingBlock:^(UIGestureRecognizer *gr, NSUInteger index, BOOL *stop) {
       
        if([gr isMemberOfClass:[UITapGestureRecognizer class]]) {
         
            gr.delegate = self;
        }
    }];
    
    [self addChildViewController:self.pageController];
    
    [self.view addSubview:self.pageController.view];
    
    //[self didMoveToParentViewController:self.pageController];
    
    //self.view.gestureRecognizers = self.pageController.gestureRecognizers;
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

- (UIPageViewController *)pageController {
    
    if(_pageController == nil) {
        
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMin]  
                                                            forKey:UIPageViewControllerOptionSpineLocationKey];
        
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl 
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationVertical 
                                                                        options:options];
        
        _pageController.dataSource = self;
        _pageController.delegate = self;
    }
    
    return _pageController;
}

#pragma mark - UIPageViewControllerDatasource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    UIViewController *viewControllerAfter = nil;
    
    if([viewController isMemberOfClass:[BBListsViewController class]]) {
        
        viewControllerAfter = [self shoppingListViewController];
    }
    else if([viewController isMemberOfClass:[BBShoppingListViewController class]]) {
        
        viewControllerAfter = [self listsViewController];
    }
    
    return viewControllerAfter;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    UIViewController *viewControllerBefore = nil;
    
    if([viewController isMemberOfClass:[BBListsViewController class]]) {
        
        viewControllerBefore = [self shoppingListViewController];
    }
    else if([viewController isMemberOfClass:[BBShoppingListViewController class]]) {
        
        viewControllerBefore = [self listsViewController];
    }
    
    return viewControllerBefore;
}

#pragma mark - BBNavigationDelegate Methods

- (void)showNavigationMenu {
    
    UIViewController *listsController = [self listsViewController];
    
    NSArray *pages = [NSArray arrayWithObject:listsController];
    
    [self.pageController setViewControllers:pages 
                                  direction:UIPageViewControllerNavigationDirectionReverse 
                                   animated:YES 
                                 completion:^(BOOL finished) {
                                     
                                 }];
}

- (void)didSelectNavigationOptionWithObject:(BBList *)selectedStore {
    
    UINavigationController *pageNav = [self shoppingListViewController];
    
    BBShoppingListViewController *controller = (BBShoppingListViewController *)pageNav.topViewController;
    
    controller.currentList = selectedStore;
    
    NSArray *pages = [NSArray arrayWithObject:pageNav];
    
    [self.pageController setViewControllers:pages 
                                  direction:UIPageViewControllerNavigationDirectionForward 
                                   animated:YES 
                                 completion:^(BOOL finished) {
                                     
                                 }]; 
}

#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    BOOL continueTouch = YES;
    
    if([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]]) {
    
        if([touch.view isKindOfClass:[UITableViewCell class]] == NO) {
            
            continueTouch = NO;
        }
        else if([touch.view isKindOfClass:[UIControl class]] == NO) {
            
            continueTouch = NO;
        }
    }
    
    return continueTouch;
}

#pragma mark - Private Controller Methods

- (UINavigationController *)listsViewController {
    
    UINavigationController *listsNavController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil]
                                              instantiateViewControllerWithIdentifier:@"BBListsViewController"];
    
    BBListsViewController *listsViewController = (BBListsViewController *)[listsNavController topViewController];
    
    listsViewController.delegate = self;
    
    return listsNavController;
}

- (UINavigationController *)shoppingListViewController {

    UINavigationController *pageNav = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil]
                                       instantiateViewControllerWithIdentifier:@"BBShoppingListViewController"];
    
    BBShoppingListViewController *controller = (BBShoppingListViewController *)pageNav.topViewController;
    
    controller.delegate = self;
    
    return pageNav;
}

@end
