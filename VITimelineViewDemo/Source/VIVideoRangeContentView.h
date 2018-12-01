//
//  VIVideoRangeContentView.h
//  vito
//
//  Created by Vito on 2018/8/31.
//  Copyright © 2018 vito. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreMedia;
#import "VIRangeContentView.h"

@class VIVideoRangeContentView;

@protocol VIVideoRangeContentViewDataSource <NSObject>

- (NSInteger)videoRangeContentViewNumberOfImages:(VIVideoRangeContentView *)view;
- (UIImage *)videoRangeContent:(VIVideoRangeContentView *)view imageAtIndex:(NSInteger)index preferredSize:(CGSize)size;

@optional

- (BOOL)videoRangeContent:(VIVideoRangeContentView *)view hasCacheAtIndex:(NSInteger)index;

@end

@interface VIVideoRangeContentView : VIRangeContentView

@property (nonatomic, strong) NSOperationQueue *loadImageQueue;

@property (nonatomic, strong) id<VIVideoRangeContentViewDataSource> dataSource;
@property (nonatomic) CGSize imageSize;
@property (nonatomic) NSInteger preloadCount;

@end
