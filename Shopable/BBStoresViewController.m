//
//  BBStoresViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/5/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStoresViewController.h"

#import "BBStoreShoppingViewController.h"
#import "BBAddStoreTableViewController.h"

//Support
#import "BBStorageManager.h"
#import "UIScrollView+Paging.h"

@interface BBStoresViewController ()

- (void)loadStores;
- (NSArray *)updatedStoresInStores:(NSArray *)stores;

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
    [self.addStoreButton addTarget:self action:@selector(addStoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *addStoreBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.addStoreButton];
    
    _toggleShoppingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.toggleShoppingButton setBackgroundImage:[UIImage imageNamed:@"navbar-button-background"] forState:UIControlStateNormal];
    [self.toggleShoppingButton addTarget:self action:@selector(toggleShoppingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *toggleShoppingBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.toggleShoppingButton];
    
    self.navigationItem.leftBarButtonItem = addStoreBarButton;
    self.navigationItem.rightBarButtonItem = toggleShoppingBarButton;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStores) name:[NSString stringWithString:@"RefreshUI"] object:nil];

    [self loadStores];
}

- (void)viewWillAppear:(BOOL)animated {

    
}

- (void)viewDidDisappear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"addStoreSegue"]) {
        
        BBAddStoreTableViewController *addStoreVC = (BBAddStoreTableViewController *)[segue.destinationViewController topViewController];
        
        addStoreVC.storeDelegate = self;
    }
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self.storesPageControl setCurrentPage:[self.storesScrollView currentPage]];
}

#pragma mark - UI Action Methods

- (void)addStoreButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"addStoreSegue" sender:nil];
}

- (void)toggleShoppingButtonPressed:(id)sender {
    
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

- (void)loadStores {

    NSArray *stores = [BBStore stores];
    
    NSArray *updateStores = [self updatedStoresInStores:stores];

    [self.storesScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.storesScrollView.frame) * [stores count], 
                                                     CGRectGetHeight(self.storesScrollView.frame))];

    NSInteger i = 0;

    for(BBStore *store in updateStores) {
        
        BBStoreShoppingViewController *storeVC = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"BBStoreShoppingViewController"];
        
        storeVC.currentStore = store;
        storeVC.parentStoresViewController = self;
        
        storeVC.view = storeVC.contentView;
        
        CGRect frame = storeVC.view.frame;
        frame.origin.x = i * CGRectGetWidth(self.storesScrollView.frame) + 20;
        storeVC.view.frame = frame;
        
        i++;
        
        [self addChildViewController:storeVC];
        
        [self.storesScrollView addSubview:storeVC.view];
        
        storeVC.view.alpha = 0.0;
        
        [UIView animateWithDuration:0.25 
                              delay:0.4 
                            options:UIViewAnimationOptionCurveLinear 
                         animations:^() {
                                
                             storeVC.view.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }

    [self.storesPageControl setNumberOfPages:[stores count]];
    [self.storesPageControl setCurrentPage:[self.storesScrollView currentPage]];
}

- (NSArray *)updatedStoresInStores:(NSArray *)stores {

    __block NSMutableArray *updateStores = [NSMutableArray arrayWithArray:stores];

    //determine what stores are actually on the screen
    [self.childViewControllers enumerateObjectsUsingBlock:^(BBStoreShoppingViewController *storeVC, NSUInteger index, BOOL *stop) {
        
        for(BBStore *store in stores) {
            
            if(storeVC.currentStore == store) {
                
                [updateStores removeObject:store];
            }
        }
    }];

    return updateStores;
}

#pragma mark - BBStoreDelegate Methods

- (void)addStore:(BBStore *)store {

    NSInteger storesCount = [[BBStore stores] count];
    
    //Update the scroll view to hold the new store
    [self.storesScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.storesScrollView.frame) * storesCount, 
                                                 CGRectGetHeight(self.storesScrollView.frame))];

    //Update the page indicator
    [self.storesPageControl setNumberOfPages:storesCount];
    [self.storesPageControl setCurrentPage:storesCount];
    
    //Create the store view controller
    BBStoreShoppingViewController *storeVC = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"BBStoreShoppingViewController"];
    
    storeVC.currentStore = store;
    storeVC.parentStoresViewController = self;
    
    storeVC.view = storeVC.contentView;
    
    CGRect frame = storeVC.view.frame;
    frame.origin.x = (storesCount - 1)  * CGRectGetWidth(self.storesScrollView.frame) + 20;
    storeVC.view.frame = frame;
    
    [self addChildViewController:storeVC];
    
    [self.storesScrollView addSubview:storeVC.view];
    
    //fade in the new store
    storeVC.view.alpha = 0.0;
    
    if(storesCount <= 0) {
        
        [UIView animateWithDuration:0.4 
                              delay:0.25 
                            options:UIViewAnimationOptionCurveLinear 
                         animations:^() {
                             storeVC.view.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    else {
     
        [UIView animateWithDuration:0.5 
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut 
                         animations:^() {
                             
                             //scroll over to the new store
                             [self.storesScrollView scrollRectToVisible:CGRectMake(frame.origin.x + 20, frame.origin.y, frame.size.width, frame.size.height) animated:YES];
                         }
                         completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:0.4 
                                                   delay:0.5 
                                                 options:UIViewAnimationOptionCurveLinear 
                                              animations:^() {
                                                  storeVC.view.alpha = 1.0;
                                              }
                                              completion:^(BOOL finished) {
                                                  
                                              }];
                         }];
    }
}

@end
