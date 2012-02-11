//
//  BBItemImageViewController.m
//  iOutOf
//
//  Created by Dan Fairaizl on 2/10/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBItemImageViewController.h"

//Support
#import "BBStorageManager.h"

@interface BBItemImageViewController ()

- (void)usePictureFromCamera;
- (void)usePictureFromPhotoLibrary;

@end

@implementation BBItemImageViewController

@synthesize currentItem;
@synthesize itemImageView;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbar-button-background"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"navbar-button-background"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cameraBarButton = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    self.navigationItem.rightBarButtonItem = cameraBarButton;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.itemImageView.image = [self.currentItem itemImage];
}

- (void)viewDidUnload
{
    [self setItemImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Actions

- (void)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cameraButtonPressed:(id)sender {
    
    UIActionSheet *actionSheet = nil; 
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add an image for this item" 
                                                  delegate:self 
                                         cancelButtonTitle:@"Cancel" 
                                    destructiveButtonTitle:nil 
                                         otherButtonTitles:@"Take Picture", @"Use Photo Library", nil];
    }
    else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add an image for this item" 
                                                  delegate:self 
                                         cancelButtonTitle:@"Cancel" 
                                    destructiveButtonTitle:nil 
                                         otherButtonTitles:@"Use Photo Library", nil];
    }
    
    [actionSheet showInView:self.navigationController.view];
    
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
     
        if(buttonIndex == 0) {

            [self usePictureFromPhotoLibrary];
        }
    }
    else {
        
        if(buttonIndex == 0) {
            
            [self usePictureFromCamera];
        }
        else if(buttonIndex == 1) {
            
            [self usePictureFromPhotoLibrary];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *itemImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.currentItem.image = UIImagePNGRepresentation(itemImage);
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (void)usePictureFromCamera {
    
    UIImagePickerController *cameraImagePickerVC = [[UIImagePickerController alloc] init];

    cameraImagePickerVC.delegate = self;
    
    //other options
    cameraImagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentModalViewController:cameraImagePickerVC animated:YES];
}

- (void)usePictureFromPhotoLibrary {

    UIImagePickerController *cameraImagePickerVC = [[UIImagePickerController alloc] init];
    
    cameraImagePickerVC.delegate = self;
    
    //other options
    cameraImagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:cameraImagePickerVC animated:YES];
    
}

@end
