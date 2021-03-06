//
//  SJAppDelegate.m
//  SJRolePlaying
//
//  Created by Tatsuya Tobioka on 2013/10/16.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJAppDelegate.h"

#import "SJComponents.h"
#import "SJViewController.h"

@implementation SJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self registerDefaults];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    SJViewController *sjViewController = SJViewController.new;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:sjViewController];
    _window.rootViewController = navController;
    [self.window makeKeyAndVisible];
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

- (void)registerDefaults {
    NSMutableDictionary *defaults = @{}.mutableCopy;
    
    NSString *lang = [[NSLocale preferredLanguages][0] isEqualToString:@"ja"] ? @"ja" : @"en";
    //NSString *lang = @"ja";
    defaults[kLangKey] = lang;
    defaults[kSoundKey] = @NO;

    defaults[@"username"] = @"主人公";

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

@end

