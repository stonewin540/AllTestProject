//
//  PTView.m
//  ProgressTest
//
//  Created by stone win on 10/8/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "PTView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PTView
{
    UIImageView *_imageView0, *_imageView1, *_imageView2;
    NSValue *_frame0, *_frame1, *_frame2;
    NSTimer *_timer;
}

#pragma mark - Lifecycle

#define kNumberOfImageViews 3
- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = 34;
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _speed = 2;
        
        CGRect rect;
        rect.origin.y = 0;
        rect.size = frame.size;
        for (int i=0; i<kNumberOfImageViews; i++)
        {
            rect.origin.x = (i * frame.size.width) - frame.size.width;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            [self addSubview:imageView];
            
            NSString *key = [NSString stringWithFormat:@"_imageView%d", i];
            [self setValue:imageView forKey:key];
            key = [NSString stringWithFormat:@"_frame%d", i];
            [self setValue:[NSValue valueWithCGRect:imageView.frame] forKey:key];
        }
        
        _promptLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _promptLabel.backgroundColor = [UIColor clearColor];
        _promptLabel.textAlignment = UITextAlignmentCenter;
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_promptLabel];
        
    }
    return self;
}

- (void)removeFromSuperview
{
    [_timer invalidate];
    [super removeFromSuperview];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - Helpers

- (void)enumerateSubviews:(void (^)(UIImageView *imageView, NSValue *originalFrame))handler
{
    for (int i=0; i<kNumberOfImageViews; i++)
    {
        NSString *key = [NSString stringWithFormat:@"_imageView%d", i];
        UIImageView *imageView = [self valueForKey:key];
        if (![imageView isKindOfClass:[UIImageView class]]) imageView = nil;
        
        key = [NSString stringWithFormat:@"_frame%d", i];
        NSValue *value = [self valueForKey:key];
        if (![value isKindOfClass:[NSValue class]]) value = nil;
        
        if (imageView && value) handler(imageView, value);
    }
}

#pragma mark - State

- (void)succeed
{
    [_timer invalidate];
    
    [self enumerateSubviews:^(UIImageView *imageView, NSValue *originalFrame) {
        
        imageView.frame = [originalFrame CGRectValue];
        imageView.image = _succeedImage;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.hidden = NO;
        
    }];
}

- (void)failure
{
    [_timer invalidate];
    
    [self enumerateSubviews:^(UIImageView *imageView, NSValue *originalFrame) {
        
        imageView.frame = [originalFrame CGRectValue];
        imageView.image = _failureImage;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.hidden = NO;
        
    }];
}

- (void)uploadingWithTimer:(NSTimer *)timer
{
    NSNumber *number = [timer userInfo];
    if (!number) return;
    NSTimeInterval speed = [number floatValue];
    
    [self enumerateSubviews:^(UIImageView *imageView, NSValue *originalFrame) {
        
        BOOL hidden;
        CGRect frame = imageView.frame;
        CGFloat width = CGRectGetWidth(self.frame);
        if (frame.origin.x < width)
        {
            frame.origin.x += width;
            hidden = NO;
        }
        else
        {
            frame.origin.x = -width;
            hidden = YES;
        }
        
        imageView.image = _uploadingImage;
        imageView.contentMode = UIViewContentModeTopLeft;
        imageView.hidden = hidden;
        
        [UIView animateWithDuration:speed delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            imageView.frame = frame;
        } completion:^(BOOL finished) {
            if (finished)
            {
                
            }
        }];
        
    }];
}

- (void)uploading
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:_speed target:self selector:@selector(uploadingWithTimer:) userInfo:[NSNumber numberWithFloat:_speed] repeats:YES];
    [_timer fire];
}

#pragma mark - Publics

- (void)setState:(TransmissionState)state
{
    _state = state;
    
    switch (_state)
    {
        case TransmissionStateFailure:
            [self failure];
            break;
        case TransmissionStateUploading:
            [self uploading];
            break;
        default:
            [self succeed];
            break;
    }
}

@end
