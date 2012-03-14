//
//  BBStoresViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/5/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStoresViewController.h"

#import "BBStoreShoppingViewController.h"

//Support
#import "BBStorageManager.h"
#import "UIScrollView+Paging.h"

@interface BBStoresViewController ()

- (void)reloadStores;

@end

@implementation BBStoresViewController

@synthesize storesScrollView;
@synthesize storesPageControl;
@synthesize currentlyShoppingLabel;
@synthesize editStoresButton;
@synthesize toggleShoppingButton = _toggleShoppingButton;
@synthesize addStoreButton = _addStoreButton;
@synthesize editShoppingCartButton;

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
    
    _toggleShoppingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.toggleShoppingButton setBackgroundImage:[UIImage imageNamed:@"navbar-button-background"] forState:UIControlStateNormal];
    [self.toggleShoppingButton addTarget:self action:@selector(toggleShopping:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *toggleShoppingBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.toggleShoppingButton];
    
    self.navigationItem.leftBarButtonItem = addStoreBarButton;
    self.navigationItem.rightBarButtonItem = toggleShoppingBarButton;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadStores) name:[NSString stringWithString:@"RefreshUI"] object:nil];
}

- (void)viewWillAppear:(BOOL)animated {

    [self reloadStores];
}

- (void)viewDidDisappear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    [self setEditShoppingCartButton:nil];
    [self setEditStoresButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self.storesPageControl setCurrentPage:[self.storesScrollView currentPage]];
}

#pragma mark - UI Action Methods

- (void)addStore:(id)sender {
    
    [self performSegueWithIdentifier:@"addStoreSegue" sender:nil];
}

- (void)toggleShopping:(id)sender {
    
    BBStoreShoppingViewController *shoppingVC = [self.childViewControllers objectAtIndex:[self.storesScrollView currentPage]];
    BBStore *currentStore = shoppingVC.currentStore;
    
    if([currentStore.currentlyShopping boolValue] == NO) {
        
        currentStore.currentlyShopping = [NSNumber numberWithBool:YES];
        
        self.currentlyShoppingLabel.hidden = NO;
        self.currentlyShoppingLabel.alpha = 0.0;
        self.storesScrollView.scrollEnabled = NO;
        self.addStoreButton.enabled = NO;
        self.editStoresButton.enabled = NO;
        self.editShoppingCartButton.hidden = NO;
        self.editShoppingCartButton.enabled = YES;
        
        [UIView animateWithDuration:0.4 animations:^() {
            
            //turn off store related controlls
            self.storesPageControl.alpha = 0.0;
            self.addStoreButton.alpha = 0.0;
            self.editStoresButton.alpha = 0.0;

            //turn on shopping related controlls 
            self.currentlyShoppingLabel.alpha = 1.0;
            self.editShoppingCartButton.alpha = 1.0;
        }];
    }
    else {
        
        currentStore.currentlyShopping = [NSNumber numberWithBool:NO];
        [shoppingVC.storeTableView setEditing:NO animated:YES];
        
        [UIView animateWithDuration:0.4 
                         animations:^() {
                             
                             //turn off shopping realted controlls
                             self.currentlyShoppingLabel.alpha = 0.0;
                             self.editShoppingCartButton.alpha = 0.0;

                             //turn on store related controlls
                             self.storesPageControl.alpha = 1.0;
                             self.addStoreButton.alpha = 1.0;
                             self.editStoresButton.alpha = 1.0;
            
                         }
                         completion:^(BOOL finished) {
                             
                             self.currentlyShoppingLabel.hidden = YES;
                             self.storesScrollView.scrollEnabled = YES;
                             self.addStoreButton.enabled = YES;
                             self.editShoppingCartButton.enabled = NO;
                             self.editStoresButton.enabled = YES;
                         
                         }
         ];
    }
}

- (IBAction)editShoppingCartButtonPressed:(id)sender {

    BBStoreShoppingViewController *storeShoppingVC = [self.childViewControllers objectAtIndex:[self.storesScrollView currentPage]];

    if([storeShoppingVC.storeTableView isEditing] == YES) {

        [storeShoppingVC.storeTableView setEditing:NO animated:YES];
    }
    else {
        
        [storeShoppingVC.storeTableView setEditing:YES animated:YES];
    }
}

#pragma mark - Private Methods

- (void)reloadStores {

    NSArray *stores = [BBStore stores];

    [self.storesScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.storesScrollView.frame) * [stores count], 
                                                     CGRectGetHeight(self.storesScrollView.frame))];

    NSInteger i = 0;

    for(BBStore *store in stores) {
        
        BBStoreShoppingViewController *storeVC = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"BBStoreShoppingViewController"];
        
        storeVC.currentStore = store;
        storeVC.parentStoresViewController = self;
        
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

@end
