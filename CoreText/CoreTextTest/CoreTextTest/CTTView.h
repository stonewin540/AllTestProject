//
//  CTTView.h
//  CoreTextTest
//
//  Created by stone win on 2/10/14.
//  Copyright (c) 2014 stone win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@class CTTColumnView;

@interface CTTView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, strong) NSArray *images;

- (void)buildFrames;
- (void)setAttributedString:(NSAttributedString *)attributedString withImages:(NSArray *)imgs;
- (void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(CTTColumnView *)col;

@end

@interface CTTViewController : UIViewController

@end
