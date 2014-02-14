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

@property (nonatomic, strong) NSMutableArray *images;

- (void)setCTFrame:(CTFrameRef)f;

@end
