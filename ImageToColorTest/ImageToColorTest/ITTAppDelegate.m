//
//  ITTAppDelegate.m
//  ImageToColorTest
//
//  Created by stone win on 5/18/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "ITTAppDelegate.h"

@implementation ITTAppDelegate

#pragma mark - Helpers

- (void)fetchColorFromImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"fay" ofType:@"jpg"];
        NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
        UIImage *image = [UIImage imageWithData:data];
        
        if (!error && image)
        {
            CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
            if (data)
            {
                const UInt8 *dataPtr = CFDataGetBytePtr(data);
                
                int width = roundf(image.size.width);
                int height = roundf(image.size.height);
                CGPoint point;
                
                float red = 0, green = 0, blue = 0, alpha = 0;
                
                for (int i = 0; i < height; i++)
                {
                    for (int j = 0; j < width; j++)
                    {
                        point = CGPointMake(j, i);
                        int index = ((point.y*width)+point.x) * 4;
                        
                        red += dataPtr[index];
                        green += dataPtr[index + 1];
                        blue += dataPtr[index + 2];
                        alpha += dataPtr[index + 3];
                    }
                }
                
                unsigned int matrix = width * height;
                red /= matrix;
                green /= matrix;
                blue /= matrix;
                alpha /= matrix;
                
                CFRelease(data);
                
                UIColor *color = [UIColor colorWithRed:red / 255.f green:green / 255.f blue:blue / 255.f alpha:alpha / 255.f];
                NSLog(@"the color: %@", color);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.window.backgroundColor = color;
                    
                });
            }
        }
        
    });
}

#pragma mark - Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self fetchColorFromImage];
    
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
