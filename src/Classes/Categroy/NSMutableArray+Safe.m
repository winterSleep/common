//
//  NSMutableArray+Safe.m
//  Fish
//
//  Created by Li Zhiping on 31/03/2017.
//  Copyright © 2017 Li Zhiping. All rights reserved.
//

#import "NSMutableArray+Safe.h"

@implementation NSMutableArray (Safe)

- (void)safeAddObject:(NSObject *)anObject{
    if (anObject) {
        [self addObject:anObject];
    }
}

@end
