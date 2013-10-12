//
//  QuartzFunView.h
//  RandomColorTest
//
//  Created by 文 斯敦 on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface QuartzFunView : UIView

@property CGPoint firstTouch;
@property CGPoint lastTouch;
@property ShapeType shapeType;
@property BOOL useRandomColor;
@property (nonatomic, retain) UIColor *currentColor;
@property (nonatomic, retain) UIImage *drawImage;

@end
