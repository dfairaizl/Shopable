//
//  BBStoresViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 2/5/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BBStoresViewController.h"

#import "BBStoreShoppingViewController.h"

//Support
#import "BBStorageManager.h"
#import "UIScrollView+Paging.h"

@implementation BBStoresViewController

@synthesize storesScrollView;
@synthesize storesPageControl;
@synthesize currentlyShoppingLabel;
@synthesize addStoreButton = _addStoreButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

    // Do any additional setup after loading the view from its nib.
    
    _addStoreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.addStoreButton setBackgroundImage:[UIImage imageNamed:@"navbar-button-background"] forState:UIControlStateNormal];
    [self.addStoreButton addTarget:self action:@selector(addStore:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *addStoreBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.addStoreButton];
    
    UIButton *toggleShoppingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [toggleShoppingButton setBackgroundImage:[UIImage imageNamed:@"navbar-button-background"] forState:UIControlStateNormal];
    [toggleShoppingButton addTarget:self action:@selector(toggleShopping:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *toggleShoppingBarButton = [[UIBarButtonItem alloc] initWithCustomView:toggleShoppingButton];
    
    self.navigationItem.leftBarButtonItem = addStoreBarButton;
    self.navigationItem.rightBarButtonItem = toggleShoppingBarButton;
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSArray *stores = [[BBStorageManager sharedManager] stores];
    
    [self.storesScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.storesScrollView.frame) * [stores count], 
                                                     CGRectGetHeight(self.storesScrollView.frame))];
    
    NSInteger i = 0;
    
    for(BBStore *store in stores) {
        
        BBStoreShoppingViewController *storeVC = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"BBStoreShoppingViewController"];
        
        storeVC.currentStore = store;
        
        storeVC.view = storeVC.contentView;
        
        CGRect frame = storeVC.view.frame;
        frame.origin.x = i * CGRectGetWidth(self.storesScrollView.frame) + 20;
        storeVC.view.frame = frame;
        
        i++;
        
        [self.storesScrollView addSubview:storeVC.view];
        
        [self addChildViewController:storeVC];
    }
    
    [self.storesPageControl setNumberOfPages:[stores count]];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    //tear down the views in the scroll view
    for(UIViewController *vc in [self childViewControllers]) {
        
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [self setStoresScrollView:nil];
    [self setStoresPageControl:nil];
    
    [self setCurrentlyShoppingLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self.storesPageControl setCurrentPage:[self.storesScrollView currentPage]];
}

- (void)addStore:(id)sender {
    
    [self performSegueWithIdentifier:@"addStoreSegue" sender:nil];
}

- (void)toggleShopping:(id)sender {
    
    BBStore *currentStore = [[self.childViewControllers objectAtIndex:[self.storesScrollView currentPage]] currentStore];
    
    if([currentStore.currentlyShopping boolValue] == NO) {
        
        currentStore.currentlyShopping = [NSNumber numberWithBool:YES];
        
        self.currentlyShoppingLabel.hidden = NO;
        self.currentlyShoppingLabel.alpha = 0.0;
        self.storesScrollView.scrollEnabled = NO;
        self.addStoreButton.enabled = NO;
        
        [UIView animateWithDuration:0.4 animations:^() {
            
            //turn off store related controlls
            self.storesPageControl.alpha = 0.0;
            self.addStoreButton.alpha = 0.0;

            //turn on shopping related controlls 
            self.currentlyShoppingLabel.alpha = 1.0;
        }];
    }
    else {
        
        currentStore.currentlyShopping = [NSNumber numberWithBool:NO];
        
        [UIView animateWithDuration:0.4 
                         animations:^() {
                             
                             //turn off shopping realted controlls
                             self.currentlyShoppingLabel.alpha = 0.0;

                             //turn on store related controlls
                             self.storesPageControl.alpha = 1.0;
                             self.addStoreButton.alpha = 1.0;
            
                         }
                         completion:^(BOOL finished) {
                             
                             self.currentlyShoppingLabel.hidden = YES;
                             self.storesScrollView.scrollEnabled = YES;
                             self.addStoreButton.enabled = YES;
                         
                         }
         ];
    }
}

@end