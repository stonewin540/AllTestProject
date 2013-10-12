//
//  Constants.h
//  RandomColorTest
//
//  Created by 文 斯敦 on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef RandomColorTest_Constants_h
#define RandomColorTest_Constants_h

typedef enum _ShapeType
{
    kLineShape = 0, 
    kRectShape, 
    kEllipseShape, 
    kImageShape
} ShapeType;

typedef enum _ColorTabIndex
{
    kRedColorTab = 0, 
    kBlueColorTab, 
    kYellowColorTab, 
    kGreenColorTab, 
    kRandomColorTab
} ColorTabIndex;
#define degreesToRadian(x) (3.14159265358979323846 * x / 180.0)

#endif
