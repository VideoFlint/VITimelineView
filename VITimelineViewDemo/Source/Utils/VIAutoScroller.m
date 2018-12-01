//
//  VIAutoScroller.m
//  vito
//
//  Created by Vito on 2018/8/31.
//  Copyright © 2018 vito. All rights reserved.
//

#import "VIAutoScroller.h"

@interface VIAutoScroller()

@property (nonatomic, strong, readwrite) VIDisplayTriggerMachine *triggerMachine;

@end

@implementation VIAutoScroller

- (instancetype)init
{
    self = [super init];
    if (self) {
        _autoScrollInset = 100;
        _earEdgeInset = 30;
        _triggerMachine = [[VIDisplayTriggerMachine alloc] init];
    }
    return self;
}

- (void)cleanUpAutoScrollValues {
    self.autoScrollSpeed = 0;
    self.autoScrollType = VIAutoScrollerTypeNone;
    [self.triggerMachine pause];
}

@end
