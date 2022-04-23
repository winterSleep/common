//
//  UIDevice+Utils.m
//  Fish
//
//  Created by Li Zhiping on 11/11/15.
//  Copyright © 2015 Li Zhiping. All rights reserved.
//

#import "UIDevice+Utils.h"

CGSize SCREEN_SIZE() {
    return [UIScreen mainScreen].bounds.size;
}

CGSize const SCREEN_SIZE_IPHONE4    = (CGSize){320.0f, 480.0f};
CGSize const SCREEN_SIZE_IPHONE5    = (CGSize){320.0f, 568.0f};
CGSize const SCREEN_SIZE_IPHONE6    = (CGSize){375.0f, 667.0f};
CGSize const SCREEN_SIZE_IPHONE6S   = (CGSize){414.0f, 736.0f};

BOOL IPHONE() {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}
BOOL IPHONE4() {
    return (IPHONE() && SCREEN_SIZE().height == SCREEN_SIZE_IPHONE4.height);
}
BOOL IPHONE5() {
    return (IPHONE() && SCREEN_SIZE().height == SCREEN_SIZE_IPHONE5.height);
}
BOOL IPHONE6() {
    return (IPHONE() && SCREEN_SIZE().height == SCREEN_SIZE_IPHONE6.height);
}
BOOL IPHONE6S() {
    return (IPHONE() && SCREEN_SIZE().height == SCREEN_SIZE_IPHONE6S.height);
}

BOOL IPAD() {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

@implementation UIDevice (Utils)

@end