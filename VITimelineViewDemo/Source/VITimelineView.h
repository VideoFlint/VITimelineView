//
//  VITimelineView.h
//  vito
//
//  Created by Vito on 2018/8/28.
//  Copyright © 2018 vito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIRangeView.h"

@class VITimelineView, VIEditPlayButton;

NS_ASSUME_NONNULL_BEGIN

@protocol VITimelineViewDelegate <NSObject>

- (void)timelineView:(VITimelineView *)view didChangeActive:(BOOL)isActive;

@end

@interface VITimelineView : UIView

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIImageView *centerLineView;

@property (nonatomic, weak) id<VITimelineViewDelegate> delegate;
@property (nonatomic, weak) id<VIRangeViewDelegate> rangeViewDelegate;

@property (nonatomic, strong, readonly) NSMutableArray<VIRangeView *> *rangeViews;
- (void)reloadWithRangeViews:(NSArray<VIRangeView *> *)rangeViews;
- (void)insertRangeView:(VIRangeView *)view atIndex:(NSInteger)index;
- (void)removeRangeViewAtIndex:(NSInteger)index animated:(BOOL)animated completion:(void(^)(void))completion;
- (void)removeCurrentActivedRangeViewCompletion:(void(^)(void))completion;

@property (nonatomic) CGFloat rangeViewLeftInset;
@property (nonatomic) CGFloat rangeViewRightInset;
@property (nonatomic) CGFloat contentWidthPerSecond;


// 真实的 widthPerSeconds, 和 contentWidthPerSecond 的区别在于，会用上 rangeViewLeftInset 重新计算
- (CGFloat)timelineWidthPerSeconds;
- (void)adjustScrollViewOffsetAtTime:(CMTime)time;

- (void)scrollToStartOfRangeView:(VIRangeView *)rangeView animated:(BOOL)animated completion:(nullable void(^)(void))completion;
- (void)scrollToEndOfRangeView:(VIRangeView *)rangeView animated:(BOOL)animated completion:(nullable void(^)(void))completion;
- (void)scrollToContentOffset:(CGPoint)contentOffset animated:(BOOL)animated completion:(void(^)(void))completion;

- (CGFloat)calculateOffsetXAtTime:(CMTime)time;
- (NSInteger)getRangeViewIndexAtTime:(CMTime)time;
- (CMTime)calculateTimeAtOffsetX:(CGFloat)offsetX;
- (NSInteger)getRangeViewIndexAtOffsetX:(CGFloat)offsetX;

- (void)resignVideoRangeView;

@end

NS_ASSUME_NONNULL_END
