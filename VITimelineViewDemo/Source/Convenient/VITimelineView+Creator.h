//
//  VITimelineView+Creator.h
//  VITimelineViewDemo
//
//  Created by Vito on 2018/11/30.
//  Copyright © 2018 vito. All rights reserved.
//

#import "VITimelineView.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VITimelineView (Creator)

+ (instancetype)timelineViewWithAssets:(NSArray<AVAsset *> *)assets
                             imageSize:(CGSize)imageSize
                        widthPerSecond:(CGFloat)widthPerSecond;

@end

NS_ASSUME_NONNULL_END
