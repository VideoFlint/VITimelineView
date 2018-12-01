//
//  VIRangeView.m
//  vito
//
//  Created by Vito on 2018/8/31.
//  Copyright © 2018 vito. All rights reserved.
//

#import "VIRangeView.h"
#import "VIAutoScroller.h"
#import "UIView+ConstraintHolder.h"

@interface VIRangeView()

@property (nonatomic, strong) UIView *contentContainerView;

@property (nonatomic, strong, readwrite) VIRangeEarView *leftEarView;
@property (nonatomic, strong, readwrite) VIRangeEarView *rightEarView;
@property (nonatomic, strong, readwrite) UIView *backgroundView;
@property (nonatomic, strong, readwrite) UIView *coverView;
@property (nonatomic, strong, readwrite) UIImageView *coverTopLineView;
@property (nonatomic, strong, readwrite) UIImageView *coverBottomLineView;

// Helper
@property (nonatomic, strong) VIAutoScroller *autoScroller;
@property (nonatomic) CGPoint panGesturePreviousTranslation;

@end

@implementation VIRangeView

#pragma mark - Life Cycle

- (instancetype)initWithContentView:(VIRangeContentView *)contentView startTime:(CMTime)startTime endTime:(CMTime)endTime {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _startTime = startTime;
        _endTime = endTime;
        _maxDuration = endTime;
        [self setContentView:contentView];
    }
    return self;
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
    _contentHeight = 45;
    _widthPerSecond = 50;
    _startTime = kCMTimeZero;
    _endTime = kCMTimeZero;
    _minDuration = CMTimeMake(600, 600);
    _maxDuration = kCMTimeIndefinite;
    _leftInsetDuration = kCMTimeZero;
    _rightInsetDuration = kCMTimeZero;
    _autoScroller = [VIAutoScroller new];
    _contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    
    UIView *backgroundView = [UIView new];
    backgroundView.userInteractionEnabled = NO;
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
    UIView *contentContainerView = [UIView new];
    contentContainerView.clipsToBounds = YES;
    contentContainerView.userInteractionEnabled = NO;
    contentContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:contentContainerView];
    self.contentContainerView = contentContainerView;
    
    VIRangeEarView *leftEarView = [VIRangeEarView new];
    leftEarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:leftEarView];
    self.leftEarView = leftEarView;
    
    VIRangeEarView *rightEarView = [VIRangeEarView new];
    rightEarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:rightEarView];
    self.rightEarView = rightEarView;
    
    
    UIView *coverView = [UIView new];
    coverView.translatesAutoresizingMaskIntoConstraints = NO;
    coverView.userInteractionEnabled = NO;
    coverView.clipsToBounds = NO;
    [self addSubview:coverView];
    self.coverView = coverView;
    
    UIImageView *coverTopLineView = [UIImageView new];
    coverTopLineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.coverView addSubview:coverTopLineView];
    self.coverTopLineView = coverTopLineView;
    
    UIImageView *coverBottomLineView = [UIImageView new];
    coverBottomLineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.coverView addSubview:coverBottomLineView];
    self.coverBottomLineView = coverBottomLineView;
    
    // Layout
    leftEarView.vi_constraints =
    @[[leftEarView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
      [leftEarView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [leftEarView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [leftEarView.widthAnchor constraintEqualToConstant:self.contentInset.left]
      ];
    [NSLayoutConstraint activateConstraints:leftEarView.vi_constraints];
    
    rightEarView.vi_constraints =
    @[[rightEarView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
      [rightEarView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [rightEarView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [rightEarView.widthAnchor constraintEqualToConstant:self.contentInset.right]
      ];
    [NSLayoutConstraint activateConstraints:rightEarView.vi_constraints];
    
    [NSLayoutConstraint activateConstraints:
     @[[backgroundView.leftAnchor constraintEqualToAnchor:leftEarView.rightAnchor],
       [backgroundView.topAnchor constraintEqualToAnchor:self.topAnchor],
       [backgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
       [backgroundView.rightAnchor constraintEqualToAnchor:rightEarView.leftAnchor]
       ]];
    
    contentContainerView.vi_constraints =
    @[[contentContainerView.leftAnchor constraintEqualToAnchor:leftEarView.rightAnchor],
      [contentContainerView.topAnchor constraintEqualToAnchor:self.topAnchor constant:self.contentInset.top],
      [contentContainerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-self.contentInset.bottom],
      [contentContainerView.rightAnchor constraintEqualToAnchor:rightEarView.leftAnchor]
      ];
    [NSLayoutConstraint activateConstraints:contentContainerView.vi_constraints];
    
    [NSLayoutConstraint activateConstraints:
     @[[coverView.leftAnchor constraintEqualToAnchor:leftEarView.rightAnchor],
       [coverView.topAnchor constraintEqualToAnchor:self.topAnchor],
       [coverView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
       [coverView.rightAnchor constraintEqualToAnchor:rightEarView.leftAnchor]
       ]];
    
    [NSLayoutConstraint activateConstraints:
     @[[coverTopLineView.leftAnchor constraintEqualToAnchor:coverView.leftAnchor],
       [coverTopLineView.bottomAnchor constraintEqualToAnchor:coverView.topAnchor],
       [coverTopLineView.rightAnchor constraintEqualToAnchor:coverView.rightAnchor]
       ]];
    
    [NSLayoutConstraint activateConstraints:
     @[[coverBottomLineView.leftAnchor constraintEqualToAnchor:coverView.leftAnchor],
       [coverBottomLineView.topAnchor constraintEqualToAnchor:coverView.bottomAnchor],
       [coverBottomLineView.rightAnchor constraintEqualToAnchor:coverView.rightAnchor]
       ]];
    
    // Gesture
    UIPanGestureRecognizer *panLeftGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEarAction:)];
    [leftEarView addGestureRecognizer:panLeftGesture];
    UIPanGestureRecognizer *panRightGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEarAction:)];
    [rightEarView addGestureRecognizer:panRightGesture];
    
    [self inactiveEarAnimated:NO];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect frame = self.bounds;
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 15, 15, 10);
    CGRect extendFrame = CGRectMake(-insets.left, -insets.top, frame.size.width + insets.left + insets.right, frame.size.height + insets.top + insets.bottom);
    if (CGRectContainsPoint(extendFrame, point)) {
        return YES;
    }
    
    return NO;
}

- (CGSize)intrinsicContentSize {
    CGFloat width = [self contentWidth] + self.contentInset.left + self.contentInset.right;
    return CGSizeMake(width, self.contentHeight);
}

#pragma mark - Setter

- (void)setContentHeight:(CGFloat)contentHeight {
    [self willChangeValueForKey:@"contentHeight"];
    _contentHeight = contentHeight;
    [self didChangeValueForKey:@"contentHeight"];
    [self invalidateIntrinsicContentSize];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    
    [NSLayoutConstraint deactivateConstraints:self.contentContainerView.vi_constraints];
    self.contentContainerView.vi_constraints =
    @[[self.contentContainerView.leftAnchor constraintEqualToAnchor:self.leftEarView.rightAnchor],
      [self.contentContainerView.topAnchor constraintEqualToAnchor:self.topAnchor constant:self.contentInset.top],
      [self.contentContainerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-self.contentInset.bottom],
      [self.contentContainerView.rightAnchor constraintEqualToAnchor:self.rightEarView.leftAnchor]
      ];
    [NSLayoutConstraint activateConstraints:self.contentContainerView.vi_constraints];
    
    [NSLayoutConstraint deactivateConstraints:self.leftEarView.vi_constraints];
    self.leftEarView.vi_constraints =
    @[[self.leftEarView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
      [self.leftEarView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.leftEarView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [self.leftEarView.widthAnchor constraintEqualToConstant:self.contentInset.left]
      ];
    [NSLayoutConstraint activateConstraints:self.leftEarView.vi_constraints];
    
    [NSLayoutConstraint deactivateConstraints:self.rightEarView.vi_constraints];
    self.rightEarView.vi_constraints =
    @[[self.rightEarView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
      [self.rightEarView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.rightEarView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [self.rightEarView.widthAnchor constraintEqualToConstant:self.contentInset.right]
      ];
    [NSLayoutConstraint activateConstraints:self.rightEarView.vi_constraints];
}

- (void)setStartTime:(CMTime)startTime {
    [self willChangeValueForKey:@"startTime"];
    _startTime = startTime;
    [self didChangeValueForKey:@"startTime"];
    [self timeDidChange];
    [self invalidateIntrinsicContentSize];
}

- (void)setEndTime:(CMTime)endTime {
    [self willChangeValueForKey:@"endTime"];
    _endTime = endTime;
    [self didChangeValueForKey:@"endTime"];
    [self timeDidChange];
    [self invalidateIntrinsicContentSize];
}

- (void)setWidthPerSecond:(CGFloat)widthPerSecond {
    [self willChangeValueForKey:@"widthPerSecond"];
    _widthPerSecond = widthPerSecond;
    [self didChangeValueForKey:@"widthPerSecond"];
    [self invalidateIntrinsicContentSize];
}

- (void)setContentView:(VIRangeContentView *)contentView {
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView removeFromSuperview];
    _contentView = contentView;
    [self.contentContainerView addSubview:contentView];
    
    CGFloat xOffset = (CMTimeGetSeconds(self.startTime) + CMTimeGetSeconds(self.leftInsetDuration)) * self.widthPerSecond;
    contentView.vi_constraints =
    @[[contentView.topAnchor constraintEqualToAnchor:self.contentContainerView.topAnchor],
      [contentView.bottomAnchor constraintEqualToAnchor:self.contentContainerView.bottomAnchor],
      [contentView.leftAnchor constraintEqualToAnchor:self.contentContainerView.leftAnchor constant:xOffset], // 处理 rangeView 的间距
      [contentView.rightAnchor constraintEqualToAnchor:self.contentContainerView.rightAnchor constant:self.contentInset.right] // 处理 rangeView 的间距
    ];
    [NSLayoutConstraint activateConstraints:contentView.vi_constraints];
}

#pragma mark - Public

- (CGFloat)contentWidth {
    CMTime duration = CMTimeSubtract(self.endTime, self.startTime);
    CGFloat width = CMTimeGetSeconds(duration) * self.widthPerSecond;
    width = width - self.leftContentWidthInset - self.rightContentWidthInset; // 处理 rangeView 的间距
    return width;
}

- (BOOL)isActived {
    return self.leftEarView.userInteractionEnabled;
}

- (void)activeEarAnimated:(BOOL)animated {
    // Move to top layer
    [self.superview addSubview:self];
    
    self.leftEarView.userInteractionEnabled = YES;
    self.rightEarView.userInteractionEnabled = YES;
    
    if ([self.delegate respondsToSelector:@selector(rangeView:didChangeActive:)]) {
        [self.delegate rangeView:self didChangeActive:self.isActived];
    }
    
    void(^operations)(void) = ^{
        self.coverView.alpha = 1.0;
        self.backgroundView.alpha = 1.0;
        self.leftEarView.alpha = 1.0;
        self.rightEarView.alpha = 1.0;
    };
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:operations completion:nil];
    } else {
        operations();
    }
}

- (void)inactiveEarAnimated:(BOOL)animated {
    self.leftEarView.userInteractionEnabled = NO;
    self.rightEarView.userInteractionEnabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(rangeView:didChangeActive:)]) {
        [self.delegate rangeView:self didChangeActive:self.isActived];
    }
    
    void(^operations)(void) = ^{
        self.coverView.alpha = 0.0;
        self.backgroundView.alpha = 0.0;
        self.leftEarView.alpha = 0.0;
        self.rightEarView.alpha = 0.0;
    };
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:operations completion:nil];
    } else {
        operations();
    }
}

#pragma mark - Gesture Action Helper

- (void)panEarAction:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (gesture.view == self.rightEarView) {
            [self.delegate rangeViewBeginUpdateRight:self];
        } else {
            [self.delegate rangeViewBeginUpdateLeft:self];
        }
    }
    
    CGPoint windowLocation = [[gesture.view superview] convertPoint:gesture.view.center toView:self.window];
    CGRect windowBounds = self.window.bounds;
    BOOL shouldAutoScroll = (windowLocation.x < self.autoScroller.autoScrollInset && self.panGesturePreviousTranslation.x < 0) ||
    (windowLocation.x > (windowBounds.size.width - self.autoScroller.autoScrollInset) && self.panGesturePreviousTranslation.x > 0);
    if (shouldAutoScroll) {
        [self autoScrollEar:gesture];
        [self.autoScroller.triggerMachine start];
    } else {
        [self.autoScroller.triggerMachine pause];
        [self.autoScroller cleanUpAutoScrollValues];
    }
    
    CGPoint translation = [gesture translationInView:gesture.view];
    BOOL outOfControl = (windowLocation.x < self.autoScroller.earEdgeInset && self.panGesturePreviousTranslation.x > translation.x) ||
    (windowLocation.x > (windowBounds.size.width - self.autoScroller.earEdgeInset) && self.panGesturePreviousTranslation.x < translation.x);
    if (!outOfControl) {
        [self normalPanEar:gesture];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self.autoScroller cleanUpAutoScrollValues];
        if (gesture.view == self.rightEarView) {
            [self.delegate rangeViewEndUpdateRightOffset:self];
        } else {
            [self.delegate rangeViewEndUpdateLeftOffset:self];
        }
    }
}

- (void)autoScrollEar:(UIPanGestureRecognizer *)gesture {
    CGPoint windowLocation = [gesture.view.superview convertPoint:gesture.view.center toView:self.window];
    CGRect windowBounds = self.window.bounds;
    
    if (windowLocation.x > (windowBounds.size.width - self.autoScroller.autoScrollInset)) {
        CGFloat scrollInset = self.autoScroller.autoScrollInset - (windowBounds.size.width - windowLocation.x);
        self.autoScroller.autoScrollSpeed = MIN(scrollInset, self.autoScroller.autoScrollInset) * 0.1;
    } else if (windowLocation.x < self.autoScroller.autoScrollInset) {
        CGFloat scrollInset = self.autoScroller.autoScrollInset - windowLocation.x;
        self.autoScroller.autoScrollSpeed = -MIN(scrollInset, self.autoScroller.autoScrollInset) * 0.1;
    }
    
    if (gesture.view == self.rightEarView) {
        if (self.autoScroller.autoScrollType != VIAutoScrollerTypeRight) {
            self.autoScroller.autoScrollType = VIAutoScrollerTypeRight;
            __weak typeof(self)weakSelf = self;
            self.autoScroller.triggerMachine.triggerOperation = ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (!strongSelf) { return; }
                [strongSelf expandRightEarWithWidth:strongSelf.autoScroller.autoScrollSpeed isAuto:YES];
            };
        }
    } else {
        if (self.autoScroller.autoScrollType != VIAutoScrollerTypeLeft) {
            self.autoScroller.autoScrollType = VIAutoScrollerTypeLeft;
            __weak typeof(self)weakSelf = self;
            self.autoScroller.triggerMachine.triggerOperation = ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (!strongSelf) { return; }
                [strongSelf expandLeftEarWithWidth:strongSelf.autoScroller.autoScrollSpeed isAuto:YES];
            };
        }
    }
}

- (void)normalPanEar:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:gesture.view];
    CGFloat offset = translation.x - self.panGesturePreviousTranslation.x;
    CGFloat actulOffset = offset;
    if (gesture.view == self.rightEarView) {
        actulOffset = [self expandRightEarWithWidth:offset isAuto:NO];
    } else {
        actulOffset = -[self expandLeftEarWithWidth:offset isAuto:NO];
    }
    
    CGPoint previousTranslation = self.panGesturePreviousTranslation;
    previousTranslation.x += actulOffset;
    self.panGesturePreviousTranslation = previousTranslation;
    
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        self.panGesturePreviousTranslation = CGPointZero;
    }
}

- (CGFloat)expandLeftEarWithWidth:(CGFloat)width isAuto:(BOOL)isAuto {
    CGFloat previousWidth = [self contentWidth];
    [self expandWithContentWidth:-width isLeft:YES];
    CGFloat offset = [self contentWidth] - previousWidth;
    [self invalidateIntrinsicContentSize];
    [self.delegate rangeView:self updateLeftOffset:-offset isAuto:isAuto];
    self.leftEarView.imageView.highlighted = [self isReachHead];
    //[self changeTimeLabelIsLeft:YES];
    return offset;
}

- (CGFloat)expandRightEarWithWidth:(CGFloat)width isAuto:(BOOL)isAuto {
    CGFloat previousWidth = [self contentWidth];
    [self expandWithContentWidth:width isLeft:NO];
    CGFloat offset = [self contentWidth] - previousWidth;
    [self invalidateIntrinsicContentSize];
    [self.delegate rangeView:self updateRightOffset:offset isAuto:isAuto];
    self.leftEarView.imageView.highlighted = [self isReachEnd];
    //[self changeTimeLabelIsLeft:NO];
    return offset;
}

- (BOOL)isReachHead {
    if (CMTimeCompare(self.startTime, CMTimeMake(1, 30)) <= 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isReachEnd {
    CMTime maxDuration = CMTimeSubtract(self.maxDuration, CMTimeMake(1, 30));
    if (CMTimeCompare(self.endTime, maxDuration) >= 0) {
        return YES;
    }
    return NO;
}

- (void)expandWithContentWidth:(CGFloat)width isLeft:(BOOL)isLeft {
    NSTimeInterval seconds = width / self.widthPerSecond;
    if (isLeft) {
        NSTimeInterval startSeconds = MAX(0, CMTimeGetSeconds(self.startTime) - seconds);
        startSeconds = MIN(startSeconds, CMTimeGetSeconds(self.endTime) - CMTimeGetSeconds(self.minDuration));
        self.startTime = CMTimeMakeWithSeconds(startSeconds, 600);
    } else {
        NSTimeInterval maxSeconds = CMTimeGetSeconds(self.maxDuration);
        NSTimeInterval endSeconds = MAX(MIN(CMTimeGetSeconds(self.endTime) + seconds, maxSeconds), CMTimeGetSeconds(self.startTime) + CMTimeGetSeconds(self.minDuration));
        self.endTime = CMTimeMakeWithSeconds(endSeconds, 600);
    }
}

- (void)timeDidChange {
    [NSLayoutConstraint deactivateConstraints:self.contentView.vi_constraints];
    CGFloat xOffset = (CMTimeGetSeconds(self.startTime) + CMTimeGetSeconds(self.leftInsetDuration)) * self.widthPerSecond;
    self.contentView.vi_constraints =
    @[[self.contentView.topAnchor constraintEqualToAnchor:self.contentContainerView.topAnchor],
      [self.contentView.bottomAnchor constraintEqualToAnchor:self.contentContainerView.bottomAnchor],
      [self.contentView.leftAnchor constraintEqualToAnchor:self.contentContainerView.leftAnchor constant:-xOffset], // 处理 rangeView 的间距
      [self.contentView.rightAnchor constraintEqualToAnchor:self.contentContainerView.rightAnchor constant:self.contentInset.right] // 处理 rangeView 的间距
      ];
    [NSLayoutConstraint activateConstraints:self.contentView.vi_constraints];
}

@end
