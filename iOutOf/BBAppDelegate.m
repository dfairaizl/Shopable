//
//  BBAppDelegate.m
//  iOutOf
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

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
}

#pragma mark - Private Methods

- (void)configureApperance {
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.window.frame];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.anchorPoint = CGPointMake(0.0f, 0.0f);
    gradient.position = CGPointMake(0.0f, 0.0f);
    gradient.bounds = backgroundView.layer.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:(123/255.0f) green:(191/255.0f) blue:(254/255.0f) alpha:1.0].CGColor,
                       (id)[UIColor colorWithRed:(38/255.0f) green:(106/255.0f) blue:(207/255.0f) alpha:1.0].CGColor,
                       nil];
    [backgroundView.layer addSublayer:gradient];
    
    [self.window insertSubview:backgroundView atIndex:0];
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"navbar-background-transparent"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)] forBarMetrics:UIBarMetricsDefault];
    
}

@end
