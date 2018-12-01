//
//  VIRangeView.h
//  vito
//
//  Created by Vito on 2018/8/31.
//  Copyright © 2018 vito. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreMedia;
#import "VIRangeContentView.h"
#import "VIRangeEarView.h"

@class VIRangeView;

@protocol VIRangeViewDelegate <NSObject>

- (void)rangeView:(VIRangeView *)rangeView didChangeActive:(BOOL)isActive;

- (void)rangeViewBeginUpdateLeft:(VIRangeView *)rangeView;
- (void)rangeView:(VIRangeView *)rangeView updateLeftOffset:(CGFloat)offset isAuto:(BOOL)isAuto;
- (void)rangeViewEndUpdateLeftOffset:(VIRangeView *)rangeView;

- (void)rangeViewBeginUpdateRight:(VIRangeView *)rangeView;
- (void)rangeView:(VIRangeView *)rangeView updateRightOffset:(CGFloat)offset isAuto:(BOOL)isAuto;
- (void)rangeViewEndUpdateRightOffset:(VIRangeView *)rangeView;

@end

@interface VIRangeView : UIView

- (instancetype)initWithContentView:(VIRangeContentView *)contentView startTime:(CMTime)startTime endTime:(CMTime)endTime;

@property (nonatomic, weak) id<VIRangeViewDelegate> delegate;

// Selection
@property (nonatomic, strong, readonly) VIRangeEarView *leftEarView;
@property (nonatomic, strong, readonly) VIRangeEarView *rightEarView;
@property (nonatomic, strong, readonly) UIView *backgroundView;
@property (nonatomic, strong, readonly) UIImageView *coverTopLineView;
@property (nonatomic, strong, readonly) UIImageView *coverBottomLineView;
@property (nonatomic, strong, readonly) UIView *disableCoverView;

// Content
@property (nonatomic) CGFloat contentHeight;
- (CGFloat)contentWidth;
@property (nonatomic) UIEdgeInsets contentInset;

@property (nonatomic, strong) VIRangeContentView *contentView;
@property (nonatomic) CMTime startTime;
@property (nonatomic) CMTime endTime;

@property (nonatomic) CGFloat widthPerSecond;

@property (nonatomic) CMTime minDuration;
@property (nonatomic) CMTime maxDuration;

// 裁剪掉部分时间，应用场景：设置了转场，可能会有部分时间被吃掉
@property (nonatomic) CMTime leftInsetDuration;
@property (nonatomic) CMTime rightInsetDuration;

// 处理 rangeView 的间距
@property (nonatomic) CGFloat leftContentWidthInset;
@property (nonatomic) CGFloat rightContentWidthInset;

@property (nonatomic, getter=isActived, readonly) BOOL active;
- (void)activeEarAnimated:(BOOL)animated;
- (void)inactiveEarAnimated:(BOOL)animated;

@end
