//
//  RTCell.h
//  ReusableTest
//
//  Created by stone win on 5/14/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTCell : UIView

@property (nonatomic, strong, readonly) UILabel *textLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
