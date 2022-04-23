//
//  NSLayoutConstraint+Multiplier.m
//  Fish
//
//  Created by Li Zhiping on 20/11/2017.
//  Copyright © 2017 Li Zhiping. All rights reserved.
//

#import "NSLayoutConstraint+Multiplier.h"
#import "TTGlobalUICommon.h"

@implementation NSLayoutConstraint (Multiplier)

- (instancetype)updateMultiplier:(CGFloat)multiplier {
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.firstItem attribute:self.firstAttribute relatedBy:self.relation toItem:self.secondItem attribute:self.secondAttribute multiplier:multiplier constant:self.constant];
    [newConstraint setPriority:self.priority];
    newConstraint.shouldBeArchived = self.shouldBeArchived;
    newConstraint.identifier = self.identifier;
    if (TTRuntimeOSVersionIsAtLeast(8.0)) {
        self.active = false;
        [NSLayoutConstraint deactivateConstraints:[NSArray arrayWithObjects:self, nil]];
        newConstraint.active = true;
        [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:newConstraint, nil]];
    }
    //NSLayoutConstraint.activateConstraints([newConstraint])
    return newConstraint;
}

@end
