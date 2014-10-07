//
//  AppDelegate.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/1/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "AppDelegate.h"
#import "Flurry.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    NSDictionary *titleAttributes = [[UINavigationBar appearance] titleTextAttributes];
//    UIFont *regularFont = [UIFont fontWithName:@"LucidaGrande" size:22.0];
//    [titleAttributes setValue:regularFont forKey:NSFontAttributeName];
//    [[UINavigationBar appearance] setTitleTextAttributes:titleAttributes];

//    UIPageControl *pageControl = [UIPageControl appearance];
//    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
//    pageControl.backgroundColor = [UIColor whiteColor];
    
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
    [Flurry setCrashReportingEnabled:YES];
    // Replace YOUR_API_KEY with the api key in the downloaded package
    [Flurry startSession:@"7C7DMG6KC5TX3NT5KZRK"];

    [Flurry logEvent:@"Application_Started"];
    
    UIDevice *myDevice = [UIDevice currentDevice];
    NSDictionary *deviceDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                myDevice.name, @"DEVICE_NAME",
                                myDevice.model, @"DEVICE_MODEL",
                                myDevice.systemName, @"DEVICE_SYSTEM_NAME",
                                myDevice.systemVersion, @"DEVICE_OS_VERSION",
                               nil];
    
    [Flurry logEvent:@"Application_Started_On_Device" withParameters:deviceDict];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [Flurry logEvent:@"Application_Entered_Background"];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Flurry logEvent:@"Application_Entered_Foreground"];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [Flurry logEvent:@"Application_Entered_Terminated"];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
