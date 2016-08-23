//
//  QFMoveView.m
//  QFMoveView
//
//  Created by QianFan_Ryan on 16/8/23.
//  Copyright © 2016年 QianFan. All rights reserved.
//

#import "QFMoveView.h"
#import "UIView+move.h"

#define kColorRGB(r, g, b)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0f]
#define kColorRandom               kColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface QFMoveView()<UIViewMoveDelegate>

@property (nonatomic, assign)CGPoint originCenter;
@property (nonatomic, assign)CGPoint gestureLocationInView;
@property (nonatomic, strong)NSMutableArray <UIView *>*sortedSubViews;

@end

@implementation QFMoveView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _perRowCount = 4;
        _widthHeightScale = 1;
    }
    return self;
}

- (void)setData:(NSArray *)data{
    if (!data || data.count == 0) {
        return;
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat itemWidth = rintf((self.bounds.size.width - _leftMargin - _rightMargin - _horizontalInterval*(_perRowCount - 1))/_perRowCount);
    CGFloat itemHeight = itemWidth*_widthHeightScale;
    NSUInteger rowCount = data.count/_perRowCount + (data.count%_perRowCount>0?1:0);
    CGFloat totalHeight = _topMargin + (rowCount * itemHeight) + (rowCount - 1)*_verticalInterval * _bottomMargin;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, totalHeight);
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger row = idx/_perRowCount;
        NSUInteger column = idx%_perRowCount;
        UIView *view;
        if ([obj isKindOfClass:[NSNull class]]) {
            view = [[UIView alloc]init];
            view.backgroundColor = kColorRandom;
        } else if ([obj isKindOfClass:[UIImage class]]) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.image = obj;
            view = imageView;
        } 
        view.frame = CGRectMake(_leftMargin + column * (itemWidth + _horizontalInterval), _topMargin + row * (itemHeight + _verticalInterval), itemWidth, itemHeight);
        view.tagId = idx;
        view.moveDelegate = self;
        [self addSubview:view];
        [self.sortedSubViews insertObject:view atIndex:idx];
    }];
}

#pragma mark -- UIViewMoveDelegate
- (void)view:(UIView *)view beginToMove:(UIPanGestureRecognizer *)gesture{
    _originCenter = view.center;
    [self recoverWithView:nil];
    _gestureLocationInView = [gesture locationInView:self];
    [self bringSubviewToFront:view];
    view.transform = CGAffineTransformMakeScale(1.1, 1.1);
}

- (void)view:(UIView *)view isMoving:(UIPanGestureRecognizer *)gesture{
    CGPoint newPoint = [gesture locationInView:self];
    CGFloat deltaX = newPoint.x - _gestureLocationInView.x;
    CGFloat deltaY = newPoint.y - _gestureLocationInView.y;
    _gestureLocationInView = newPoint;
    view.center = CGPointMake(view.center.x + deltaX, view.center.y + deltaY);
    NSInteger newIndex = [self newIndexOfView:view];
    if (newIndex < 0) {
        return;
    }
    UIView *targetView = [self.sortedSubViews objectAtIndex:newIndex];
    _originCenter = targetView.originCenter;
    if (newIndex < view.tagId) {
        for (NSUInteger i = view.tagId; i > newIndex; i--) {
            UIView *firstView = [self.sortedSubViews objectAtIndex:(i - 1)];
            UIView *lastView = [self.sortedSubViews objectAtIndex:i];
            [UIView animateWithDuration:0.35 animations:^{
                firstView.center = lastView.originCenter;
            }];
        }
        [self.sortedSubViews removeObject:view];
        [self.sortedSubViews insertObject:view atIndex:newIndex];
        [self recoverWithView:view];
    } else if (newIndex > view.tagId) {
        for (NSUInteger i = view.tagId; i < newIndex; i++) {
            UIView *firstView = [self.sortedSubViews objectAtIndex:i];
            UIView *lastView = [self.sortedSubViews objectAtIndex:(i + 1)];
            [UIView animateWithDuration:0.35 animations:^{
                lastView.center = firstView.originCenter;
            }];
        }
        [self.sortedSubViews removeObject:view];
        [self.sortedSubViews insertObject:view atIndex:newIndex];
        [self recoverWithView:view];
    }
}

- (void)view:(UIView *)view endMove:(UIPanGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.35 animations:^{
        view.center = _originCenter;
    }];
    view.transform = CGAffineTransformIdentity;
}

#pragma mark -- help
- (void)recoverWithView:(UIView *)view{
    for (NSUInteger i = 0; i < self.sortedSubViews.count; i++) {
        UIView *aView = [self.sortedSubViews objectAtIndex:i];
        aView.tagId = i;
        if (aView == view) {
            aView.originCenter = _originCenter;
        } else {
            aView.originCenter = aView.center;
        }
    }
}

- (NSInteger)newIndexOfView:(UIView *)view{
    NSUInteger newIndex = -1;
    for (UIView *aView in self.subviews) {
        if (aView != view) {
            if (CGRectContainsPoint(aView.frame, view.center)) {
                newIndex = aView.tagId;
            }
        }
    }
    return newIndex;
}

#pragma mark -- property
- (NSMutableArray <UIView *>*)sortedSubViews{
    if (!_sortedSubViews) {
        _sortedSubViews = [NSMutableArray array];
    }
    return _sortedSubViews;
}

@end
