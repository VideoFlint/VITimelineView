//
//  CachedAssetImageGenerator.h
//  VITimelineViewDemo
//
//  Created by Vito on 2018/11/29.
//  Copyright © 2018 vito. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CachedAssetImageGenerator : AVAssetImageGenerator

- (BOOL)hasCacheAtTime:(CMTime)time;

@end

NS_ASSUME_NONNULL_END
