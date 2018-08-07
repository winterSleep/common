//
//  UIResponder+Router.m
//  leCar
//
//  Created by Li Zhiping on 14-2-15.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSMutableDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end
