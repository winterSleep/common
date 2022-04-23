//
//  UIViewController+HUD.m
//  XDHoHo
//
//  Created by Li Zhiping on 13-12-21.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "MBProgressHUD+Category.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    if (!self.HUD) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
        HUD.labelText = hint;
        HUD.removeFromSuperViewOnHide = YES;
        [view addSubview:HUD];
        [HUD show:YES];
        [self setHUD:HUD];
    }
}

- (void)changeHudHint:(NSString *)hint{
    [[self HUD] setLabelText:hint];
}

- (void)showHint:(NSString *)hint{
    [MBProgressHUD showHint:hint];
}

- (void)hideHud{
    [[self HUD] hide:YES];
    [self setHUD:nil];
}

@end
