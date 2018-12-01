//
//  VIRangeView+Creator.h
//  VITimelineViewDemo
//
//  Created by Vito on 2018/11/30.
//  Copyright © 2018 vito. All rights reserved.
//

#import "VIRangeView.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VIRangeView (Creator)

+ (instancetype)imageRangeViewWithAsset:(AVAsset *)asset imageSize:(CGSize)imageSize;

@end

NS_ASSUME_NONNULL_END
