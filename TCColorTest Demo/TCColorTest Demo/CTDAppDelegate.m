//
//  CTDAppDelegate.m
//  TCColorTest Demo
//
//  Created by Tobias Conradi on 09.01.13.
//  Copyright (c) 2013 contibo UG (haftungsbeschränkt). All rights reserved.
//

#import "CTDAppDelegate.h"
#import "TCColorTest.h"
#import "TCColorTestBehaviours.h"
@implementation CTDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UIColor *demoColor = [UIColor colorWithRed:0.5
                                         green:0.0
                                          blue:0.0
                                         alpha:1.0];
    [[UINavigationBar appearance] setTintColor:demoColor];
    [[UISegmentedControl appearance] setTintColor:demoColor];
    [[UISlider appearance] setMinimumTrackTintColor:demoColor];
    [[UISlider appearance] setThumbTintColor:demoColor];
    [[UIProgressView appearance] setProgressTintColor:demoColor];
    [[UITabBar appearance] setTintColor:demoColor];
    
    [self.window makeKeyAndVisible];

    [TCColorTest colorTestInKeyWindow];
    [TCColorTestBehaviours addDefaultBehaviours];

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
