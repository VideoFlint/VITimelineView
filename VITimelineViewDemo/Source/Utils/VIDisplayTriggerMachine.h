//
//  VIDisplayTriggerMachine.h
//  vito
//
//  Created by Vito on 2018/8/31.
//  Copyright © 2018 vito. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TriggerOperation)(void);

@interface VIDisplayTriggerMachine : NSObject

@property (nonatomic, copy) TriggerOperation triggerOperation;
- (instancetype)initWithTriggerOperation:(TriggerOperation)triggerOperation;

@property (nonatomic) NSInteger preferredFramesPerSecond;

- (void)start;
- (void)pause;

@end
