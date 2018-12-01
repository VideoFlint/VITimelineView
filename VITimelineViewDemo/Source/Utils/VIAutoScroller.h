//
//  VIAutoScroller.h
//  vito
//
//  Created by Vito on 2018/8/31.
//  Copyright © 2018 vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "VIDisplayTriggerMachine.h"

typedef NS_ENUM(NSInteger, VIAutoScrollerType) {
    VIAutoScrollerTypeNone = 0,
    VIAutoScrollerTypeLeft,
    VIAutoScrollerTypeRight
};

@interface VIAutoScroller : NSObject

@property (nonatomic, strong, readonly) VIDisplayTriggerMachine *triggerMachine;

@property (nonatomic) VIAutoScrollerType autoScrollType;
@property (nonatomic) float autoScrollSpeed;
@property (nonatomic) CGFloat autoScrollInset;
@property (nonatomic) CGFloat earEdgeInset;

- (void)cleanUpAutoScrollValues;

@end
