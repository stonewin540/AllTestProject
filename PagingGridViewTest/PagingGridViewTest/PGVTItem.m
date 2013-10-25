//
//  PGVTItem.m
//  PagingGridViewTest
//
//  Created by stone win on 10/25/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "PGVTItem.h"

@implementation PGVTItem

#pragma mark - Views

- (void)initForDefault
{
    _textLabel = [[UILabel alloc] initWithFrame:_contentView.bounds];
    _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_contentView addSubview:_textLabel];
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithStyle:(PGVTItemStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self)
    {
        _style = style;
        _reuseIdentifier = [reuseIdentifier copy];
        
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_contentView];
        
        [self initForDefault];
    }
    return self;
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
