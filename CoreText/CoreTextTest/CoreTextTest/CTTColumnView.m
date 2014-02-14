//
//  CTTColumnView.m
//  CoreTextTest
//
//  Created by stone win on 2/13/14.
//  Copyright (c) 2014 stone win. All rights reserved.
//

#import "CTTColumnView.h"

@implementation CTTColumnView

#pragma mark - Public

- (void)setCTFrame:(CTFrameRef)f
{
    _ctFrame = f;
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.images = [[NSMutableArray alloc] init];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context)
    {
        return;
    }
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(context, 1, -1);
    
    CTFrameDraw(_ctFrame, context);
    
    // render images
    for (NSArray *imageData in self.images)
    {
        UIImage *img = imageData[0];
        CGRect imgBounds = CGRectFromString(imageData[1]);
        CGContextDrawImage(context, imgBounds, img.CGImage);
    }
}

@end
