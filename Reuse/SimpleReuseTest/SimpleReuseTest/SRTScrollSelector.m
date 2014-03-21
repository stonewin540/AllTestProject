//
//  SRTScrollSelector.m
//  ZhiyueSD
//
//  Created by stone win on 3/19/14.
//  Copyright (c) 2014 micromedia. All rights reserved.
//

#import "SRTScrollSelector.h"

static const NSUInteger kSection = 0;
static const CGFloat kGapBetweenItem = 20;
static const CGFloat kGapSide = 20;

#define kFontTitleLabel [UIFont boldSystemFontOfSize:17]

@interface SRTScrollSelector () <UIScrollViewDelegate>

@end

@implementation SRTScrollSelector
{
    NSMutableDictionary *_rectForIndexPath, *_buttonForIndexPath;
    NSMutableSet *_visibleIndexPaths, *_invisibleIndexPaths;
    NSIndexPath *_selectedIndexPath;
    
    UIScrollView *_scrollView;
    UIView *_leftShadowView, *_rightShadowView;
}

#pragma mark - Helper

- (void)setShadowHiddenWithScrollView:(UIScrollView *)scrollView
{
    BOOL leftHidden, rightHidden;
    leftHidden = scrollView.contentOffset.x <= 0;
    rightHidden = scrollView.contentSize.width <= CGRectGetWidth(scrollView.bounds);
    rightHidden = rightHidden || scrollView.contentOffset.x >= scrollView.contentSize.width - CGRectGetWidth(scrollView.bounds);
    
    _leftShadowView.hidden = leftHidden;
    _rightShadowView.hidden = rightHidden;
}

- (NSIndexPath *)indexPathForButton:(UIButton *)button
{
    NSValue *value = [NSValue valueWithCGRect:button.frame];
    NSArray *allKeys = [_rectForIndexPath allKeysForObject:value];
    if ([allKeys count] > 1)
    {
        NSLog(@"%s get indexPath error!", __func__);
    }
    return [allKeys lastObject];
}

- (void)setButtonSelected:(BOOL)selected withIndexPath:(NSIndexPath *)indexPath
{
    UIButton *button = _buttonForIndexPath[indexPath];
    button.selected = selected;
}

- (CGRect)currentScrollVisibleRect
{
    CGRect visibleRect = _scrollView.bounds;
    if (_scrollView.contentSize.width > CGRectGetWidth(_scrollView.bounds))
    {
        CGPoint contentOffset = _scrollView.contentOffset;
        CGSize contentSize = _scrollView.contentSize;
        CGFloat scrollWidth = CGRectGetWidth(_scrollView.bounds);
        CGFloat x;
        x = visibleRect.origin.x;
        
        x = contentOffset.x;
        x = MAX(x, 0);
        x = MIN(x, (contentSize.width - scrollWidth));
        
        visibleRect.origin.x = x;
    }
    return visibleRect;
}

#pragma mark - Property

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    rect.size = _scrollView.bounds.size;
    [_scrollView scrollRectToVisible:rect animated:animated];
}

#pragma mark - Public

- (void)selectedTitleAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    [self setButtonSelected:YES withIndexPath:indexPath];
}

#pragma mark - Action

- (void)titleButtonTapped:(UIButton *)sender
{
    [self setButtonSelected:NO withIndexPath:_selectedIndexPath];
    _selectedIndexPath = [self indexPathForButton:sender];
    [self setButtonSelected:YES withIndexPath:_selectedIndexPath];
    
    if (_delegate)
    {
        [_delegate scrollSelector:self didSelectTitleAtIndexPath:_selectedIndexPath];
    }
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)aframe
{
    self = [super initWithFrame:aframe];
    if (self) {
        // Initialization code
        _rectForIndexPath = [[NSMutableDictionary alloc] init];
        _buttonForIndexPath = [[NSMutableDictionary alloc] init];
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _visibleIndexPaths = [[NSMutableSet alloc] init];
        _invisibleIndexPaths = [[NSMutableSet alloc] init];
        
        // side shadow
        CGRect frame = CGRectZero;
        frame.size.width = kGapSide / 2;
        frame.size.height = CGRectGetHeight(self.bounds);
        _leftShadowView = [[UIView alloc] initWithFrame:frame];
        _leftShadowView.backgroundColor = self.backgroundColor;
        _leftShadowView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        _leftShadowView.hidden = YES;
        [self addSubview:_leftShadowView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectOffset(_leftShadowView.bounds, CGRectGetWidth(_leftShadowView.bounds), 0)];
        imageView.image = [UIImage imageNamed:@"image_shadow_left_subcolumn.png"];
        [_leftShadowView addSubview:imageView];
        _leftShadowView.clipsToBounds = NO;
        
        frame.origin.x = CGRectGetWidth(self.bounds) - frame.size.width;
        _rightShadowView = [[UIView alloc] initWithFrame:frame];
        _rightShadowView.backgroundColor = self.backgroundColor;
        _rightShadowView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        _rightShadowView.hidden = YES;
        [self addSubview:_rightShadowView];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectOffset(_rightShadowView.bounds, -CGRectGetWidth(_rightShadowView.bounds), 0)];
        imageView.image = [UIImage imageNamed:@"image_shadow_right_subcolumn.png"];
        [_rightShadowView addSubview:imageView];
        _rightShadowView.clipsToBounds = NO;
        
        // scroll view
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectInset(self.bounds, (kGapSide / 2), 0)];
        _scrollView.backgroundColor = self.backgroundColor;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.delegate = self;
        [self insertSubview:_scrollView belowSubview:_leftShadowView];
        
        // separator
        frame = self.bounds;
        frame.size.height = .5f;
        frame.origin.y = CGRectGetHeight(self.bounds) - frame.size.height;
        UIView *separator = [[UIView alloc] initWithFrame:frame];
        separator.backgroundColor = [UIColor darkGrayColor];
        separator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:separator];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _scrollView.backgroundColor = backgroundColor;
    _leftShadowView.backgroundColor = backgroundColor;
    _rightShadowView.backgroundColor = backgroundColor;
}

- (void)reloadData
{
    NSUInteger count = [_titles count];
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_rectForIndexPath removeAllObjects];
    [_buttonForIndexPath removeAllObjects];
    [_visibleIndexPaths removeAllObjects];
    [_invisibleIndexPaths removeAllObjects];
    
    CGFloat x = 0;
    for (int i = 0; i < count; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:kSection];
        
        NSString *title = _titles[i];
        CGRect frame;
        // adjust origin
        frame.origin.y = 0;
        frame.origin.x = x;
        frame.size.width = ceilf([title sizeWithFont:kFontTitleLabel].width);
        frame.size.height = CGRectGetHeight(_scrollView.bounds);
        // store
        NSValue *value = [NSValue valueWithCGRect:frame];
        _rectForIndexPath[indexPath] = value;
        
        x += frame.size.width + kGapBetweenItem;
        
        CGRect visibleRect = [self currentScrollVisibleRect];
        NSLog(@"%@", NSStringFromCGRect(visibleRect));
        if (CGRectIntersectsRect(visibleRect, frame))
        {
            [_visibleIndexPaths addObject:indexPath];
        }
        else
        {
            [_invisibleIndexPaths addObject:indexPath];
        }
        NSLog(@"vi: %u, in: %u", [_visibleIndexPaths count], [_invisibleIndexPaths count]);
    }
    
    x -= kGapBetweenItem;
    _scrollView.contentSize = CGSizeMake(x, CGRectGetHeight(_scrollView.bounds));
    [self setShadowHiddenWithScrollView:_scrollView];
    
    for (NSIndexPath *indexPath in _rectForIndexPath)
    {
        NSValue *rectValue = _rectForIndexPath[indexPath];
        CGRect frame = [rectValue CGRectValue];
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = kFontTitleLabel;
        [button setTitle:_titles[indexPath.row] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(titleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView addSubview:button];
        _buttonForIndexPath[indexPath] = button;
    }
    
    [self setButtonSelected:YES withIndexPath:_selectedIndexPath];
}

- (void)enqueueObject:(NSIndexPath *)object
{
    [_invisibleIndexPaths addObject:object];
    [_visibleIndexPaths removeObject:object];
}

- (NSIndexPath *)dequeueObject
{
    NSIndexPath *indexPath = [_invisibleIndexPaths anyObject];
    [_invisibleIndexPaths removeObject:indexPath];
    return indexPath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setShadowHiddenWithScrollView:scrollView];
    
    CGRect visibleRect = [self currentScrollVisibleRect];
    NSLog(@"%@", NSStringFromCGRect(visibleRect));
    for (NSIndexPath *indexPath in _rectForIndexPath)
    {
        NSValue *value = _rectForIndexPath[indexPath];
        if (CGRectIntersectsRect(visibleRect, [value CGRectValue]))
        {
            [_visibleIndexPaths addObject:[self dequeueObject]];
        }
        else
        {
            [self enqueueObject:indexPath];
        }
    }
    NSLog(@"vi: %u, in: %u", [_visibleIndexPaths count], [_invisibleIndexPaths count]);
}

@end
