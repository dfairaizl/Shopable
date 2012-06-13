//
//  BBItemCategoryViewController.m
//  Shopable
//
//  Created by Dan Fairaizl on 5/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItemCategoryViewController.h"

//DB
#import "BBStorageManager.h"

//Controllers
#import "BBItemsListTableViewController.h"

//Views
#import "BBItemCategoryView.h"

@interface BBItemCategoryViewController ()

@property (strong, readonly, nonatomic) NSMutableArray *itemCategories;

- (void)displayItemCategories;

@end

@implementation BBItemCategoryViewController

@synthesize scrollView;

@synthesize currentList;

@synthesize itemCategories = _itemCategories;

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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:nil 
                                                                            action:nil];
    
    [self displayItemCategories];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"categoryItemsSegue"]) {
        
        BBItemCategoryView *categoryView = (BBItemCategoryView *)sender;
        NSInteger index = categoryView.itemIndex;
        
        BBItemsListTableViewController *itemsList = (BBItemsListTableViewController *)segue.destinationViewController;
        
        itemsList.currentItemCategory = (self.itemCategories)[index];
        itemsList.currentList = self.currentList;
    }
}

#pragma mark - Overrides

- (NSMutableArray *)itemCategories {
    
    if(_itemCategories == nil) {
        
        _itemCategories = [[NSMutableArray alloc] initWithCapacity:20];
        
        NSManagedObjectContext *moc = [[BBStorageManager sharedManager] managedObjectContext];
        
        NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:BB_ENTITY_ITEM_CATEGORY];
        [fr setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        [_itemCategories addObjectsFromArray:[moc executeFetchRequest:fr error:nil]];
    }
    
    return _itemCategories;
}

#pragma mark - UI Actions

- (IBAction)doneButtonPressed:(id)sender {
    
    [[BBStorageManager sharedManager] saveContext];

    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)categoryButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"categoryItemsSegue" sender:sender];
}

#pragma mark - Private Methods

- (void)displayItemCategories {
    
    __block NSInteger row = 1;
    __block CGFloat x = 5.0, y = 5.0;
    
    [self.itemCategories enumerateObjectsUsingBlock:^(BBItemCategory *category, NSUInteger index, BOOL *stop) {
        
        BBItemCategoryView *categoryView = [[[NSBundle mainBundle] loadNibNamed:@"BBItemCategoryView" 
                                                                          owner:nil
                                                                        options:nil] lastObject];
        
        [categoryView addTarget:self action:@selector(categoryButtonPressed:) 
               forControlEvents:UIControlEventTouchUpInside];
        
        categoryView.itemIndex = index;
        
        if(x < CGRectGetWidth(self.view.frame)) {
            
            CGRect frame = categoryView.frame;
            frame.origin = CGPointMake(x, y);
            categoryView.frame = frame;
            
            //hook up IBOutlets
            categoryView.categoryLabel.text = category.name;
            
            [self.scrollView addSubview:categoryView];
            
            x += CGRectGetWidth(categoryView.frame) + 10;
        }
        
        if(x > CGRectGetWidth(self.view.frame)) {
            
            x = 5.0;
            y += CGRectGetHeight(categoryView.frame) + 10;
            row++;
        }
    }];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), y);
}

@end
