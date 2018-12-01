//
//  VIDisplayTriggerMachine.m
//  vito
//
//  Created by Vito on 2018/8/31.
//  Copyright © 2018 vito. All rights reserved.
//

#import "VIDisplayTriggerMachine.h"
#import <QuartzCore/QuartzCore.h>


@interface VIDisplayTriggerObject: NSObject
@property (nonatomic, copy) TriggerOperation triggerOperation;
@end

@implementation VIDisplayTriggerObject

- (void)trigger {
    if (self.triggerOperation) {
        self.triggerOperation();
    }
}

@end

@interface VIDisplayTriggerMachine()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) VIDisplayTriggerObject *triggerObject;

@end

@implementation VIDisplayTriggerMachine

- (void)dealloc {
    [_displayLink invalidate];
}

- (instancetype)initWithTriggerOperation:(TriggerOperation)triggerOperation
{
    self = [super init];
    if (self) {
        _triggerObject.triggerOperation = triggerOperation;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _triggerObject = [VIDisplayTriggerObject new];
        
        _displayLink = [CADisplayLink displayLinkWithTarget:_triggerObject selector:@selector(trigger)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _preferredFramesPerSecond = 30;
    }
    return self;
}

- (void)setTriggerOperation:(TriggerOperation)triggerOperation {
    _triggerOperation = [triggerOperation copy];
    self.triggerObject.triggerOperation = triggerOperation;
}

- (void)setPreferredFramesPerSecond:(NSInteger)preferredFramesPerSecond {
    _preferredFramesPerSecond = preferredFramesPerSecond;
    if (@available(iOS 10.0, *)) {
        self.displayLink.preferredFramesPerSecond = preferredFramesPerSecond;
    } else {
        self.displayLink.frameInterval = preferredFramesPerSecond;
    }
}

- (void)start {
    self.displayLink.paused = NO;
}

- (void)pause {
    self.displayLink.paused = YES;
}

@end
