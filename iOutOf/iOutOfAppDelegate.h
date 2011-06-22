//
//  iOutOfAppDelegate.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/20/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController, ShoppingListViewController, AtTheStoreViewController, OptionsViewController;

@interface iOutOfAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet HomeViewController *homeScreen;
@property (nonatomic, retain) IBOutlet ShoppingListViewController *shoppingListScreen;
@property (nonatomic, retain) IBOutlet AtTheStoreViewController *atTheStoreScreen;
@property (nonatomic, retain) IBOutlet OptionsViewController *optionsScreen;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
