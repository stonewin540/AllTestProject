//
//  main.m
//  ChatTestServer
//
//  Created by stone win on 11/29/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatServer.h"
#import "Client.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        NSError *error = nil;
        ChatServer *chatServer = [[ChatServer alloc] init];
        [chatServer run:&error];        
    }
    return 0;
}

