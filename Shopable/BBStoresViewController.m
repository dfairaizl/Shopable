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
- (void)resizeStoresForOrientation:(UIInterfaceOrientation)orientation;
- (NSArray *)updatedStoresInStores:(NSArray *)stores;
- (void)enterShoppingModeWithViewController:(BBStoreShoppingViewController *)storeVC;
- (void)exitShoppingModeWithViewController:(BBStoreShoppingViewController *)storeVC;

@end

@implementation BBStoresViewController

@synthesize storesScrollView;
@synthesize storesPageControl;
@synthesize currentlyShoppingLabel;
@synthesize editStoresButton;
@synthesize toggleShoppingButton = _toggleShoppingButton;
@synthesize addStoreButton = _addStoreButton;
@synthesize editShoppingCartButton;
@synthesize finishedShoppingButton;

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
    
    [self.navigationItem.rightBarButtonItem setTitle:@"Shop"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStores) name:[NSString stringWithString:@"RefreshUI"] object:nil];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self loadStores];
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

    [self setFinishedShoppingButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
     
        return YES;
    }
    else {
        
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {

    NSLog(@"scroll view frame: %@", NSStringFromCGRect(self.storesScrollView.frame));

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        [self resizeStoresForOrientation:interfaceOrientation];
    }
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

- (IBAction)addStoreButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"addStoreSegue" sender:nil];
}

- (IBAction)toggleShoppingButtonPressed:(id)sender {
    
    BBStoreShoppingViewController *shoppingVC = [self.childViewControllers objectAtIndex:[self.storesScrollView currentPage]];
    BBStore *currentStore = shoppingVC.currentStore;
    
    if([currentStore.currentlyShopping boolValue] == NO) {
        
        currentStore.currentlyShopping = [NSNumber numberWithBool:YES];
        
        [self enterShoppingModeWithViewController:shoppingVC];
    }
    else {
        
        //entering planning mode
        
        currentStore.currentlyShopping = [NSNumber numberWithBool:NO];
        
        [shoppingVC.storeTableView setEditing:NO animated:YES];
        
        [self exitShoppingModeWithViewController:shoppingVC];
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

- (IBAction)finishedShoppingButtonPressed:(id)sender {

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Clear shopping list?" 
                                                             delegate:self 
                                                    cancelButtonTitle:@"No, not yet" 
                                               destructiveButtonTitle:@"Yes, clear list" 
                                                    otherButtonTitles:nil, nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0) {
        
        //destroy this list
        
        //switch out of shopping mode and reset UI
        [self toggleShoppingButtonPressed:nil];
        
        //get the current store
        BBStoreShoppingViewController *shoppingVC = [self.childViewControllers objectAtIndex:[self.storesScrollView currentPage]];
        BBStore *currentStore = shoppingVC.currentStore;
        
        //clear the shopping cart of this store
        [[[BBStorageManager sharedManager] managedObjectContext] deleteObject:currentStore.shoppingCart];
        
        [[BBStorageManager sharedManager] saveContext];
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
        
        BBStoreShoppingViewController *storeVC = nil;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            storeVC = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"BBStoreShoppingViewController"];
            
            //set the size of these frames to the size of the scroll view in the current orientaiton
            CGRect frame = storeVC.view.frame;
            frame.size = CGSizeMake(CGRectGetWidth(self.storesScrollView.frame) - 40, CGRectGetHeight(self.storesScrollView.frame) - 40);
            storeVC.view.frame = frame;
        }
        else {
            
            storeVC = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"BBStoreShoppingViewController"];
        }
        
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
                             
                             NSInteger count = [stores count];
                             [self.storesPageControl setNumberOfPages:count];
                             NSInteger currentPage = [self.storesScrollView currentPage];
                             [self.storesPageControl setCurrentPage:currentPage];
                         }];
    }
    
    //check if one of the stores in the list is 'currently shopping'
    //if so, toggle the UI and show that store
    [stores enumerateObjectsUsingBlock:^(BBStore *store, NSUInteger index, BOOL *stop) {
      
        if([[store currentlyShopping] boolValue] == YES) {
         
            BBStoreShoppingViewController *storeVC = [self.childViewControllers objectAtIndex:index];
            [self.storesScrollView scrollToPage:index animated:YES];
            [self enterShoppingModeWithViewController:storeVC];
        }
    }];
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

- (void)resizeStoresForOrientation:(UIInterfaceOrientation)orientation {
    
    if([self.childViewControllers count] > 0) {
     
        [self.storesScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.storesScrollView.frame) * [self.childViewControllers count], 
                                                         CGRectGetHeight(self.storesScrollView.frame))];

        [self.childViewControllers enumerateObjectsUsingBlock:^(BBStoreShoppingViewController *storeVC, NSUInteger index, BOOL *stop) {
           
            CGRect frame = storeVC.view.frame;
            frame.origin.x = index * CGRectGetWidth(self.storesScrollView.frame) + 20;
            storeVC.view.frame = frame;
            
        }];

        BBStoreShoppingViewController *currentStore = [self.childViewControllers objectAtIndex:[self.storesScrollView currentPage]];
        CGRect currentView = currentStore.view.frame;
        currentView.origin.x += 20;

        [self.storesScrollView scrollRectToVisible:currentView animated:NO];
    }
}

- (void)enterShoppingModeWithViewController:(BBStoreShoppingViewController *)storeVC {
    
    //entering shopping mode
    
    [self.navigationItem.rightBarButtonItem setTitle:@"Plan"];
    
    self.currentlyShoppingLabel.hidden = NO;
    self.currentlyShoppingLabel.alpha = 0.0;
    self.storesScrollView.scrollEnabled = NO;
    self.addStoreButton.enabled = NO;
    self.editStoresButton.enabled = NO;
    self.editShoppingCartButton.hidden = NO;
    self.editShoppingCartButton.enabled = YES;
    self.finishedShoppingButton.hidden = NO;
    self.finishedShoppingButton.alpha = 0.0;
    
    [UIView animateWithDuration:0.4 animations:^() {
        
        //turn off store related controlls
        self.storesPageControl.alpha = 0.0;
        self.addStoreButton.alpha = 0.0;
        self.editStoresButton.alpha = 0.0;
        
        //turn on shopping related controlls 
        self.currentlyShoppingLabel.alpha = 1.0;
        self.editShoppingCartButton.alpha = 1.0;
        self.finishedShoppingButton.alpha = 1.0;
        
        [storeVC.addItemsButton setImage:[UIImage imageNamed:@"QuickAddItem"] forState:UIControlStateNormal];
    }];
    
}

- (void)exitShoppingModeWithViewController:(BBStoreShoppingViewController *)storeVC {
    
    [self.navigationItem.rightBarButtonItem setTitle:@"Shop"];
    
    [UIView animateWithDuration:0.4 
                     animations:^() {
                         
                         //turn off shopping realted controlls
                         self.currentlyShoppingLabel.alpha = 0.0;
                         self.editShoppingCartButton.alpha = 0.0;
                         self.finishedShoppingButton.alpha = 0.0;
                         
                         //turn on store related controlls
                         self.storesPageControl.alpha = 1.0;
                         self.addStoreButton.alpha = 1.0;
                         self.editStoresButton.alpha = 1.0;
                         
                         [storeVC.addItemsButton setImage:[UIImage imageNamed:@"AddItems"] forState:UIControlStateNormal];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         self.currentlyShoppingLabel.hidden = YES;
                         self.storesScrollView.scrollEnabled = YES;
                         self.addStoreButton.enabled = YES;
                         self.editShoppingCartButton.enabled = NO;
                         self.editStoresButton.enabled = YES;
                         self.finishedShoppingButton.hidden = YES;
                     }
     ];
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
                             [self.storesScrollView scrollRectToVisible:CGRectMake(frame.origin.x + 20, 
                                                                                   frame.origin.y, 
                                                                                   frame.size.width, 
                                                                                   frame.size.height) 
                                                               animated:YES];
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
