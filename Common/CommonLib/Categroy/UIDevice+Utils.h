//
//  UIDevice+Utils.h
//  Fish
//
//  Created by Li Zhiping on 11/11/15.
//  Copyright © 2015 Li Zhiping. All rights reserved.
//

#import <UIKit/UIKit.h>

CGSize SCREEN_SIZE();

extern CGSize const SCREEN_SIZE_IPHONE4;
extern CGSize const SCREEN_SIZE_IPHONE5;
extern CGSize const SCREEN_SIZE_IPHONE6;
extern CGSize const SCREEN_SIZE_IPHONE6S;

BOOL IPHONE();
BOOL IPHONE4();
BOOL IPHONE5();
BOOL IPHONE6();
BOOL IPHONE6S();

BOOL IPAD();

@interface UIDevice (Utils)

@end