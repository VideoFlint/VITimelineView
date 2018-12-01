//
//  VIRangeView+Creator.m
//  VITimelineViewDemo
//
//  Created by Vito on 2018/11/30.
//  Copyright © 2018 vito. All rights reserved.
//

#import "VIRangeView+Creator.h"
#import "VIRangeContentAssetImageDataSource.h"
#import "VIVideoRangeContentView.h"

@implementation VIRangeView (Creator)

+ (instancetype)imageRangeViewWithAsset:(AVAsset *)asset imageSize:(CGSize)imageSize {
    VIRangeView *rangeView = [[VIRangeView alloc] init];
    VIRangeContentAssetImageDataSource *dataSource =
    [[VIRangeContentAssetImageDataSource alloc] initWithAsset:asset
                                                    imageSize:imageSize
                                               widthPerSecond:rangeView.widthPerSecond];
    
    VIVideoRangeContentView *videoRangeContentView = [[VIVideoRangeContentView alloc] init];
    videoRangeContentView.dataSource = dataSource;
    videoRangeContentView.imageSize = imageSize;
    
    rangeView.contentView = videoRangeContentView;
    rangeView.startTime = kCMTimeZero;
    rangeView.endTime = asset.duration;
    rangeView.maxDuration = asset.duration;
    
    UIEdgeInsets insets = rangeView.contentInset;
    insets.top = 1;
    insets.bottom = 1;
    rangeView.contentInset = insets;
    
    return rangeView;
}

@end
