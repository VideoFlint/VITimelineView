//
//  UIView+ConstraintHolder.h
//  VITimelineViewDemo
//
//  Created by Vito on 2018/11/20.
//  Copyright © 2018 vito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ConstraintHolder)

- (void)setVi_constraints:(NSArray *)constraints;
- (NSArray *)vi_constraints;

- (void)updateConstraintWithAttribute:(NSLayoutAttribute)attribute maker:(NSLayoutConstraint *(^)(void))maker;
- (void)updateLeftConstraint:(NSLayoutConstraint *(^)(void))maker;
- (void)updateRightConstraint:(NSLayoutConstraint *(^)(void))maker;

@end

@implementation UIView (ConstraintHolder)

static const char VIConstaintsKey = 'c';
- (void)setVi_constraints:(NSArray<NSLayoutConstraint *> *)constraints {
    objc_setAssociatedObject(self, &VIConstaintsKey, constraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<NSLayoutConstraint *> *)vi_constraints {
    return objc_getAssociatedObject(self, &VIConstaintsKey);
}

- (void)updateConstraintWithAttribute:(NSLayoutAttribute)attribute maker:(NSLayoutConstraint *(^)(void))maker {
    NSLayoutConstraint *constraint;
    for (NSLayoutConstraint *c in self.vi_constraints) {
        if (c.firstItem == self && c.firstAttribute == attribute) {
            constraint = c;
            break;
        }
    }
    [NSLayoutConstraint deactivateConstraints:@[constraint]];
    
    NSMutableArray *mutableConstraints = [self.vi_constraints mutableCopy];
    [mutableConstraints removeObject:constraint];
    
    if (maker) {
        NSLayoutConstraint *newConstraint = maker();
        if (newConstraint.firstItem == self && newConstraint.firstAttribute == attribute) {
            [mutableConstraints addObject:constraint];
            [NSLayoutConstraint activateConstraints:@[newConstraint]];
        }
    }
    self.vi_constraints = mutableConstraints;
}

- (void)updateLeftConstraint:(NSLayoutConstraint *(^)(void))maker {
    [self updateConstraintWithAttribute:NSLayoutAttributeLeft maker:maker];
}

- (void)updateRightConstraint:(NSLayoutConstraint *(^)(void))maker {
    [self updateConstraintWithAttribute:NSLayoutAttributeRight maker:maker];
}

@end

NS_ASSUME_NONNULL_END
