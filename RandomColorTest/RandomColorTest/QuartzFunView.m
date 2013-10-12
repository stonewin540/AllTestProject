//
//  QuartzFunView.m
//  RandomColorTest
//
//  Created by 文 斯敦 on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QuartzFunView.h"
#import "UIColor+Random.h"

@implementation QuartzFunView

@synthesize firstTouch;
@synthesize lastTouch;
@synthesize shapeType;
@synthesize useRandomColor;
@synthesize currentColor = _currentColor;
@synthesize drawImage = _drawImage;

- (void)dealloc
{
    [_currentColor release];
    [_drawImage release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentColor = [UIColor greenColor];
        self.useRandomColor = NO;
        if (nil == self.drawImage)
        {
            self.drawImage = [UIImage imageNamed:@"iphone.jpeg"];
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (useRandomColor)
    {
        self.currentColor = [UIColor randomColor];
    }
    UITouch *touch = [touches anyObject];
    firstTouch = [touch locationInView:self];
    lastTouch = [touch locationInView:self];
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    lastTouch = [touch locationInView:self];
    [self setNeedsDisplay];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    lastTouch = [touch locationInView:self];
}

@end
