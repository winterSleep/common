//
//  NSMutableArray+Safe.h
//  Fish
//
//  Created by Li Zhiping on 31/03/2017.
//  Copyright © 2017 Li Zhiping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Safe)

- (void)safeAddObject:(NSObject *)anObject;

@end
