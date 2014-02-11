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
{
    NSMutableArray *_components;
    NSMutableArray *_ranges;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _components = [[NSMutableArray alloc] init];
        _ranges = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    _attributedString = attributedString;
    
    NSString *string = [self.attributedString string];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[\\w*\\]" options:NSRegularExpressionCaseInsensitive error:&error];
    __block NSInteger start = 0;
    
    [_components removeAllObjects];
    [_ranges removeAllObjects];
    [regex enumerateMatchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, [string length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange textRange = NSMakeRange(start, result.range.location - start);
        if (!result)
        {
            textRange = NSMakeRange(start, [string length] - start);
        }
        else
        {
            [_ranges addObject:result];
        }
        start = result.range.location + result.range.length;
        [_components addObject:[string substringWithRange:textRange]];
        
    }];
}

void RunDelegateDeallocCallback( void* refCon ){
    
}

CGFloat RunDelegateGetAscentCallback( void *refCon ){
    NSString *imageName = (__bridge NSString *)refCon;
    return [UIImage imageNamed:imageName].size.height;
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
    return 0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon){
    NSString *imageName = (__bridge NSString *)refCon;
    return [UIImage imageNamed:imageName].size.width;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context || !self.attributedString)
    {
        return;
    }
    
//    CGFloat x = 10, y = 10, width = 200, height = 200;
    // 这里不翻转坐标系，绘画是正常的，但是coreText的坐标是反的
    CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(context, 1, -1);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
//    /*
//     *  1
//     */
//    {
//        // 翻转了context的坐标系以后，如果不增加这个transform，整个坐标系的顶点就变成了左下角
//        CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.bounds)), 1, -1);
//        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathAddRect(path, &transform, CGRectMake(x, y, width, height));
//        
//        // fill the path
//        CGContextSaveGState(context);
//        [[UIColor blueColor] setFill];
//        CGContextAddPath(context, path);
//        CGContextFillPath(context);
//        CGContextRestoreGState(context);
//        
//        // text color
//        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
//        CGFloat components[] = { 1, 0, 0, 1 };
//        CGColorRef color = CGColorCreate(space, components);
//        
//        CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
//        CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), (__bridge CFStringRef)[self.attributedString string]);
//        CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 13), kCTForegroundColorAttributeName, color);
//        
//        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
//        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
//        CTFrameDraw(frame, context);
//        
//        CFRelease(attrString);
//        CFRelease(framesetter);
//        CFRelease(frame);
//        CGPathRelease(path);
//        CGColorSpaceRelease(space);
//        CGColorRelease(color);
//    }
//
//    /*
//     *  2
//     */
//    {
//        // font
//        UIFont *uiFont = [UIFont systemFontOfSize:50];
//        CFStringRef fontName = CFStringCreateWithCString(kCFAllocatorDefault, [[uiFont fontName] UTF8String], kCFStringEncodingUTF8);
//        CTFontRef font = CTFontCreateWithName(fontName, uiFont.pointSize, &CGAffineTransformIdentity);
//        // color
//        UIColor *purple = [UIColor purpleColor];
//        CGFloat components[4];
//        [purple getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
//        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
//        CGColorRef color = CGColorCreate(space, components);
//        // key & value
//        CFStringRef keys[] = { kCTFontAttributeName, kCTForegroundColorAttributeName };
//        CFTypeRef values[] = { font, color };
//        // attributes
//        CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys, (const void**)&values, (sizeof(keys) / sizeof(keys[0])), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
//        CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, (__bridge CFStringRef)[self.attributedString string], attributes);
//        
//        CGFloat textX, textY, textWidth, textHeight;
//        textX = x;
//        textWidth = CGRectGetWidth(self.bounds) - (2 * x);
//        // 这个line已经可以正常的工作了
//        CTLineRef line = CTLineCreateWithAttributedString(attrString);
//        // 但是我们不想要那么长的line，所以我们把它截断
//        CTLineRef truncationLine = CTLineCreateTruncatedLine(line, textWidth, kCTLineTruncationEnd, NULL);
//        CGRect imageBounds = CTLineGetImageBounds(truncationLine, context);
//        textY = CGRectGetHeight(self.bounds) - CGRectGetHeight(imageBounds) - height - y;
//        textHeight = CGRectGetHeight(imageBounds);
//        
//        // fill background
//        CGContextSaveGState(context);
//        [[UIColor yellowColor] setFill];
//        CGContextFillRect(context, CGRectMake(textX, textY, textWidth, textHeight));
//        CGContextRestoreGState(context);
//        
//        // draw text
//        CGContextSetTextPosition(context, textX, textY);
//        CGContextSetTextDrawingMode(context, kCGTextStroke);
//        CTLineDraw(truncationLine, context);
//        
//        CFRelease(fontName);
//        CFRelease(font);
//        CFRelease(attributes);
//        CFRelease(attrString);
//        CFRelease(line);
//        CFRelease(truncationLine);
//        CGColorSpaceRelease(space);
//        CGColorRelease(color);
//    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"测试富文本显示"];
    
    //为所有文本设置字体
    //[attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, [attributedString length])]; // 6.0+
    UIFont *font = [UIFont systemFontOfSize:24];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, [attributedString length])];
    
    //将“测试”两字字体颜色设置为蓝色
    //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 2)]; //6.0+
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blueColor].CGColor range:NSMakeRange(0, 2)];
    
    //将“富文本”三个字字体颜色设置为红色
    //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)]; //6.0+
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(2, 3)];
    
    //为图片设置CTRunDelegate,delegate决定留给图片的空间大小
    NSString *taobaoImageName = @"bus.png";
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = RunDelegateDeallocCallback;
    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)(taobaoImageName));
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@" "];//空格用于给图片留位置
    [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
    CFRelease(runDelegate);
    
    [imageAttributedString addAttribute:@"imageName" value:taobaoImageName range:NSMakeRange(0, 1)];
    
    [attributedString insertAttributedString:imageAttributedString atIndex:1];
    
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    CGPathAddRect(path, NULL, bounds);
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(ctFrame, context);
    
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSString *imageName = [attributes objectForKey:@"imageName"];
            //图片渲染逻辑
            if (imageName) {
                UIImage *image = [UIImage imageNamed:imageName];
                if (image) {
                    CGRect imageDrawRect;
                    imageDrawRect.size = image.size;
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    imageDrawRect.origin.y = lineOrigin.y;
                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                }
            }
        }
    }
    
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(ctFramesetter);
}

@end

@implementation CTTViewController

- (void)loadView
{
    self.view = [[CTTView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor greenColor];
    ((CTTView *)self.view).attributedString =
//    [[NSAttributedString alloc] initWithString:@"Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine."];
    [[NSAttributedString alloc] initWithString:@"Hello, World! [bus]I know nothing in the world that has as much power as a word. [bus]Sometimes I write one, and I look at it, until it begins to shine."];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    CGRect slice, remainder;
    CGRectDivide(self.view.bounds, &slice, &remainder, 20, CGRectMinYEdge);
    self.view.frame = remainder;
}

@end
