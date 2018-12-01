//
//  VITimelineView.m
//  vito
//
//  Created by Vito on 2018/8/28.
//  Copyright © 2018 vito. All rights reserved.
//

#import "VITimelineView.h"
#import "UIView+ConstraintHolder.h"

@interface VITimelineView() <VIRangeViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) UIView *scrollRangeContentView;
@property (nonatomic, strong) UIImageView *centerLineView;


@property (nonatomic, strong) NSMutableArray<VIRangeView *> *rangeViews;


// Configuration
@property (nonatomic) CGFloat videoRangeViewEarWidth;

// Helper

@property (nonatomic, weak) id<UIScrollViewDelegate> previousScrollViewDelegate;

@end

@implementation VITimelineView

#pragma mark - Life Cycle

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _videoRangeViewEarWidth = 15;
    _rangeViews = [NSMutableArray array];
    _contentWidthPerSecond = 50;
    
    UIView *contentBackgroundView = [UIView new];
    contentBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:contentBackgroundView];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *scrollContentView = [UIView new];
    scrollContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:scrollContentView];
    self.scrollContentView = scrollContentView;
    
    UIView *scrollRangeContentView = [UIView new];
    scrollRangeContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollContentView addSubview:scrollRangeContentView];
    self.scrollRangeContentView = scrollRangeContentView;
    
    UIImageView *centerLineView = [[UIImageView alloc] init];
    centerLineView.translatesAutoresizingMaskIntoConstraints = NO;
    centerLineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:centerLineView];
    self.centerLineView = centerLineView;
    
    // Layout
    
    [scrollView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [scrollView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [scrollView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    [scrollContentView.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor].active = YES;
    [scrollContentView.rightAnchor constraintEqualToAnchor:scrollView.rightAnchor].active = YES;
    [scrollContentView.topAnchor constraintEqualToAnchor:scrollView.topAnchor].active = YES;
    [scrollContentView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor].active = YES;
    [scrollContentView.heightAnchor constraintEqualToAnchor:scrollView.heightAnchor].active = YES;
    
    [scrollRangeContentView.leftAnchor constraintEqualToAnchor:scrollContentView.leftAnchor].active = YES;
    [scrollRangeContentView.rightAnchor constraintEqualToAnchor:scrollContentView.rightAnchor].active = YES;
    [scrollRangeContentView.centerYAnchor constraintEqualToAnchor:scrollContentView.centerYAnchor].active = YES;
    [scrollRangeContentView.heightAnchor constraintEqualToConstant:45].active = YES;
    
    [contentBackgroundView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [contentBackgroundView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [contentBackgroundView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [contentBackgroundView.heightAnchor constraintEqualToAnchor:scrollRangeContentView.heightAnchor].active = YES;
    
    [centerLineView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [centerLineView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    // Gesture
    UITapGestureRecognizer *tapContentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentAction:)];
    [self addGestureRecognizer:tapContentGesture];
    
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftInset = self.bounds.size.width * 0.5 - self.rangeViews.firstObject.contentInset.left;
    CGFloat rightInset = self.bounds.size.width * 0.5 - self.rangeViews.lastObject.contentInset.left;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, leftInset, 0, rightInset);
    [self displayRangeViewsIfNeed];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self displayRangeViewsIfNeed];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Action

- (void)tapContentAction:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    BOOL tapOnVideoRangeView = NO;
    for (VIRangeView *view in self.rangeViews) {
        CGRect rect = [view.superview convertRect:view.frame toView:self];
        if (CGRectContainsPoint(rect, point)) {
            tapOnVideoRangeView = YES;
            break;
        }
    }
    if (!tapOnVideoRangeView) {
        [self resignVideoRangeView];
    }
}

- (void)tapRangeViewAction:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        VIRangeView *rangeView = (VIRangeView *)gesture.view;
        if ([rangeView isKindOfClass:[VIRangeView class]]) {
            if (!rangeView.isActived) {
                [rangeView activeEarAnimated:YES];
                [self.rangeViews enumerateObjectsUsingBlock:^(VIRangeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj != rangeView && obj.isActived) {
                        [obj inactiveEarAnimated:YES];
                    }
                }];
            } else {
                [rangeView inactiveEarAnimated:YES];
            }
            [self.delegate timelineView:self didChangeActive:[self isActived]];
        }
    }
}

#pragma mark - Public

- (void)reloadWithRangeViews:(NSArray<VIRangeView *> *)rangeViews {
    [self removeAllRangeViews];
    [rangeViews enumerateObjectsUsingBlock:^(VIRangeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self insertRangeView:obj atIndex:idx];
    }];
}

- (void)insertRangeView:(VIRangeView *)view atIndex:(NSInteger)index {
    view.widthPerSecond = self.contentWidthPerSecond;
    view.delegate = self;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollRangeContentView addSubview:view];
    UITapGestureRecognizer *tapContentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRangeViewAction:)];
    [view addGestureRecognizer:tapContentGesture];
    
    if (self.rangeViews.count == 0) {
        view.vi_constraints =
        @[[view.leftAnchor constraintEqualToAnchor:self.scrollRangeContentView.leftAnchor],
          [view.rightAnchor constraintEqualToAnchor:self.scrollRangeContentView.rightAnchor],
          [view.topAnchor constraintEqualToAnchor:self.scrollRangeContentView.topAnchor],
          [view.bottomAnchor constraintEqualToAnchor:self.scrollRangeContentView.bottomAnchor]
          ];
        [NSLayoutConstraint activateConstraints:view.vi_constraints];
    } else {
        void(^updateLeft)(VIRangeView *rangeView) = ^(VIRangeView *rangeView) {
            [rangeView updateRightConstraint:^NSLayoutConstraint * _Nonnull{
                CGFloat offset = rangeView.contentInset.right + view.contentInset.left - (self.rangeViewLeftInset + self.rangeViewRightInset);
                NSLayoutConstraint *rightConstraint = [rangeView.rightAnchor constraintEqualToAnchor:view.leftAnchor constant:offset];
                return rightConstraint;
            }];
        };
        
        void(^updateRight)(VIRangeView *rangeView) = ^(VIRangeView *rangeView) {
            [rangeView updateRightConstraint:^NSLayoutConstraint * _Nonnull{
                return nil;
            }];
        };
        
        if (index >= self.rangeViews.count) {
            VIRangeView *leftRangeView = self.rangeViews.lastObject;
            updateLeft(leftRangeView);
            
            view.vi_constraints =
            @[[view.rightAnchor constraintEqualToAnchor:self.scrollRangeContentView.rightAnchor],
              [view.topAnchor constraintEqualToAnchor:self.scrollRangeContentView.topAnchor],
              [view.bottomAnchor constraintEqualToAnchor:self.scrollRangeContentView.bottomAnchor]
              ];
            [NSLayoutConstraint activateConstraints:view.vi_constraints];
        } else if (index == 0) {
            VIRangeView *rightRangeView = self.rangeViews.firstObject;
            updateRight(rightRangeView);
            
            CGFloat offset = (rightRangeView.contentInset.left + view.contentInset.right) - (self.rangeViewLeftInset + self.rangeViewRightInset);
            view.vi_constraints =
            @[[view.leftAnchor constraintEqualToAnchor:self.scrollRangeContentView.leftAnchor],
              [view.rightAnchor constraintEqualToAnchor:rightRangeView.leftAnchor constant:offset],
              [view.topAnchor constraintEqualToAnchor:self.scrollRangeContentView.topAnchor],
              [view.bottomAnchor constraintEqualToAnchor:self.scrollRangeContentView.bottomAnchor]
              ];
            [NSLayoutConstraint activateConstraints:view.vi_constraints];
        } else {
            VIRangeView *leftRangeView = self.rangeViews[index - 1];
            VIRangeView *rightRangeView = self.rangeViews[index];
            
            updateLeft(leftRangeView);
            
            updateRight(rightRangeView);
            
            
            CGFloat offset = (rightRangeView.contentInset.left + view.contentInset.right) - (self.rangeViewLeftInset + self.rangeViewRightInset);
            view.vi_constraints =
            @[[view.topAnchor constraintEqualToAnchor:self.scrollRangeContentView.topAnchor],
              [view.bottomAnchor constraintEqualToAnchor:self.scrollRangeContentView.bottomAnchor],
              [view.rightAnchor constraintEqualToAnchor:rightRangeView.leftAnchor constant:offset],
              ];
            [NSLayoutConstraint activateConstraints:view.vi_constraints];
        }
    }
    [self.rangeViews insertObject:view atIndex:index];
}

- (void)removeCurrentActivedRangeViewCompletion:(void(^)(void))completion {
    __block NSInteger index = -1;
    [self.rangeViews enumerateObjectsUsingBlock:^(VIRangeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isActived) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index != -1) {
        [self removeRangeViewAtIndex:index animated:YES completion:completion];
    }
}

- (void)removeRangeViewAtIndex:(NSInteger)index animated:(BOOL)animated completion:(void(^)(void))completion {
    if (index < 0 || index >= self.rangeViews.count) {
        return;
    }
    VIRangeView *rangeView = self.rangeViews[index];
    CGFloat contentWidth = rangeView.contentWidth;
    
    void(^completionHandler)(void) = ^{
        [rangeView removeFromSuperview];
        if (self.rangeViews.count > 1) {
            if (index == 0) {
                VIRangeView *rightRangeView = self.rangeViews[index + 1];
                [rightRangeView updateLeftConstraint:^NSLayoutConstraint * _Nonnull{
                    return [rightRangeView.leftAnchor constraintEqualToAnchor:rightRangeView.superview.leftAnchor];
                }];
            } else if (index == self.rangeViews.count - 1) {
                VIRangeView *leftRangeView = self.rangeViews[index - 1];
                [leftRangeView updateRightConstraint:^NSLayoutConstraint * _Nonnull{
                    return [leftRangeView.rightAnchor constraintEqualToAnchor:leftRangeView.superview.rightAnchor];
                }];
            } else {
                VIRangeView *rightRangeView = self.rangeViews[index + 1];
                VIRangeView *leftRangeView = self.rangeViews[index - 1];
                [leftRangeView updateRightConstraint:^NSLayoutConstraint * _Nonnull{
                    CGFloat offset = (rightRangeView.contentInset.left + leftRangeView.contentInset.right) - (self.rangeViewLeftInset + self.rangeViewRightInset);
                    return [leftRangeView.rightAnchor constraintEqualToAnchor:rightRangeView.leftAnchor constant:offset];
                }];
            }
        }
        
        [self.rangeViews removeObjectAtIndex:index];
        if (completion) {
            completion();
        }
    };
    
    if (animated) {
        [self.scrollRangeContentView insertSubview:rangeView atIndex:0];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (self.rangeViews.count > 1) {
                if (index == 0) {
                    VIRangeView *rightRangeView = self.rangeViews[index + 1];
                    [rangeView updateRightConstraint:^NSLayoutConstraint * _Nonnull{
                        return [rangeView.rightAnchor constraintEqualToAnchor:rightRangeView.leftAnchor constant:(contentWidth + rangeView.contentInset.right + rightRangeView.contentInset.left)];
                    }];
                } else if (index == self.rangeViews.count - 1) {
                    VIRangeView *leftRangeView = self.rangeViews[index - 1];
                    [leftRangeView updateRightConstraint:^NSLayoutConstraint * _Nonnull{
                        return [leftRangeView.rightAnchor constraintEqualToAnchor:rangeView.leftAnchor constant:(contentWidth + rangeView.contentInset.left + leftRangeView.contentInset.right)];
                    }];
                } else {
                    VIRangeView *rightRangeView = self.rangeViews[index + 1];
                    [rangeView updateRightConstraint:^NSLayoutConstraint * _Nonnull{
                        return [rangeView.rightAnchor constraintEqualToAnchor:rightRangeView.leftAnchor constant:(contentWidth + rangeView.contentInset.right + rightRangeView.contentInset.left)];
                    }];
                }
            }
            
            rangeView.alpha = 0.0;
            rangeView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            completionHandler();
        }];
    } else {
        completionHandler();
    }
    
}

- (CGFloat)timelineWidthPerSeconds {
    return self.contentWidthPerSecond;
}

- (CGFloat)calculateOffsetXAtTime:(CMTime)time {
    CGFloat offsetX = -self.scrollView.contentInset.left;
    offsetX += CMTimeGetSeconds(time) * [self timelineWidthPerSeconds];
    if (isnan(offsetX)) {
        offsetX = -self.scrollView.contentInset.left;
    }
    return offsetX;
}

- (NSInteger)getRangeViewIndexAtTime:(CMTime)time {
    __block NSInteger index = 0;
    __block NSTimeInterval duration = CMTimeGetSeconds(time);
    [self.rangeViews enumerateObjectsUsingBlock:^(VIRangeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSTimeInterval contentDuration = CMTimeGetSeconds(CMTimeSubtract(obj.endTime, obj.startTime));
        if (duration <= contentDuration) {
            index = idx;
            *stop = YES;
        } else {
            duration -= contentDuration;
        }
    }];
    return index;
}

- (CMTime)calculateTimeAtOffsetX:(CGFloat)offsetX {
    CGFloat offset = offsetX + self.scrollView.contentInset.left;
    NSTimeInterval duration = offset / [self timelineWidthPerSeconds];
    return CMTimeMakeWithSeconds(duration, 600);
}


- (NSInteger)getRangeViewIndexAtOffsetX:(CGFloat)offsetX {
    __block CGFloat offset = offsetX + self.scrollView.contentInset.left;
    __block NSInteger index = 0;
    NSTimeInterval widthPerSeconds = [self timelineWidthPerSeconds];
    [self.rangeViews enumerateObjectsUsingBlock:^(VIRangeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSTimeInterval contentDuration = CMTimeGetSeconds(CMTimeSubtract(obj.endTime, obj.startTime));
        CGFloat width = contentDuration * widthPerSeconds;
        if (offset <= width) {
            index = idx;
            *stop = YES;
        } else {
            offset -= width;
        }
    }];
    
    return index;
}

- (void)adjustScrollViewOffsetAtTime:(CMTime)time {
    if (!CMTIME_IS_VALID(time)) {
        return;
    }
    CGFloat offsetX = [self calculateOffsetXAtTime:time];
    self.previousScrollViewDelegate = self.scrollView.delegate;
    self.scrollView.delegate = nil;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    [self displayRangeViewsIfNeed];
    self.scrollView.delegate = self.previousScrollViewDelegate;
}

- (void)scrollToStartOfRangeView:(VIRangeView *)rangeView animated:(BOOL)animated completion:(void(^)(void))completion {
    CGPoint center = [rangeView convertPoint:rangeView.leftEarView.center toView:self];
    CGPoint lineCenter = CGPointMake(center.x + rangeView.leftEarView.bounds.size.width * 0.5, center.y);
    CGFloat centerX = self.bounds.size.width * 0.5;
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x -= centerX - lineCenter.x;
    [self scrollToContentOffset:contentOffset animated:animated completion:completion];
}

- (void)scrollToEndOfRangeView:(VIRangeView *)rangeView animated:(BOOL)animated completion:(void(^)(void))completion {
    CGPoint center = [rangeView convertPoint:rangeView.rightEarView.center toView:self];
    CGPoint lineCenter = CGPointMake(center.x - rangeView.rightEarView.bounds.size.width * 0.5, center.y);
    CGFloat centerX = self.bounds.size.width * 0.5;
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x -= centerX - lineCenter.x;
    [self scrollToContentOffset:contentOffset animated:animated completion:completion];
}

- (void)scrollToContentOffset:(CGPoint)contentOffset animated:(BOOL)animated completion:(void(^)(void))completion {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = contentOffset;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    } else {
        self.scrollView.contentOffset = contentOffset;
        if (completion) {
            completion();
        }
    }
}

#pragma mark - Helper

- (BOOL)isActived {
    BOOL isActived = NO;
    
    for (VIRangeView *rangeView in self.rangeViews) {
        if (rangeView.isActived) {
            isActived = YES;
            break;
        }
    }
    
    return isActived;
}

- (void)resignVideoRangeView {
    if ([self isActived]) {
        [self.delegate timelineView:self didChangeActive:NO];
    }
    [self.rangeViews enumerateObjectsUsingBlock:^(VIRangeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isActived) {
            [obj inactiveEarAnimated:YES];
        }
    }];
}

- (void)removeAllRangeViews {
    [self.rangeViews enumerateObjectsUsingBlock:^(VIRangeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.rangeViews removeAllObjects];
}

- (void)displayRangeViewsIfNeed {
    NSArray<VIRangeView *> *visiableRangeViews = [self fetchVisiableRangeViews];
    [visiableRangeViews enumerateObjectsUsingBlock:^(VIRangeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.contentView updateDataIfNeed];
    }];
}

- (NSArray<VIRangeView *> *)fetchVisiableRangeViews {
    NSMutableArray *rangeViews = [NSMutableArray array];
    [self.rangeViews enumerateObjectsUsingBlock:^(VIRangeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = [obj.superview convertRect:obj.frame toView:self.scrollView];
        BOOL intersects = CGRectIntersectsRect(self.scrollView.bounds, rect);
        if (intersects) {
            [rangeViews addObject:obj];
        }
    }];
    return rangeViews;
}



#pragma mark - VIRangeViewDelegate

- (void)rangeView:(VIRangeView *)rangeView didChangeActive:(BOOL)isActive {
    [self.rangeViewDelegate rangeView:rangeView didChangeActive:isActive];
}

- (void)rangeViewBeginUpdateLeft:(VIRangeView *)rangeView {
    self.previousScrollViewDelegate = self.scrollView.delegate;
    self.scrollView.delegate = nil;
    [self.rangeViewDelegate rangeViewBeginUpdateLeft:rangeView];
}

- (void)rangeView:(VIRangeView *)rangeView updateLeftOffset:(CGFloat)offset isAuto:(BOOL)isAuto {
    [self.rangeViewDelegate rangeView:rangeView updateLeftOffset:offset isAuto:isAuto];
    
    CGPoint center = [rangeView convertPoint:rangeView.leftEarView.center toView:self];
    self.centerLineView.center = CGPointMake(center.x + rangeView.leftEarView.bounds.size.width * 0.5, center.y);
    
    if (isAuto) {
        return;
    }
    
    UIEdgeInsets inset = self.scrollView.contentInset;
    inset.left = self.scrollView.frame.size.width;
    self.scrollView.contentInset = inset;
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x -= offset;
    [self.scrollView setContentOffset:contentOffset animated:NO];
}

- (void)rangeViewEndUpdateLeftOffset:(VIRangeView *)rangeView {
    
    UIEdgeInsets inset = self.scrollView.contentInset;
    inset.left = inset.right;
    
    CGFloat centerX = self.bounds.size.width * 0.5;
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x -= centerX - self.centerLineView.center.x;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentInset = inset;
        self.scrollView.contentOffset = contentOffset;
        self.centerLineView.center = CGPointMake(centerX, self.bounds.size.height * 0.5);
    } completion:^(BOOL finished) {
        self.scrollView.delegate = self.previousScrollViewDelegate;
        [self.rangeViewDelegate rangeViewEndUpdateLeftOffset:rangeView];
    }];
}

- (void)rangeViewBeginUpdateRight:(VIRangeView *)rangeView {
    self.previousScrollViewDelegate = self.scrollView.delegate;
    self.scrollView.delegate = nil;
    [self.rangeViewDelegate rangeViewBeginUpdateRight:rangeView];
}

- (void)rangeView:(VIRangeView *)rangeView updateRightOffset:(CGFloat)offset isAuto:(BOOL)isAuto {
    [self.rangeViewDelegate rangeView:rangeView updateRightOffset:offset isAuto:isAuto];
    
    CGPoint center = [rangeView convertPoint:rangeView.rightEarView.center toView:self];
    self.centerLineView.center = CGPointMake(center.x - rangeView.rightEarView.frame.size.width * 0.5, center.y);
    if (isAuto) {
        CGPoint contentOffset = self.scrollView.contentOffset;
        contentOffset.x += offset;
        [self.scrollView setContentOffset:contentOffset animated: false];
    } else {
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.right = self.scrollView.frame.size.width;
        self.scrollView.contentInset = inset;
    }
}

- (void)rangeViewEndUpdateRightOffset:(VIRangeView *)rangeView {
    
    UIEdgeInsets inset = self.scrollView.contentInset;
    inset.right = inset.left;
    
    CGFloat centerX = self.bounds.size.width * 0.5;
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x -= centerX - self.centerLineView.center.x;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentInset = inset;
        self.scrollView.contentOffset = contentOffset;
        self.centerLineView.center = CGPointMake(centerX, self.bounds.size.height * 0.5);
    } completion:^(BOOL finished) {
        self.scrollView.delegate = self.previousScrollViewDelegate;
        [self.rangeViewDelegate rangeViewEndUpdateRightOffset:rangeView];
    }];
}

@end
