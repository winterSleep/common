//
//  NSDictionary+JSON.m
//  EaseMobClientSDK
//
//  Created by Li Zhiping on 14-6-27.
//  Copyright (c) 2014年 EaseMob. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

- (NSData *)toJSONData{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error) {
        error = nil;
        return nil;
    }
    return data;
}

@end
