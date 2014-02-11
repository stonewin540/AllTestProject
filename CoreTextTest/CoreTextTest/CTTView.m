//
//  CTTView.m
//  CoreTextTest
//
//  Created by stone win on 2/10/14.
//  Copyright (c) 2014 stone win. All rights reserved.
//

#import "CTTView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@implementation CTTView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context || !self.attributedString)
    {
        return;
    }
    
    // 这里不翻转坐标系，绘画是正常的，但是coreText的坐标是反的
    CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(context, 1, -1);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), (__bridge CFStringRef)[self.attributedString string]);
    
    // 翻转了context的坐标系以后，如果不增加这个transform，整个坐标系的顶点就变成了左下角
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.bounds)), 1, -1);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, &transform, CGRectMake(10, 10, 200, 200));
    
    CGContextSaveGState(context);
    [[UIColor blueColor] setFill];
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(frame, context);
    
    CFRelease(attrString);
    CFRelease(framesetter);
    CFRelease(frame);
    CGPathRelease(path);
}

@end

@implementation CTTViewController

- (void)loadView
{
    self.view = [[CTTView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor greenColor];
    ((CTTView *)self.view).attributedString =
    [[NSAttributedString alloc] initWithString:@"Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine."];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    CGRect slice, remainder;
    CGRectDivide(self.view.bounds, &slice, &remainder, 20, CGRectMinYEdge);
    self.view.frame = remainder;
}

@end
