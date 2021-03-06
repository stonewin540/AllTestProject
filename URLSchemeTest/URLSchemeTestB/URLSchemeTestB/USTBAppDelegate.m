//
//  USTBAppDelegate.m
//  URLSchemeTestB
//
//  Created by stone win on 5/20/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "USTBAppDelegate.h"

@interface USTBAppDelegate ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation USTBAppDelegate

#pragma mark - Actions

- (void)buttonTapped:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"AppA:"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - System

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    self.window.rootViewController = navigationController;
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 80)];
    _label.backgroundColor = self.window.backgroundColor;
    _label.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    _label.textAlignment = UITextAlignmentCenter;
    _label.textColor = [UIColor blackColor];
    _label.font = [UIFont systemFontOfSize:30];
    
    [self.window addSubview:_label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 200, 300, 80);
    button.titleLabel.font = [UIFont systemFontOfSize:30];
    [button setTitle:@"OK return to App A" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.window addSubview:button];
    
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
