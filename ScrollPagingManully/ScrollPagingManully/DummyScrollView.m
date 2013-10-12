//
//  DummyScrollView.m
//  ScrollPagingManully
//
//  Created by stone on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DummyScrollView.h"
#import "TrueScrollViewController.h"

@implementation DummyScrollView

@synthesize dummyScrollView = _dummyScrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [_dummyScrollView release];
    [super dealloc];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (([self pointInside:point withEvent:event]) && (self.subviews.count >= 1))
    {
        UIScrollView *scroll = [self.subviews objectAtIndex:0];
        NSLog(@"%f....%f", scroll.contentSize.width, scroll.contentOffset.x);
        // An extended-hit view should only have one sub-view, or make sure the
        // first subview is the one you want to expand the hit test for.
        return [self.subviews objectAtIndex:0];
    }
    
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
