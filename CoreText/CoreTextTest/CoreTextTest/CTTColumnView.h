//
//  CTTColumnView.h
//  CoreTextTest
//
//  Created by stone win on 2/13/14.
//  Copyright (c) 2014 stone win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface CTTColumnView : UIView
{
    CTFrameRef _ctFrame;
}

- (void)setCTFrame:(CTFrameRef)f;

@end
