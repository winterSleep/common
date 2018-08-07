//
//  ColorButton.h
//  btn
//
//  Created by LYZ on 14-1-10.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;

@interface ColorButton : UIButton

/**
 *  更新button的 title and backgroundColor
 *
 *  @param colors 背景色数组
 *  @param type   暂时用不到 （从左至右）
 *  @param title  标题
 */
- (void)updateWithColos:(NSArray *)colors percent:(CGFloat)percent title:(NSString *)title;

@end
