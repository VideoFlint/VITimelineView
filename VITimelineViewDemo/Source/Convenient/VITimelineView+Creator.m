//
//  VITimelineView+Creator.m
//  VITimelineViewDemo
//
//  Created by Vito on 2018/11/30.
//  Copyright © 2018 vito. All rights reserved.
//

#import "VITimelineView+Creator.h"
#import "VIRangeView+Creator.h"

@implementation VITimelineView (Creator)

+ (instancetype)timelineViewWithAssets:(NSArray<AVAsset *> *)assets
                             imageSize:(CGSize)imageSize
                        widthPerSecond:(CGFloat)widthPerSecond {
    VITimelineView *timelineView = [[VITimelineView alloc] init];
    timelineView.contentWidthPerSecond = widthPerSecond;
    timelineView.rangeViewLeftInset = 1;
    timelineView.rangeViewRightInset = 1;
    
    for (AVAsset *asset in assets) {
        VIRangeView *rangeView = [VIRangeView imageRangeViewWithAsset:asset imageSize:imageSize];
        [timelineView insertRangeView:rangeView atIndex:timelineView.rangeViews.count];
    }
    
    return timelineView;
}

@end
