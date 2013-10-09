//
//  FTAppDelegate.m
//  FileTest
//
//  Created by stone win on 8/29/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "FTAppDelegate.h"

@implementation FTAppDelegate

+ (BOOL)storeCallStack
{
    // chech if file exist
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *url = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"fileTest.txt"];
    if (![fm fileExistsAtPath:[url path]])
    {
        BOOL succeed = [fm createFileAtPath:[url path] contents:nil attributes:nil];
        if (!succeed)
        {
            return NO;
        }
    }
    
    // open file & move to end of file
    NSError *error = nil;
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingURL:url error:&error];
    if (!fileHandle || error)
    {
        return NO;
    }
    [fileHandle seekToEndOfFile];
    
    // prepare data to store
    NSMutableString *callStack = [NSMutableString stringWithFormat:@"start @ %@ -----------------------\n", [NSDate date]];
    [[NSThread callStackSymbols] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [callStack appendString:obj];
        [callStack appendString:@"\n"];
    }];
    [callStack appendFormat:@"end @ %@ -----------------------\n\n\n\n", [NSDate date]];
    // convert string to data
    NSData *data = [callStack dataUsingEncoding:NSUTF8StringEncoding];
    if (![data length])
    {
        return NO;
    }
    // store & close file
    [fileHandle writeData:data];
    [fileHandle closeFile];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    int stone = 540216;
    int fiona = 880720;
    int new = stone & fiona;
    new = stone | fiona;
    new = stone ^ fiona;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSLock *lock = [[NSLock alloc] init];
    for (int i=0; i<10; i++)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
//            BOOL succeed = [FTAppDelegate storeCallStack];
//            if (succeed)
//            {
//                sleep(2);
//            }
//            else
//            {
//                [NSException raise:@"StoreCallStack Exception" format:@"Unknow Reason"];
//            }
            
            
//            [lock lock];
            dispatch_sync(dispatch_get_current_queue(), ^{
            
            NSLog(@"%@", [NSThread currentThread]);
            sleep(2);
            NSLog(@"%@", [NSThread currentThread]);
//            [lock unlock];
            });
            
        });
    }
    
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
