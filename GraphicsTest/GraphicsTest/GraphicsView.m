//
//  GraphicsView.m
//  GraphicsTest
//
//  Created by 文 斯敦 on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GraphicsView.h"

@implementation GraphicsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    /*
    // first step:
    // get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
//    */
    
//    /*
    // Draw a red solid square
    CGContextSetRGBFillColor(ctx, 255.f, 0.f, 0.f, 1.f);
    CGContextFillRect(ctx, CGRectMake(10.f, 10.f, 50.f, 50.f));
//     */
    
//    /*
    // Draw a blue solid circle
    CGContextSetRGBFillColor(ctx, 0.f, 255.f, 0.f, 1.f);
    CGContextFillEllipseInRect(ctx, CGRectMake(100.f, 100.f, 25.f, 25.f));
//    */
    
//    /*
    // Draw a blue hollow circle
    CGContextSetRGBStrokeColor(ctx, 0.f, 0.f, 255.f, 1.f);
    CGContextStrokeEllipseInRect(ctx, CGRectMake(200.f, 200.f, 50.f, 50.f));
//    */
    
//    /*
    // Draw a yellow hollow rectangle
    CGContextSetRGBStrokeColor(ctx, 255.f, 255.f, 0.f, 1.f);
    CGContextStrokeRect(ctx, CGRectMake(195.f, 195.f, 60.f, 60.f));
//    */
    
//    /*
    // Draw a purple triangle with using lines
    CGContextSetRGBStrokeColor(ctx, 255.f, 0.f, 255.f, 1.f);
    CGPoint points[6] = {CGPointMake(100.f, 200.f), CGPointMake(150.f, 250.f), 
                         CGPointMake(150.f, 250.f), CGPointMake(50.f, 250.f), 
                         CGPointMake(50.f, 250.f), CGPointMake(100.f, 200.f)};
    CGContextStrokeLineSegments(ctx, points, 6);
//    */
    
//    /*
    // Draw the text TrailsintheSand.com in light blue
    char *text = "TrailsintheSand.com";
    
    CGContextSelectFont(ctx, "Helvetica", 24.f, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetRGBFillColor(ctx, 0.f, 255.f, 255.f, 1.f);
    
    CGAffineTransform xform = CGAffineTransformMake(1.f, 0.f, 0.f, -1.f, 0.f, 0.f);
    CGContextSetTextMatrix(ctx, xform);
    
    CGContextShowTextAtPoint(ctx, 10.f, 300.f, text, strlen(text));
//    */
    
//    /*
    // Draw a transparent filled circle over other objects
    CGContextSetRGBFillColor(ctx, 200.f, 200.f, 200.f, 0.8f);
    CGContextFillEllipseInRect(ctx, CGRectMake(100.f, 200.f, 150.f, 150.f));
//    */
    
    // Load image from application bundle
    NSString *imageFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Xcode-Icon.png"];
    CGDataProviderRef provider = CGDataProviderCreateWithFilename([imageFileName UTF8String]);
    CGImageRef image = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    
    // Draw image
    CGContextDrawImage(ctx, CGRectMake(200.f, 15.f, 100.f, 100.f), image);
    CGImageRelease(image);
}


@end
