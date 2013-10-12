//
//  TTAppDelegate.m
//  TransitionTest
//
//  Created by 文 斯敦 on 12-8-24.
//  Copyright (c) 2012年 cutt. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "TTAppDelegate.h"

#define TOOLBAR_HEIGHT 40

@interface TTAppDelegate ()

{
    UIView *_container;
    UIImageView *_imageView1;
    UIImageView *_imageView2;
    
    BOOL isAnimating;
}

@end
@implementation TTAppDelegate

- (void)dealloc
{
    [_window release];
    [_container release];
    [_imageView1 release];
    [_imageView2 release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *rootController = [[UIViewController alloc] initWithNibName:nil
                                                                          bundle:nil];
    [rootController.view setBackgroundColor:[UIColor clearColor]];
    [_window setRootViewController:rootController];
    
    
    
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460 - TOOLBAR_HEIGHT)];
    [container setBackgroundColor:[UIColor clearColor]];
    [rootController.view addSubview:container];
    _container = [container retain];
    [container release];
    
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460 - TOOLBAR_HEIGHT)];
    [imageView1 setImage:[UIImage imageNamed:@"image1.jpg"]];
    [_container addSubview:imageView1];
    _imageView1 = [imageView1 retain];
    [imageView1 release];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:_imageView1.frame];
    [imageView2 setImage:[UIImage imageNamed:@"image2.jpg"]];
    [imageView2 setHidden:YES];
    [_container addSubview:imageView2];
    _imageView2 = [imageView2 retain];
    [imageView2 release];
    
    
    
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 460 - TOOLBAR_HEIGHT, 320, TOOLBAR_HEIGHT)];
    
    UIBarButtonItem *barSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:NULL];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"\t\tPlay\t\t"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(barButtonTapped:)];
    UIBarButtonItem *barSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:NULL];
    [toolBar setItems:[NSArray arrayWithObjects:barSpace1, barButton, barSpace2, nil]];
    [barSpace1 release];
    [barButton release];
    [barSpace2 release];
    
    [rootController.view addSubview:toolBar];
    [toolBar release];
    
    
    
    
    [rootController release];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)performTransition
{
    [_imageView1 setHidden:YES];
    [_imageView2 setHidden:NO];
    
    isAnimating = YES;
    
    NSString *funcNames[5] = {
        kCAMediaTimingFunctionDefault,
        kCAMediaTimingFunctionEaseIn,
        kCAMediaTimingFunctionEaseInEaseOut,
        kCAMediaTimingFunctionEaseOut,
        kCAMediaTimingFunctionLinear
    };
    int funcRnd = arc4random() % 5;
    NSLog(@"function: %@", funcNames[funcRnd]);
    
    CATransition *transition = [CATransition animation];
    [transition setDuration:1];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:funcNames[funcRnd]]];
    [transition setType:kCATransitionReveal];
    [transition setSubtype:kCATransitionFromRight];
    [transition setDelegate:self];
    [_container.layer addAnimation:transition forKey:nil];
    
    UIImageView *tImageView = _imageView1;
    _imageView1 = _imageView2;
    _imageView2 = tImageView;
    
}
- (void)barButtonTapped:(UIBarButtonItem *)sender
{
    if (!isAnimating) [self performTransition];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) isAnimating = NO;
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
