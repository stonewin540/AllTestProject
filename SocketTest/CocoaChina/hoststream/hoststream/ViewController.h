//
//  ViewController.h
//  hoststream
//
//  Created by 红梅 孟 on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSStreamDelegate>
{
    IBOutlet UITextField *txtMessage;
//    NSOutputStream *oStream;
//    NSInputStream *iStream;
//    NSMutableData *data;
}
@property (nonatomic, retain) IBOutlet UITextField *txtMessage;
//@property (nonatomic, retain) NSOutputStream *oStream;
//@property (nonatomic, retain) NSInputStream *iStream;
//@property (nonatomic, retain) NSMutableData *data;
-(IBAction) btnSend: (id) sender;

@end
