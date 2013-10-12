//
//  AppDelegate.m
//  ScrollPagingManully
//
//  Created by stone on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "TrueScrollViewController.h"

@interface AppDelegate()

@property (retain, nonatomic) TrueScrollViewController *viewCnotroller;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewCnotroller = _viewCnotroller;

- (void)dealloc
{
    [_window release];
    [_viewCnotroller release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.viewCnotroller = [[[TrueScrollViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    [self.window addSubview:self.viewCnotroller.view];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
