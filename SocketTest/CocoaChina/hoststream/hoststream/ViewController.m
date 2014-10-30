//
//  ViewController.m
//  hoststream
//
//  Created by 红梅 孟 on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "NSStream+MyAdditions.h"

NSMutableData *data;
NSInputStream *iStream;
NSOutputStream *oStream;
CFReadStreamRef readStream = NULL;
CFWriteStreamRef writeStream = NULL;

@interface ViewController ()

@end

@implementation ViewController
@synthesize txtMessage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self connectToServerUsingStream:@"127.0.0.1" portNo:11332];
    [self connectToServerUsingCFStream:@"127.0.0.1" portNo:11332];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void) connectToServerUsingStream:(NSString *)urlStr
                            portNo: (uint) portNo 
{
    if (![urlStr isEqualToString:@""]) {
        NSURL *website = [NSURL URLWithString:urlStr];
        if (!website) {
            NSLog(@"%@ is not a valid URL",website);
            return;
        } else {
            [NSStream getStreamsToHostNamed:urlStr
                                       port:portNo
                                inputStream:&iStream
                               outputStream:&oStream];
            [iStream retain];
            [oStream retain];
            [iStream setDelegate:self];
            [oStream setDelegate:self];
            [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
            [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
            [oStream open];
            [iStream open];
        }
    }
}

-(void) connectToServerUsingCFStream:(NSString *) urlStr portNo: (uint) portNo {
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                       (CFStringRef) urlStr,
                                       portNo,
                                       &readStream,
                                       &writeStream);
    if (readStream && writeStream) {
        CFReadStreamSetProperty(readStream,
                                kCFStreamPropertyShouldCloseNativeSocket,
                                kCFBooleanTrue);
        CFWriteStreamSetProperty(writeStream,
                                 kCFStreamPropertyShouldCloseNativeSocket,
                                 kCFBooleanTrue);
        iStream = (NSInputStream *)readStream;
        [iStream retain];
        [iStream setDelegate:self];
        [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
        [iStream open];
        oStream = (NSOutputStream *)writeStream;
        [oStream retain];
        [oStream setDelegate:self];
        [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
        [oStream open];
    }
}
-(IBAction) btnSend: (id) sender {

    if ([txtMessage.text length]==0) {
        return;
    }
    NSString *response  = [NSString stringWithFormat:@"%@",txtMessage.text];
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[oStream write:[data bytes] maxLength:[data length]];
}

- (void)dealloc {
    [txtMessage release];
    [self disconnect];
    [iStream release];
    [oStream release];
    if (readStream) CFRelease(readStream);
    if (writeStream) CFRelease(writeStream);
    [super dealloc];
}


-(void) disconnect {
    [iStream close];
    [oStream close];
}


- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    
    switch(eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"NSStreamEventOpenCompleted");
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"NSStreamEventHasSpaceAvailable");
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"NSStreamEventErrorOccurred");
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"NSStreamEventEndEncountered");
            break;
            
        case NSStreamEventHasBytesAvailable:
            NSLog(@"NSStreamEventHasBytesAvailable");
        {
            if (data == nil) {
                data = [[NSMutableData alloc] init];
            }
            uint8_t buf[1024];
            unsigned int len = 0;
            len = [(NSInputStream *)stream read:buf maxLength:1024];
            if(len) {
                [data appendBytes:(const void *)buf length:len];
                int bytesRead = 0;
                bytesRead += len;
            } else {
                NSLog(@"No data.");
            }
            NSString *str = [[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"From server"
//                                                            message:str
//                                                           delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            [alert release];
            [str release];
            [data release];
            data = nil;
        } break;
    }
}
@end
