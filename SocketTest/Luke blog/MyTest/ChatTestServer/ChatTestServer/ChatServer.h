//
//  ChatServer.h
//  ChatTestServer
//
//  Created by stone win on 11/29/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatServer : NSObject <NSStreamDelegate>

@property (nonatomic, assign) in_port_t port;
@property (nonatomic, strong) NSMutableDictionary *clients;

- (BOOL)run:(NSError **)error;

@end
