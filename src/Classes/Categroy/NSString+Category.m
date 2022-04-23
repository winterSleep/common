//
//  NSString+Category.m
//  Fish
//
//  Created by Li Zhiping on 7/18/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

- (BOOL)_containsString:(NSString *)str{
    NSRange rang = [self rangeOfString:str];
    if (rang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
