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

#define kFontTitleLabel             [UIFont boldSystemFontOfSize:17]
#define kColorTitleLabelNormal      [UIColor lightGrayColor]
#define kColorTitleLabelSelected    [UIColor blueColor]

#pragma mark -
#pragma mark - Item

@interface ZhiyueScrollSelectorItem : UIView

@property (nonatomic, strong, readonly) UILabel *textLabel;

@end

@implementation ZhiyueScrollSelectorItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textLabel.textColor = kColorTitleLabelNormal;
        _textLabel.textAlignment = UITextAlignmentCenter;
        _textLabel.font = kFontTitleLabel;
        [self addSubview:_textLabel];
    }
    return self;
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark - ScrollSelector


@interface SRTScrollSelector () <UIScrollViewDelegate>

@end

@implementation SRTScrollSelector
{
    NSMutableDictionary *_rectForIndexPath, *_itemForIndexPath;
    NSMutableSet *_invisibleItems;
    NSIndexPath *_selectedIndexPath;
    NSValue *_scrolledRect;
    
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

- (NSIndexPath *)indexPathForItem:(ZhiyueScrollSelectorItem *)item
{
    NSValue *value = [NSValue valueWithCGRect:item.frame];
    NSArray *allKeys = [_rectForIndexPath allKeysForObject:value];
    if ([allKeys count] > 1)
    {
        NSLog(@"%s get indexPath error!", __func__);
    }
    return [allKeys lastObject];
}

- (void)setItemSelected:(BOOL)selected withIndexPath:(NSIndexPath *)indexPath
{
    ZhiyueScrollSelectorItem *item = _itemForIndexPath[indexPath];
    UIColor *color = selected ? kColorTitleLabelSelected : kColorTitleLabelNormal;
    item.textLabel.textColor = color;
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

- (ZhiyueScrollSelectorItem *)defaultItem
{
    ZhiyueScrollSelectorItem *item = [[ZhiyueScrollSelectorItem alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleItemTapped:)];
    [item addGestureRecognizer:tap];
    item.userInteractionEnabled = YES;
    return item;
}

#pragma mark - Property

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    _scrolledRect = [NSValue valueWithCGRect:rect];
    
    rect.size = _scrollView.bounds.size;
    [_scrollView scrollRectToVisible:rect animated:animated];
}

#pragma mark - Public

- (void)selectedTitleAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    [self setItemSelected:YES withIndexPath:indexPath];
}

#pragma mark - Action

- (void)titleItemTapped:(UITapGestureRecognizer *)sender
{
    [self setItemSelected:NO withIndexPath:_selectedIndexPath];
    _selectedIndexPath = [self indexPathForItem:((ZhiyueScrollSelectorItem *)sender.view)];
    [self setItemSelected:YES withIndexPath:_selectedIndexPath];
    
    if (_delegate)
    {
        [_delegate scrollSelector:self didSelectTitleAtIndexPath:_selectedIndexPath];
    }
}

- (void)didReceiveMemoryWarning:(NSNotification *)sender
{
    [_invisibleItems removeAllObjects];
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)aframe
{
    self = [super initWithFrame:aframe];
    if (self) {
        // Initialization code
        _rectForIndexPath = [[NSMutableDictionary alloc] init];
        _itemForIndexPath = [[NSMutableDictionary alloc] init];
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _invisibleItems = [[NSMutableSet alloc] init];
        
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
        _scrollView.scrollsToTop = NO;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [_itemForIndexPath removeAllObjects];
    [_invisibleItems removeAllObjects];
    
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
    }
    
    x -= kGapBetweenItem;
    _scrollView.contentSize = CGSizeMake(x, CGRectGetHeight(_scrollView.bounds));
    [self setShadowHiddenWithScrollView:_scrollView];
    
    for (NSIndexPath *indexPath in _rectForIndexPath)
    {
        NSValue *rectValue = _rectForIndexPath[indexPath];
        CGRect frame = [rectValue CGRectValue];
        CGRect visibleRect = [self currentScrollVisibleRect];
        if (CGRectIntersectsRect(visibleRect, frame))
        {
            ZhiyueScrollSelectorItem *item = [self defaultItem];
            item.frame = frame;
            item.textLabel.text = _titles[indexPath.row];
            
            [_scrollView addSubview:item];
            _itemForIndexPath[indexPath] = item;
        }
        
        
    }
    
    [self setItemSelected:YES withIndexPath:_selectedIndexPath];
    [self scrollRectToVisible:[_scrolledRect CGRectValue] animated:NO];
    _scrolledRect = nil;
}

#pragma mark - Reuse

- (void)enqueueObject:(ZhiyueScrollSelectorItem *)object
{
    [_invisibleItems addObject:object];
    
    NSArray *allKeys = [_itemForIndexPath allKeysForObject:object];
    NSAssert(1 == [allKeys count], @"More key-pairs is error!");
    [_itemForIndexPath removeObjectsForKeys:allKeys];
}

- (ZhiyueScrollSelectorItem *)dequeueObject
{
    ZhiyueScrollSelectorItem *item = [_invisibleItems anyObject];
    if (item)
    {
        [_invisibleItems removeObject:item];
    }
    return item;
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
    for (NSIndexPath *indexPath in _rectForIndexPath)
    {
        NSValue *value = _rectForIndexPath[indexPath];
        ZhiyueScrollSelectorItem *item = _itemForIndexPath[indexPath];
        if (CGRectIntersectsRect(visibleRect, [value CGRectValue]))
        {
            if (!item)
            {
                ZhiyueScrollSelectorItem *dequeueItem = [self dequeueObject];
                if (!dequeueItem)
                {
                    dequeueItem = [self defaultItem];
                    [_scrollView addSubview:dequeueItem];
                }
                
                dequeueItem.frame = [value CGRectValue];
                dequeueItem.textLabel.text = _titles[indexPath.row];
                dequeueItem.textLabel.textColor = [_selectedIndexPath isEqual:indexPath] ? kColorTitleLabelSelected : kColorTitleLabelNormal;
                
                _itemForIndexPath[indexPath] = dequeueItem;
            }
        }
        else
        {
            if (item)
            {
                [self enqueueObject:item];
            }
        }
    }
    
    NSLog(@"visibles: %u, invisibles: %u, subviews: %u", [_itemForIndexPath count], [_invisibleItems count], [[_scrollView subviews] count]);
}

@end
