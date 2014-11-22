//
//  Client.h
//  ChatTestServer
//
//  Created by stone win on 12/2/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Client : NSObject

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, assign) CFSocketNativeHandle sock_fd;

@end
