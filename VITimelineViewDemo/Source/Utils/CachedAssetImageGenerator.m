//
//  CachedAssetImageGenerator.m
//  VITimelineViewDemo
//
//  Created by Vito on 2018/11/29.
//  Copyright © 2018 vito. All rights reserved.
//

#import "CachedAssetImageGenerator.h"
#import <UIKit/UIKit.h>

@interface CachedAssetImageGenerator ()

@property (nonatomic, strong) NSMutableDictionary *imageCache;

@end

@implementation CachedAssetImageGenerator


- (instancetype)initWithAsset:(AVAsset *)asset {
    self = [super initWithAsset:asset];
    if (self) {
        _imageCache = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning:(NSNotification *)notification {
    [self.imageCache removeAllObjects];
}

- (CGImageRef)copyCGImageAtTime:(CMTime)requestedTime actualTime:(CMTime *)actualTime error:(NSError *__autoreleasing  _Nullable *)outError {
    NSString *key = [self keyAtTime:requestedTime];
    CGImageRef image = (__bridge CGImageRef)(self.imageCache[key]);
    if (!image) {
        image = [super copyCGImageAtTime:requestedTime actualTime:actualTime error:outError];
        self.imageCache[key] = (__bridge id _Nullable)(image);
    }
    
    return image;
}


- (BOOL)hasCacheAtTime:(CMTime)time {
    NSString *key = [self keyAtTime:time];
    return self.imageCache[key] != nil;
}

- (NSString *)keyAtTime:(CMTime)time {
    return [NSString stringWithFormat:@"time: %@, size: %@", @((NSInteger)(CMTimeGetSeconds(time) * 30)), NSStringFromCGSize(self.maximumSize)];
}

@end
