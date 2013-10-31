//
//  IIOTDetailViewController.m
//  ImageIOTest
//
//  Created by stone win on 10/31/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "IIOTDetailViewController.h"
#import <ImageIO/ImageIO.h>

@interface IIOTDetailViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation IIOTDetailViewController

#pragma mark - Helper

- (CGSize)newAspectSizeForImageView:(UIImageView *)imageView
{
    CGFloat ratio = imageView.image.size.width / imageView.image.size.height;
    CGSize size;
    if (ratio > 1)
    {
        size.width = CGRectGetWidth(_scrollView.frame);
        size.height = size.width / ratio;
    }
    else
    {
        size.height = CGRectGetHeight(_scrollView.frame);
        size.width = size.height * ratio;
    }
    return size;
}

- (CGRect)centerFrameForImageView:(UIImageView *)imageView
{
    CGRect frame;
    frame.size = [self newAspectSizeForImageView:imageView];
    frame.origin.x = (CGRectGetWidth(_scrollView.frame)-frame.size.width) / 2;
    frame.origin.y = (CGRectGetHeight(_scrollView.frame)-frame.size.height) / 2;
    return frame;
}

- (NSData *)dataForRepresentation:(ALAssetRepresentation *)representation
{
    if (![representation isKindOfClass:[ALAssetRepresentation class]]) return nil;
    NSData *data = nil;
    
    NSError *error = nil;
    NSUInteger size = (NSUInteger)[representation size];
    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t) * size);
    NSUInteger length = [representation getBytes:buffer fromOffset:0 length:size error:&error];
    data = [NSData dataWithBytes:buffer length:length];
    free(buffer);
    return data;
}

- (void)readFromRepresentation:(ALAssetRepresentation *)representation
{
    NSLog(@"size: %@", NSStringFromCGSize(_imageView.image.size));
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        CFAbsoluteTime atime = CFAbsoluteTimeGetCurrent();
        NSData *data = [self dataForRepresentation:representation];
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
        NSDictionary *options = @{(__bridge id)kCGImageSourceCreateThumbnailFromImageIfAbsent: (__bridge id)kCFBooleanTrue};
        CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef)options);
        if (imageRef)
        {
            size_t width = CGImageGetWidth(imageRef);
            size_t height = CGImageGetHeight(imageRef);
            NSLog(@"%zu, %zu", width, height);
            UIImage *image = [UIImage imageWithCGImage:imageRef scale:[representation scale] orientation:(UIImageOrientation)[representation orientation]];
            NSLog(@"thumbnail size: %@", NSStringFromCGSize(image.size));
            NSLog(@"duration: %f", CFAbsoluteTimeGetCurrent()-atime);
            [_imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
            CGImageRelease(imageRef);
        }
        if (source) CFRelease(source);
        
    });
}

#pragma mark - Action

- (void)backAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];

    CGRect scroll, label;
    CGRectDivide(self.view.bounds, &label, &scroll, 50, 3);
    _scrollView = [[UIScrollView alloc] initWithFrame:scroll];
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 8;
    _scrollView.zoomScale = 1;
    _scrollView.bouncesZoom = YES;
    _scrollView.contentSize = _scrollView.bounds.size;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _label = [[UILabel alloc] initWithFrame:label];
    _label.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:[UIFont labelFontSize]*2];
    [self.view addSubview:_label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 70, 40);
    [button setTitle:@"back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (_text)
    {
        _label.text = _text;
    }
    if (_asset)
    {
        ALAssetRepresentation *representation = [_asset defaultRepresentation];
        UIImage *image = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:[representation scale] orientation:(UIImageOrientation)[representation orientation]];
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.frame = [self centerFrameForImageView:_imageView];
        [_scrollView addSubview:_imageView];
        
        [self readFromRepresentation:representation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

@end
