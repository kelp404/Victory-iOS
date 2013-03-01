//
//  TakanashiDemoAppDelegate.m
//  Takanashi-iOS
//
//  Created by Kelp on 2013/03/01.
//
//

#import "TakanashiDemoAppDelegate.h"
#import "TakanashiDemoViewController.h"
#import <KSCrash/KSCrash.h>
#import <KSCrash/KSCrashAdvanced.h>
#import <KSCrash/KSCrashReportSinkStandard.h>


#pragma mark - KSCrash static
static BOOL g_crashInHandler = NO;
static void onCrash(const KSCrashReportWriter* writer)
{
    if (g_crashInHandler)
    {
        printf(NULL);
    }
}


#pragma mark - App delegate
@implementation TakanashiDemoAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

#pragma mark - Launch
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // crash handler
    [self installCrashHandler];
    [self uploadCrashLog];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    _viewController = [[TakanashiDemoViewController alloc] initWithNibName:[TakanashiDemoViewController xibName] bundle:nil];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:_viewController];
    _window.rootViewController = navigation;
    [_window makeKeyAndVisible];
    return YES;
}


#pragma mark Crash Handler
- (BOOL)crashInHandler
{
    return g_crashInHandler;
}
- (void)setCrashInHandler:(BOOL)crashInHandler
{
    g_crashInHandler = crashInHandler;
}
/**
 Upload crash reports.
 */
- (void)uploadCrashLog
{
    KSCrash *crash = [KSCrash instance];
    if (crash.reportCount > 0) {
        // upload crash
        crash.deleteAfterSend = YES;
        crash.sink = [KSCrashReportSinkStandard sinkWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/crash/%@", TAKANASHI_URL, TAKANASHI_APP_KEY]] onSuccess:nil];
        [crash sendAllReportsWithCompletion:nil];
    }
}
/**
 Install crash handler.
 */
- (void)installCrashHandler
{
    // install crash handler
    [KSCrash installWithCrashReportSink:nil
                               userInfo:@{ @"name": UIDevice.currentDevice.name }
                        zombieCacheSize:16384
               deadlockWatchdogInterval:5.0f
                     printTraceToStdout:YES
                                onCrash:onCrash];
}


#pragma mark - Cocoa application life cycle
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
