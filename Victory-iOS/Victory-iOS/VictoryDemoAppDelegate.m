//
//  VictoryDemoAppDelegate.m
//  Victory-iOS
//
//  Created by Kelp on 2013/06/12.
//  Copyright (c) 2013年 Kelp. All rights reserved.
//

#import "VictoryDemoAppDelegate.h"
#import "VictoryDemoViewController.h"
#import "Victory.h"
#import <KSCrash/KSCrash.h>
#import <KSCrash/KSCrashAdvanced.h>
#import <KSCrash/KSCrashInstallationVictory.h>



@implementation VictoryDemoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // crash handler
    [self installCrashHandler];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    _viewController = [[VictoryDemoViewController alloc] initWithNibName:[VictoryDemoViewController xibName] bundle:nil];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:_viewController];
    _window.rootViewController = navigation;
    [_window makeKeyAndVisible];
    return YES;
}

/**
 Install crash handler.
 */
- (void)installCrashHandler
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/crash/%@", VICTORY_URL, VICTORY_APP_KEY]];
    
    KSCrashInstallationVictory* installation = [KSCrashInstallationVictory sharedInstance];
    installation.url = url;
    installation.userName = @"user name";
    installation.userEmail = @"userEmail@gmail.com";
    
    // Install the crash handler. This should be done as early as possible.
    // This will record any crashes that occur, but it doesn't automatically send them.
    [installation install];
    
    
    // Send all outstanding reports. You can do this any time; it doesn't need
    // to happen right as the app launches. Advanced-Example shows how to defer
    // displaying the main view controller until crash reporting completes.
    [installation sendAllReportsWithCompletion:^(NSArray *filteredReports, BOOL completed, NSError *error) {
        if (completed) {
            NSLog(@"Sent %d reports", [filteredReports count]);
        }
        else {
            NSLog(@"Failed to send reports: %@", error);
        }
    }];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
