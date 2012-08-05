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
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^ {
                         
                         //animate the frame
                         CGRect frame = self.shoppingNavController.view.frame;
                         frame.origin.y = CGRectGetHeight(frame);
                         self.shoppingNavController.view.frame = frame;
                     }
                     completion:^(BOOL complete) {
                         
                         [self.shoppingNavController.view removeFromSuperview];
                         
                         [self.shoppingNavController removeFromParentViewController];
                         
                         [UIView animateWithDuration:0.25
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^ {
                                              
                                              self.listsNavController.view.layer.transform = CATransform3DIdentity;
                                          }
                                          completion:^(BOOL complete) {
                                              
                                          }];
                     }];
    
}

- (void)didSelectNavigationOptionWithObject:(BBList *)selectedStore {
    
    UINavigationController *navController = self.shoppingNavController;
    
    BBShoppingListViewController *controller = (BBShoppingListViewController *)navController.topViewController;

    controller.currentList = selectedStore;
    
    //set its frame off screen for animation
    CGRect frame = self.shoppingNavController.view.frame;
    frame.origin.y = CGRectGetHeight(controller.view.frame);
    self.shoppingNavController.view.frame = frame;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^ {
                         
                         CATransform3D transform = CATransform3DMakeScale(0.8f, 0.8f, 0.8f);
                         transform = CATransform3DTranslate(transform, 0.f, -30.f, 0.f);
                         
                         self.listsNavController.view.layer.transform = transform;
                     }
                     completion:^(BOOL complete) {
                         
                         [UIView animateWithDuration:0.4
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^ {
                                              
                                              //add the shopping list view to the container
                                              [self addChildViewController:self.shoppingNavController];
                                              
                                              //add the shopping list view to the containers view
                                              [self.view addSubview:self.shoppingNavController.view];
                                              
                                              //animate the frame
                                              CGRect frame = self.shoppingNavController.view.frame;
                                              frame.origin.y = 0;
                                              self.shoppingNavController.view.frame = frame;
                                          }
                                          completion:^(BOOL complete) {
                                              
                                          }];
                     }];
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

- (UINavigationController *)shoppingNavController {

    if(_shoppingNavController == nil) {
     
        UINavigationController *navController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil]
                                           instantiateViewControllerWithIdentifier:@"BBShoppingListViewController"];

        _shoppingNavController = navController;
        
        BBShoppingListViewController *controller = (BBShoppingListViewController *)navController.topViewController;
        
        controller.delegate = self;
    }
    
    return _shoppingNavController;
}

@end
