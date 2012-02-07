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

@interface BBStoresViewController ()

@end

@implementation BBStoresViewController

@synthesize storesScrollView;
@synthesize storesPageControl;
@synthesize currentlyShoppingLabel;

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
    
    UIButton *addStoreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addStoreButton setBackgroundImage:[UIImage imageNamed:@"navbar-button-background"] forState:UIControlStateNormal];
    [addStoreButton addTarget:self action:@selector(addStore:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *addStoreBarButton = [[UIBarButtonItem alloc] initWithCustomView:addStoreButton];
    
    UIButton *toggleShoppingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [toggleShoppingButton setBackgroundImage:[UIImage imageNamed:@"navbar-button-background"] forState:UIControlStateNormal];
    [toggleShoppingButton addTarget:self action:@selector(toggleShopping:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *toggleShoppingBarButton = [[UIBarButtonItem alloc] initWithCustomView:toggleShoppingButton];
    
    self.navigationItem.leftBarButtonItem = addStoreBarButton;
    self.navigationItem.rightBarButtonItem = toggleShoppingBarButton;
    
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
    
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self.storesPageControl setCurrentPage:page];
    
}

- (void)addStore:(id)sender {
    
    NSLog(@"adding store");
    
}

- (void)toggleShopping:(id)sender {
    
    if(currentlyShopping == NO) {
        
        currentlyShopping = YES;
        
        self.currentlyShoppingLabel.hidden = NO;
        self.currentlyShoppingLabel.alpha = 0.0;
        self.storesScrollView.scrollEnabled = NO;
        
        [UIView animateWithDuration:0.4 animations:^() {
            
            self.storesPageControl.alpha = 0.0;
            self.currentlyShoppingLabel.alpha = 1.0;
        }];
    }
    else {
        
        currentlyShopping = NO;
        
        [UIView animateWithDuration:0.4 
                         animations:^() {
                             
                             self.currentlyShoppingLabel.alpha = 0.0;
                             self.storesPageControl.alpha = 1.0;
            
                         }
                         completion:^(BOOL finished) {
                             
                             self.currentlyShoppingLabel.hidden = YES;
                             self.storesScrollView.scrollEnabled = YES;
                         
                         }
         ];
    }
}

@end
