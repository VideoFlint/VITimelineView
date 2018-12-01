//
//  ViewController.m
//  VITimelineViewDemo
//
//  Created by Vito on 2018/11/15.
//  Copyright © 2018 vito. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VITimelineView+Creator.h"

@interface ViewController () <VIRangeViewDelegate, VITimelineViewDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"bamboo" withExtension:@"mp4"];
    AVAsset *asset1 = [AVAsset assetWithURL:url1];
    
    NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"water" withExtension:@"mp4"];
    AVAsset *asset2 = [AVAsset assetWithURL:url2];
    
    CGFloat widthPerSecond = 40;
    CGSize imageSize = CGSizeMake(30, 45);
    
    VITimelineView *timelineView =
    [VITimelineView timelineViewWithAssets:@[asset1, asset2]
                                 imageSize:imageSize
                            widthPerSecond:widthPerSecond];
    timelineView.delegate = self;
    timelineView.rangeViewDelegate = self;
    timelineView.backgroundColor = [UIColor colorWithRed:0.11 green:0.15 blue:0.34 alpha:1.00];
    timelineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:timelineView];
    [timelineView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [timelineView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [timelineView.heightAnchor constraintEqualToConstant:100].active = YES;
    [timelineView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    
    CIImage *ciimage = [CIImage imageWithColor:[CIColor colorWithRed:0.30 green:0.59 blue:0.70 alpha:1]];
    CGImageRef cgimage = [[CIContext context] createCGImage:ciimage fromRect:CGRectMake(0, 0, 1, 60)];
    UIImage *image = [UIImage imageWithCGImage:cgimage];
    timelineView.centerLineView.image = image;
    [timelineView.rangeViews enumerateObjectsUsingBlock:^(VIRangeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.clipsToBounds = YES;
        obj.layer.cornerRadius = 4;
        obj.leftEarView.backgroundColor = [UIColor colorWithRed:0.72 green:0.73 blue:0.77 alpha:1.00];
        obj.rightEarView.backgroundColor = [UIColor colorWithRed:0.72 green:0.73 blue:0.77 alpha:1.00];
        obj.backgroundView.backgroundColor = [UIColor colorWithRed:0.72 green:0.73 blue:0.77 alpha:1.00];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)rangeView:(VIRangeView *)rangeView didChangeActive:(BOOL)isActive {
    NSLog(@"rangeView:%@ didchangeActive: %@", rangeView, @(isActive));
}

- (void)rangeView:(VIRangeView *)rangeView updateLeftOffset:(CGFloat)offset isAuto:(BOOL)isAuto {
    NSLog(@"2.updateLeftOffset rangeView offset: %@ width: %@", @(offset), @(rangeView.contentWidth));
}

- (void)rangeView:(VIRangeView *)rangeView updateRightOffset:(CGFloat)offset isAuto:(BOOL)isAuto {
    NSLog(@"2.updateRightOffset rangeView offset: %@ width: %@", @(offset), @(rangeView.contentWidth));
}

- (void)rangeViewBeginUpdateLeft:(VIRangeView *)rangeView {
    NSLog(@"1.rangeViewBeginUpdateLeft rangeView width: %@", @(rangeView.contentWidth));
}

- (void)rangeViewBeginUpdateRight:(VIRangeView *)rangeView {
    NSLog(@"1.rangeViewBeginUpdateRight rangeView width: %@", @(rangeView.contentWidth));
}

- (void)rangeViewEndUpdateLeftOffset:(VIRangeView *)rangeView {
    NSLog(@"3.rangeViewEndUpdateLeftOffset rangeView width: %@", @(rangeView.contentWidth));
}

- (void)rangeViewEndUpdateRightOffset:(VIRangeView *)rangeView {
    NSLog(@"3.rangeViewEndUpdateRightOffset rangeView width: %@", @(rangeView.contentWidth));
}

- (void)timelineView:(nonnull VITimelineView *)view didChangeActive:(BOOL)isActive {
    NSLog(@"timelineview didchangeActive: %@", @(isActive));
}


@end
