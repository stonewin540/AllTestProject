//
//  RTCell.m
//  ReusableTest
//
//  Created by stone win on 5/14/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "RTCell.h"

@interface RTCell ()

@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, strong) UIView *separator;

@end

@implementation RTCell
{
    CGRect _frame;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, HEIGHT_CELL_DEFAULT)];
    if (self)
    {
        _reuseIdentifier = [reuseIdentifier copy];
        
        // label
        _frame = self.bounds;
        
        _textLabel = [[UILabel alloc] initWithFrame:_frame];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textLabel.backgroundColor = [UIColor blackColor];
        _textLabel.textAlignment = UITextAlignmentLeft;
        _textLabel.textColor = [UIColor whiteColor];
        [self addSubview:_textLabel];
        
        // separator
        _frame = self.bounds;
        _frame.size.height = 1;
        _frame.origin = CGPointMake(0, CGRectGetHeight(self.bounds)-_frame.size.height);
        
        _separator = [[UIView alloc] initWithFrame:_frame];
        _separator.backgroundColor = [UIColor whiteColor];
        _separator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_separator];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)prepareForReuse
{
    //NSLog(@"%s", __FUNCTION__);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
