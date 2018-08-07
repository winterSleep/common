//
//  NSData+JSON.m
//  EaseMobClientSDK
//
//  Created by Li Zhiping on 14-6-27.
//  Copyright (c) 2014年 EaseMob. All rights reserved.
//

#import "NSData+JSON.h"

@implementation NSData (JSON)

- (id)toObject{
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
    if (error) {
        error = nil;
        return nil;
    }
    return object;
}

@end
