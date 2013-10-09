//
//  RTView.m
//  ReusableTest
//
//  Created by stone win on 5/14/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "RTView.h"

@interface RTCell (RTTableView)

@property (nonatomic, copy) NSString *reuseIdentifier;
- (void)prepareForReuse;

@end

@interface UIScrollView (RTTableView)

- (void)handlePan:(id)sender;

@end

@interface RTView ()

@property (nonatomic, strong) NSMutableArray *visibleRTCells;
@property (nonatomic, strong) NSMutableDictionary *reusableRTCells;
@property (nonatomic, strong) NSMutableDictionary *rowRects;

@end

@implementation RTView
{
    CGRect _frame;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _visibleRTCells = [[NSMutableArray alloc] init];
        _reusableRTCells = [[NSMutableDictionary alloc] init];
        _rowRects = [[NSMutableDictionary alloc] init];
        
//        NSUInteger count = (NSUInteger)ceilf(CGRectGetHeight(frame) / HEIGHT_CELL_DEFAULT);
        CGSize contentSize = frame.size;
//        contentSize.height = count * HEIGHT_CELL_DEFAULT;
        self.contentSize = contentSize;
        
//        self.contentInset = UIEdgeInsetsMake(0, 0, 1, 0);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (nil == _visibleRTCells || ![_visibleRTCells count]) {
        [self reloadData];
    } else {
        [self layoutVisibleCells];
    }
    
//    NSLog(@"%@", self.panGestureRecognizer);
}

- (void)handlePan:(id)sender
{
    [super handlePan:sender];
    
    UIPanGestureRecognizer *pan = sender;
    switch (pan.state) {
        case UIGestureRecognizerStateChanged:
        {
            CGRect bounds = self.bounds;
            
            [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                if ([obj isKindOfClass:[RTCell class]])
                {
                    RTCell *cell = obj;
                    if (!CGRectIntersectsRect(bounds, cell.frame))
                    {
                        [cell removeFromSuperview];
                        [_visibleRTCells removeObject:cell];
                        [self enqueueCell:cell];
                    }
                }
                
            }];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)reloadData
{
    //NSLog(@"%s", __FUNCTION__);
    
    [_rowRects removeAllObjects];
    
    NSUInteger numberOfRows = 1;
    if (_rtDataSource) {
        numberOfRows = [_rtDataSource numberOfRowsInReusableView];
    }
    
    CGFloat height = HEIGHT_CELL_DEFAULT;
    BOOL respondsHeight = _rtDelegate && [_rtDelegate respondsToSelector:@selector(reusableView:heightForRowAtIndexPath:)];
    
    for (int i = 0; i < numberOfRows; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        if (respondsHeight) {
            height = [_rtDelegate reusableView:self heightForRowAtIndexPath:indexPath];
        }
        _frame.origin = CGPointMake(0, i*height);
        _frame.size = CGSizeMake(CGRectGetWidth(self.bounds), height);
        [_rowRects setObject:[NSValue valueWithCGRect:_frame] forKey:indexPath];
    }
    
    CGSize contentSize = self.contentSize;
    contentSize.height = MAX(contentSize.height, numberOfRows*height);
    self.contentSize = contentSize;
    
    [self clearAllCells];
    [self layoutVisibleCells];
}

- (void)clearAllCells
{
    [_visibleRTCells makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_visibleRTCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { [self enqueueCell:obj]; }];
    [_visibleRTCells removeAllObjects];
}

- (void)layoutVisibleCells
{
    CGRect bounds = self.bounds;
    BOOL respondsWillDisplay = _rtDelegate && [_rtDelegate respondsToSelector:@selector(reusableView:willDisplayCell:forRowAtIndexPath:)];
    
    [_rowRects enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        CGRect rowRect = [obj CGRectValue];
        NSIndexPath *indexPath = key;
        __block BOOL isContainedRect = [_visibleRTCells count] ? YES : NO;
        
        [_visibleRTCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (!CGRectEqualToRect(rowRect, ((RTCell *)obj).frame)) {
                isContainedRect = NO;
                *stop = YES;
            }
        }];
        
        if (CGRectIntersectsRect(bounds, rowRect) && !isContainedRect)
        {
            RTCell *cell = nil;
            if (_rtDataSource) {
                cell = [_rtDataSource reusableView:self cellForRowAtIndexPath:indexPath];
            }
            cell.frame = rowRect;
            
            if (respondsWillDisplay) {
                [_rtDelegate reusableView:self willDisplayCell:cell forRowAtIndexPath:indexPath];
            }
            
//            [cell setNeedsLayout];
//            [cell setNeedsDisplay];
//            [self addSubview:cell];
//            [cell layoutIfNeeded];
            
            [self addSubview:cell];
            [_visibleRTCells addObject:cell];
        }
        
    }];
}

- (RTCell *)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier
{
    NSMutableSet *reusableSet = [_reusableRTCells objectForKey:reuseIdentifier];
    RTCell *cell = [reusableSet anyObject];
    if (nil == cell) return nil;
    
    [cell prepareForReuse];
    [reusableSet removeObject:cell];
    return cell;
}

- (void)enqueueCell:(RTCell *)cell
{
    NSMutableSet *reusableSet = [_reusableRTCells objectForKey:cell.reuseIdentifier];
    
    if (nil == reusableSet)
    {
        reusableSet = [[NSMutableSet alloc] init];
        [_reusableRTCells setObject:reusableSet forKey:cell.reuseIdentifier];
    }
    
    [reusableSet addObject:cell];
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
