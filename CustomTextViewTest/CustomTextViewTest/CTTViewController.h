//
//  CTTViewController.h
//  CustomTextViewTest
//
//  Created by stone win on 3/1/14.
//  Copyright (c) 2014 stone win. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CTTInputTypeNormal,
    CTTInputTypeCustom,
} CTTInputType;

@interface CTTViewController : UIViewController

@end

@interface NSString (Emoticon)

- (NSString *)stringByReplacingEmoticon;
- (NSString *)stringByInsertingString:(NSString *)insertion withRange:(NSRange)range;

@end
