//
//  MBProgressHUD+Category.m
//  BussinessLink
//
//  Created by Li Zhiping on 14-7-10.
//  Copyright (c) 2014年 Li Zhiping. All rights reserved.
//

#import "MBProgressHUD+Category.h"
#import "UIView+FrameCategory.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation MBProgressHUD (Category)

+ (void)showHint:(NSString *)hint{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = hint;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    hud.margin = 10.f;
    hud.yOffset = view.height/2.0 - 100;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

@end
