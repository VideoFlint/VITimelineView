//
//  VIRangeContentAssetImageDataSource.h
//  VITimelineViewDemo
//
//  Created by Vito on 2018/11/30.
//  Copyright © 2018 vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VIVideoRangeContentView.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VIRangeContentAssetImageDataSource : NSObject <VIVideoRangeContentViewDataSource>

@property (nonatomic, strong, readonly) AVAsset *asset;

- (instancetype)initWithAsset:(AVAsset *)asset imageSize:(CGSize)imageSize widthPerSecond:(CGFloat)widthPerSecond;

@property (nonatomic) CGSize imageSize;
@property (nonatomic) CGFloat widthPerSecond;

@end

NS_ASSUME_NONNULL_END
