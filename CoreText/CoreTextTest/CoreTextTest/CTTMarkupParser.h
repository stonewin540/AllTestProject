//
//  CTTMarkupParser.h
//  CoreTextTest
//
//  Created by stone win on 2/13/14.
//  Copyright (c) 2014 stone win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTTMarkupParser : NSObject

@property (nonatomic, copy) NSString *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) NSMutableArray *images;

- (NSAttributedString *)attrStringFromMarkup:(NSString *)html;

@end
