//
//  BBAppDelegate.m
//  Shopable
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBAppDelegate.h"

#import "BBStorageManager.h"

@interface BBAppDelegate () 

- (void)configureApperance;

@end

@implementation BBAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self configureApperance];
    
    [[BBStorageManager sharedManager] initalize];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    [[BBStorageManager sharedManager] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    [[BBStorageManager sharedManager] saveContext];
}

#pragma mark - Private Methods

- (void)configureApperance {
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"navbar-background"]
                                                      resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)]
                                       forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *textAttributes = @{UITextAttributeTextColor: [UIColor colorWithWhite:0.4 alpha:1.0],
                                                    UITextAttributeTextShadowColor: [UIColor whiteColor],
                                                    UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]};
    
    NSDictionary *highlightedTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithWhite:0.4 alpha:1.0],
                                    UITextAttributeTextShadowColor: [UIColor whiteColor],
                                    UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    
    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"navbar-button-up"]
                                                      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]
                                            forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:highlightedTextAttributes forState:UIControlStateHighlighted];
    
    [[UIToolbar appearance] setBackgroundImage:[[UIImage imageNamed:@"navbar-background"]
                                                resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)]
                            forToolbarPosition:UIToolbarPositionAny
                                    barMetrics:UIBarMetricsDefault];
}

@end
