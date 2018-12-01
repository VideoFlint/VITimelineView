//
//  VIRangeEarView.m
//  vito
//
//  Created by Vito on 2018/8/31.
//  Copyright © 2018 vito. All rights reserved.
//

#import "VIRangeEarView.h"

@interface VIRangeEarView()

@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end

@implementation VIRangeEarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.clipsToBounds = NO;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:imageView];
    self.imageView = imageView;
    
    [imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect frame = self.bounds;
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 15, 15, 10);
    CGRect extendFrame = CGRectMake(-insets.left, -insets.top, frame.size.width + insets.left + insets.right, frame.size.height + insets.top + insets.bottom);
    if (CGRectContainsPoint(extendFrame, point)) {
        return YES;
    }
    
    return NO;
}

@end
