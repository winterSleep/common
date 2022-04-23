//
//  UIViewController+navigationButton.h
//  leCar
//
//  Created by Li Zhiping on 14-2-25.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (navigationButton)

//自定义左侧按钮, 只显示文字
- (UIBarButtonItem *)setLeftButtonWithTitle:(NSString *)title
                                     target:(id)target
                                   selector:(SEL)selector;

//自定义返回按钮文字, 并显示返回按钮箭头
- (void)showCustomBackButtonWithTitle:(NSString *)title;
//返回按钮操作
- (void)backButtonAction;

//自定义返回按钮, 并显示第二个按钮
- (void)showCustomBackButtonWithTitle:(NSString *)title secondButtonTitle:(NSString *)secondTitle;
//返回的第二个按钮点击事件
- (void)backSecondButtonAction;

- (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title
                                     target:(id)target
                                   selector:(SEL)selector;

- (UIBarButtonItem *)setRightButtonWithTitle:(NSString *)title
                                      target:(id)target
                                    selector:(SEL)selector;

- (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image
                           highlightedImage:(UIImage *)highlightedImage
                                     target:(id)target
                                   selector:(SEL)selector;

- (BOOL)canDismissViewController;

//设置navigationBar的颜色和title的颜色
- (void)setupNavigationStyle;

- (BOOL)prefersNavigationLineHide;
- (UIColor *)prefersBackButtonColor;

@end

