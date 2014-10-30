//
//  ChatServer.m
//  ChatTestServer
//
//  Created by stone win on 11/29/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "ChatServer.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import "Client.h"

#define CHAT_SERVER_PORT    11332

@implementation ChatServer
{
    
}

#pragma mark - CallBack

static void SocketConnectionAcceptedCallback(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    if (kCFSocketAcceptCallBack == type)
    {
        ChatServer *theChatServer = (__bridge ChatServer *)info;
        CFSocketNativeHandle nativeSocketHandle = *((CFSocketNativeHandle *)data);
        
        CFReadStreamRef readStream = NULL;
        CFWriteStreamRef writeStream = NULL;
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocketHandle, &readStream, &writeStream);
        if (readStream && writeStream)
        {
            CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            NSInputStream *inputStream = (__bridge NSInputStream *)readStream;
            NSOutputStream *outputStream = (__bridge NSOutputStream *)writeStream;
            inputStream.delegate = theChatServer;
            [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [inputStream open];
            outputStream.delegate = theChatServer;
            [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [outputStream open];
            
            Client *aClient = [[Client alloc] init];
            aClient.inputStream = inputStream;
            aClient.outputStream = outputStream;
            aClient.sock_fd = nativeSocketHandle;
            
            [theChatServer.clients setValue:aClient forKey:[NSString stringWithFormat:@"%@",inputStream]];
            NSLog(@"有新客户端(sock_fd=%d)加入",nativeSocketHandle);
        }
        else
        {
            close(nativeSocketHandle);
        }
        
        if (readStream)
        {
            CFRelease(readStream);
        }
        if (writeStream)
        {
            CFRelease(writeStream);
        }
    }
}

static void FileDescriptorCallback(CFFileDescriptorRef f, CFOptionFlags callbackTypes, void *info)
{
    int fd = CFFileDescriptorGetNativeDescriptor(f);
    ChatServer *theChatServer = (__bridge ChatServer *)info;
    if (STDIN_FILENO == fd)
    {
        NSData *inputData = [[NSFileHandle fileHandleWithStandardInput] availableData];
        NSString *inputString = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
        NSLog(@"准备发送消息：%@", inputString);
        for (Client *theClient in [theChatServer.clients allValues])
        {
            [theClient.outputStream write:[inputData bytes] maxLength:[inputData length]];
        }
        
        CFFileDescriptorEnableCallBacks(f, kCFFileDescriptorReadCallBack);
    }
}

#pragma mark - Public

- (BOOL)run:(NSError **)error
{
    BOOL successful = YES;
    CFSocketContext socketContext = {
        0, (__bridge void *)(self), NULL, NULL, NULL
    };
    
    /*
     * <sys/socket.h> contains
     * PF_INET, SOCK_STREAM
     * <netinet/in.h> contains
     * IPPROTO_TCP
     */
    
    /*
     *  Create Socket
     */
    CFSocketRef socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, SocketConnectionAcceptedCallback, &socketContext);
    if (NULL == socket)
    {
        if (!error)
        {
            *error = [[NSError alloc] initWithDomain:@"com.cutt.stone.ChatTestServer" code:1001 userInfo:nil];
        }
        successful = NO;
    }
    
    if (successful)
    {
        /* set native socket options */
        int yes = 1;
        setsockopt(CFSocketGetNative(socket), SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes));
        uint8_t packetSize = 128;
        setsockopt(CFSocketGetNative(socket), SOL_SOCKET, SO_SNDBUF, &packetSize, sizeof(packetSize));
        
        /*
         *  binds address to socket for listening
         */
        
        /* set port & address */
        struct sockaddr_in addr4;
        memset(&addr4, 0, sizeof(addr4));
        addr4.sin_len = sizeof(addr4);
        addr4.sin_family = AF_INET;
        addr4.sin_port = htons(CHAT_SERVER_PORT);
        addr4.sin_addr.s_addr = htonl(INADDR_ANY);
        
        /* binding */
        CFDataRef address4 = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));
        CFSocketError socketError = CFSocketSetAddress(socket, address4);
        if (address4)
        {
            CFRelease(address4);
        }
        
        if (kCFSocketSuccess != socketError)
        {
            if (!error)
            {
                *error = [[NSError alloc] initWithDomain:@"com.cutt.stone.ChatTestServer" code:1002 userInfo:nil];
            }
            if (socket)
            {
                CFRelease(socket);
            }
            socket = NULL;
            successful = NO;
        }
        else
        {
            /*
             *  never used self.port?
             *  don't understand…
             */
            CFDataRef addr = CFSocketCopyAddress(socket);
            memcpy(&addr4, CFDataGetBytePtr(addr), CFDataGetLength(addr));
            if (addr)
            {
                CFRelease(addr);
            }
            self.port = NTOHS(addr4.sin_port);
            
            /*
             *  Run Loop
             */
            CFRunLoopRef cfrl = CFRunLoopGetCurrent();
            
            /* listening on socket */
            CFRunLoopSourceRef source4 = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0);
            CFRunLoopAddSource(cfrl, source4, kCFRunLoopDefaultMode);
            if (source4)
            {
                CFRelease(source4);
            }
            
            /* listening on standard IO */
            CFFileDescriptorContext context = {
                0, ((__bridge void *)self), NULL, NULL, NULL
            };
            // create file descriptor for stdin
            CFFileDescriptorRef stdinFDRef = CFFileDescriptorCreate(kCFAllocatorDefault, STDIN_FILENO, true, FileDescriptorCallback, &context);
            CFFileDescriptorEnableCallBacks(stdinFDRef, kCFFileDescriptorReadCallBack);
            // create run loop source with stdinFDRef for adding source
            CFRunLoopSourceRef stdinSource = CFFileDescriptorCreateRunLoopSource(kCFAllocatorDefault, stdinFDRef, 0);
            CFRunLoopAddSource(cfrl, stdinSource, kCFRunLoopDefaultMode);
            // relinquish
            if (stdinSource)
            {
                CFRelease(stdinSource);
            }
            if (stdinFDRef)
            {
                CFRelease(stdinFDRef);
            }
            
            // run loop fire
            CFRunLoopRun();
        }
    }
    
    return successful;
}

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self)
    {
        self.clients = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Stream Delegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode)
    {
        case NSStreamEventHasBytesAvailable:
        {
            Client *aClient = [self.clients objectForKey:[NSString stringWithFormat:@"%@",aStream]];
            NSMutableData *data = [NSMutableData data];
            uint8_t *buf = calloc(128, sizeof(uint8_t));
            NSUInteger len = 0;
            while ([((NSInputStream *)aStream) hasBytesAvailable])
            {
                len = [((NSInputStream *)aStream) read:buf maxLength:128];
                if (len > 0)
                {
                    [data appendBytes:buf length:len];
                }
            }
            free(buf);
            
            if (0 == [data length])
            {
                NSLog(@"客户端（sock_fd＝%d）退出", aClient.sock_fd);
                [self.clients removeObjectForKey:[NSString stringWithFormat:@"%@", aStream]];
                close(aClient.sock_fd);
            }
            else
            {
                NSLog(@"收到客户端(sock_fd=%d)消息:%@", aClient.sock_fd, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            }
            
            break;
        }
        default:
            break;
    }
}

@end
