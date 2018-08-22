//
//  NSNumber+Category.m
//  Fish
//
//  Created by Li Zhiping on 5/19/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import "NSNumber+Category.h"

@implementation NSNumber (Category)

+ (NSNumber *)decreaseNumber:(NSNumber *)number{
    NSInteger intNumber = [number integerValue] - 1;
    return @(intNumber);
}

+ (NSNumber *)increaseNumber:(NSNumber *)number{
    NSInteger intNumber = [number integerValue] + 1;
    return @(intNumber);
}

@end
