//
//  polymorphAppDelegate.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "polymorphAppDelegate.h"
#import "polymorphViewController.h"

@implementation polymorphAppDelegate

@synthesize window = _window;
@synthesize statusBarView = _statusBarView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [_window save];
    NSLog(@"save");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    CGRect statRect = [application statusBarFrame];
    _statusBarView = [[UIView alloc] initWithFrame:statRect];
    //UIColor *col = [[UIColor alloc] initWithRed:0.53516 green:0.617188 blue:0.515625 alpha:1.0];
    UIColor *col = [[UIColor alloc] initWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];

    [_statusBarView setBackgroundColor:col];
    [_window addSubview:_statusBarView];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"will terminate");

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
