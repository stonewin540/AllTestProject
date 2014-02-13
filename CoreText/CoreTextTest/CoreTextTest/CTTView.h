//
//  CTTView.h
//  CoreTextTest
//
//  Created by stone win on 2/10/14.
//  Copyright (c) 2014 stone win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTTView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, strong) NSMutableArray *frames;

- (void)buildFrames;

@end

@interface CTTViewController : UIViewController

@end
