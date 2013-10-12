//
//  AppDelegate.m
//  ForDifferentIOSVersion
//
//  Created by 文 斯敦 on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_4_0 
//#define kCFCoreFoundationVersionNumber_iPhoneOS_4_0 550.32 
//#endif 

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
#define IF_IOS4_OR_SMALLER(...) \
    if (!kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_4_2) \
    { \
        __VA_ARGS__ \
    }
#else
#define IF_IOS4_OR_SMALLER(...)
#endif

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UILabel *testLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 300, 200)] autorelease];
    [testLabel setBackgroundColor:[UIColor blackColor]];
    [testLabel setTextAlignment:UITextAlignmentCenter];
    [testLabel setFont:[UIFont boldSystemFontOfSize:50]];

//    NSUInteger sysVer = [[[UIDevice currentDevice] systemVersion] intValue];
//    if (sysVer >= 5)
//    {
//        [testLabel setTextColor:[UIColor redColor]];
//        [testLabel setText:@">= 5"];
//    }
//    else
//    {
//        [testLabel setTextColor:[UIColor greenColor]];
//        [testLabel setText:@"< 5"];
//    }
    
    IF_IOS4_OR_SMALLER([testLabel setTextColor:[UIColor greenColor]];
                       [testLabel setText:@"< 5"];);
    NSLog(@"\n%d", __IPHONE_OS_VERSION_MIN_REQUIRED);
    
    [self.window addSubview:testLabel];
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

@end
