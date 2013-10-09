//
//  PCTViewController.m
//  PaintCodeTest
//
//  Created by stone win on 4/29/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "PCTViewController.h"

@interface PCTViewController ()

@end

@implementation PCTViewController
{
    CGRect _frame;
}

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
    // self view
    _frame = [UIScreen mainScreen].applicationFrame;
    self.view = [[UIView alloc] initWithFrame:_frame];
    
    // image view
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(104*2, 37*2), NO, 0);
        
        //// General Declarations
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
        
        //// Shadow Declarations
        UIColor* shadow = strokeColor;
        CGSize shadowOffset = CGSizeMake(1.1, 2.1);
        CGFloat shadowBlurRadius = 5;
        
        //// Rounded Rectangle Drawing
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 104, 37) cornerRadius: 4];
        [fillColor setFill];
        [roundedRectanglePath fill];
        
        ////// Rounded Rectangle Inner Shadow
        CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds], -shadowBlurRadius, -shadowBlurRadius);
        roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -shadowOffset.width, -shadowOffset.height);
        roundedRectangleBorderRect = CGRectUnion(roundedRectangleBorderRect, [roundedRectanglePath bounds]);
        roundedRectangleBorderRect = CGRectInset(roundedRectangleBorderRect, -1, -1);

        UIBezierPath* roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect: roundedRectangleBorderRect];
        [roundedRectangleNegativePath appendPath: roundedRectanglePath];
        roundedRectangleNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = shadowOffset.width + round(roundedRectangleBorderRect.size.width);
            CGFloat yOffset = shadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        shadowBlurRadius,
                                        shadow.CGColor);
            
//            [roundedRectanglePath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0);
            [roundedRectangleNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [roundedRectangleNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        [strokeColor setStroke];
        roundedRectanglePath.lineWidth = 1;
        [roundedRectanglePath stroke];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        if (image)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _frame.origin = CGPointMake(50, 50);
                _frame.size = image.size;
                NSLog(@"frame: %@", NSStringFromCGRect(_frame));
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:_frame];
                imageView.backgroundColor = [UIColor blueColor];
                imageView.image = image;
                [self.view addSubview:imageView];
                
            });
        }
        
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
