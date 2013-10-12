//
//  ViewController.m
//  UIImageOrientationTest
//
//  Created by stone on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface UIImage(Resize)
- (UIImage *)scaledCopyOfSize:(CGSize)newSize;
@end

@implementation UIImage(Resize)

- (UIImage *)scaledCopyOfSize:(CGSize)newSize 
{
    // 取得原图片的大小
    CGImageRef imgRef = self.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    // 构造新的图片大小
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > newSize.width || height > newSize.height) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = newSize.width;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = newSize.height;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    // 这里应该是判断这个方法是否可行，行就用，不行就换别的方法
    if (UIGraphicsBeginImageContextWithOptions) 
    {
        UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0.0f);
    } 
    else 
    {
        UIGraphicsBeginImageContext(bounds.size);
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    // 原图片在新图层上的缩放比例
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    // 原图片在新图层上的坐标远点（原图的坐标原点被定位在左下角）
    CGContextTranslateCTM(context, 0, -height);
    // 将原图片的坐标系统转移到新的矩阵中
    CGContextConcatCTM(context, transform);
    // 将原图片的引用以及原图片的bounds，按照以上的设置，绘画在新的context中
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    // 从当前的上下文对象中取得一个Image对象
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    // 这个方法是将绘制好的位图上下文对象从堆栈顶部移除
    // 虽然不写也行，但不知道什么时候可能异常
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end

@implementation ViewController

@synthesize testImageView = _testImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    UIImage *image = [UIImage imageNamed:@"img.png"];
//    self.testImageView = [[[UIImageView alloc] initWithImage:image] autorelease];
//    [self.view addSubview:self.testImageView];
    
    // 以上是一种正常的情况，特意找了一张比较大的图片，不经过任何改变直接添加到自己的view中
    
    UIImage *png = [UIImage imageNamed:@"img.png"];
    UIImage *originalImage = [UIImage imageWithCGImage:png.CGImage scale:0. orientation:UIImageOrientationRight];
    CGImageRef imageRef = originalImage.CGImage;
    CGFloat imageWidth = CGImageGetWidth(imageRef);
    CGFloat imageHeight = CGImageGetHeight(imageRef);
    CGSize newSize = CGSizeMake(320, 480);
    CGFloat newWidth = newSize.width;
    CGFloat newHeight = newWidth / (imageWidth / imageHeight);
    CGRect newBounds = CGRectMake(0, 0, newWidth, newHeight);
    UIImageOrientation orient = originalImage.imageOrientation;

    if (imageWidth > newWidth || imageHeight > newHeight) 
    {
        CGFloat ratio = imageWidth/imageHeight;
        if (ratio > 1 || orient == UIImageOrientationLeft || orient == UIImageOrientationRight) 
        {
            newBounds.size.width = newWidth;
            newBounds.size.height = newBounds.size.width / ratio;
        }
        else 
        {
            newBounds.size.height = newHeight;
            newBounds.size.width = newBounds.size.height * ratio;
        }
    }
    
    UIGraphicsBeginImageContext(newBounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat scale = newWidth / imageWidth;
    CGAffineTransform transform;
    
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageWidth, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(0, imageHeight);
//            transform = CGAffineTransformRotate(transform, M_PI);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(imageWidth, imageHeight);
//            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            newBounds.size.height = newWidth;
            newBounds.size.width = newHeight;
            transform = CGAffineTransformMakeTranslation(imageHeight, imageWidth);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
//            newBounds.size.height = newWidth;
//            newBounds.size.width = newHeight;
            transform = CGAffineTransformMakeTranslation(((imageHeight - imageWidth) / 2), imageWidth);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            newBounds.size.height = newWidth;
            newBounds.size.width = newHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            newBounds.size.height = newWidth;
            newBounds.size.width = newHeight;
            transform = CGAffineTransformMakeTranslation(imageHeight, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) 
    {
        CGContextScaleCTM(context, -scale, scale);
        CGContextTranslateCTM(context, -imageHeight, 0);
    }
    else 
    {
        CGContextScaleCTM(context, scale, -scale);
        CGContextTranslateCTM(context, 0, -imageHeight);
    }
    
//    CGContextScaleCTM(context, scale, -scale);
//    CGContextTranslateCTM(context, 0, -imageHeight);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), imageRef);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.testImageView = [[[UIImageView alloc] initWithImage:scaledImage] autorelease];
    [self.testImageView setCenter:self.view.center];
    [self.view addSubview:self.testImageView];
}

- (void)viewDidUnload
{
    [self setTestImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [_testImageView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
