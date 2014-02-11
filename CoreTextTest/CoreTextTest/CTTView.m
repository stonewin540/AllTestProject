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
    
    CGFloat x = 10, y = 10, width = 200, height = 200;
    // 这里不翻转坐标系，绘画是正常的，但是coreText的坐标是反的
    CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(context, 1, -1);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    /*
     *  1
     */
    {
        // 翻转了context的坐标系以后，如果不增加这个transform，整个坐标系的顶点就变成了左下角
        CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.bounds)), 1, -1);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, &transform, CGRectMake(x, y, width, height));
        
        // fill the path
        CGContextSaveGState(context);
        [[UIColor blueColor] setFill];
        CGContextAddPath(context, path);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
        
        // text color
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGFloat components[] = { 1, 0, 0, 1 };
        CGColorRef color = CGColorCreate(space, components);
        
        CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
        CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), (__bridge CFStringRef)[self.attributedString string]);
        CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 13), kCTForegroundColorAttributeName, color);
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CTFrameDraw(frame, context);
        
        CFRelease(attrString);
        CFRelease(framesetter);
        CFRelease(frame);
        CGPathRelease(path);
        CGColorSpaceRelease(space);
        CGColorRelease(color);
    }

    /*
     *  2
     */
    {
        // font
        UIFont *uiFont = [UIFont systemFontOfSize:50];
        CFStringRef fontName = CFStringCreateWithCString(kCFAllocatorDefault, [[uiFont fontName] UTF8String], kCFStringEncodingUTF8);
        CTFontRef font = CTFontCreateWithName(fontName, uiFont.pointSize, &CGAffineTransformIdentity);
        // color
        UIColor *purple = [UIColor purpleColor];
        CGFloat components[4];
        [purple getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(space, components);
        // key & value
        CFStringRef keys[] = { kCTFontAttributeName, kCTForegroundColorAttributeName };
        CFTypeRef values[] = { font, color };
        // attributes
        CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys, (const void**)&values, (sizeof(keys) / sizeof(keys[0])), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, (__bridge CFStringRef)[self.attributedString string], attributes);
        
        CGFloat textX, textY, textWidth, textHeight;
        textX = x;
        textWidth = CGRectGetWidth(self.bounds) - (2 * x);
        // 这个line已经可以正常的工作了
        CTLineRef line = CTLineCreateWithAttributedString(attrString);
        // 但是我们不想要那么长的line，所以我们把它截断
        CTLineRef truncationLine = CTLineCreateTruncatedLine(line, textWidth, kCTLineTruncationEnd, NULL);
        CGRect imageBounds = CTLineGetImageBounds(truncationLine, context);
        textY = CGRectGetHeight(self.bounds) - CGRectGetHeight(imageBounds) - height - y;
        textHeight = CGRectGetHeight(imageBounds);
        
        // fill background
        CGContextSaveGState(context);
        [[UIColor yellowColor] setFill];
        CGContextFillRect(context, CGRectMake(textX, textY, textWidth, textHeight));
        CGContextRestoreGState(context);
        
        // draw text
        CGContextSetTextPosition(context, textX, textY);
        CGContextSetTextDrawingMode(context, kCGTextStroke);
        CTLineDraw(truncationLine, context);
        
        CFRelease(fontName);
        CFRelease(font);
        CFRelease(attributes);
        CFRelease(attrString);
        CFRelease(line);
        CFRelease(truncationLine);
        CGColorSpaceRelease(space);
        CGColorRelease(color);
    }
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
