//
//  UIViewController+navigationButton.m
//  leCar
//
//  Created by Li Zhiping on 14-2-25.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "UIViewController+navigationButton.h"
#import "TTGlobalUICommon.h"
#import "SDImageCache+XDImage.h"
#import "Colours.h"
#import "UIView+FrameCategory.h"
#import "UIImage+Color.h"
#import "NBBarButtonView.h"

@implementation UIViewController (navigationButton)

- (void)setupNavigationStyle{
    
    UIColor *imageColor = [UIColor colorFromHexString:@"#1dd1a1"];
    UIImage *colorImage = [UIImage imageWithColor:imageColor];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setTintColor:[UIColor whiteColor]];
    [navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIColor whiteColor], NSForegroundColorAttributeName,
                               [UIColor clearColor], NSForegroundColorAttributeName,
                               [UIFont systemFontOfSize:17], NSFontAttributeName,
                               nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
    
    //删除底部的线
    if ([self prefersNavigationLineHide]) {
        [[self bottomLineInView:navigationBar] removeFromSuperview];
        [navigationBar setShadowImage:[[UIImage alloc] init]];
    }
}

- (BOOL)prefersNavigationLineHide{
    return NO;
}

- (UIView *)bottomLineInView:(UIView *)view{
    UIView *result = nil;
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIImageView class]] && subView.height == 0.5) {
            result = subView;
            return result;
        }else{
            result = [self bottomLineInView:subView];
            if (result) {
                return result;
            }
        }
    }
    return result;
}

- (UIBarButtonItem *)setLeftButtonWithTitle:(NSString *)title
                                     target:(id)target
                                   selector:(SEL)selector{
    self.navigationItem.leftBarButtonItems = nil;
    
    self.navigationItem.leftBarButtonItems = nil;
    UIBarButtonItem *button = nil;
    if (TTRuntimeOSVersionIsAtLeast(7.0)) {
        button = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
        [self.navigationItem setLeftBarButtonItem:button animated:NO];
    }else{
        button = [self barButtonItemWithTitle:title target:target selector:selector];
        [self.navigationItem setLeftBarButtonItem:button animated:NO];
    }
    return button;
}

- (void)showCustomBackButtonWithTitle:(NSString *)title{
    
    UIButton *backButton = [self defaultBackButtonWithTitle:title];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 11)
    {
        NBBarButtonView *barBtnView = [[NBBarButtonView alloc] initWithFrame:backButton.frame];
        [barBtnView setPosition:BarButtonViewPositionLeft];
        [barBtnView addSubview:backButton];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:barBtnView]];
    }else{
        UIBarButtonItem *negativeSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeparator.width = -8;
        
        UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItems = @[negativeSeparator, back];
    }
}

- (UIButton *)defaultBackButtonWithTitle:(NSString *)title{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [SDImageCache imageNamed:@"nav_back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setAdjustsImageWhenHighlighted:NO];
    [backButton setTintColor:[self prefersBackButtonColor]];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    //    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    //    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton setTitleColor:[self prefersBackButtonColor] forState:UIControlStateNormal];
    //    CGSize size = [backButton intrinsicContentSize];
    [backButton setSize:CGSizeMake(44, self.navigationController.navigationBar.height)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

- (UIColor *)prefersBackButtonColor{
    return [UIColor whiteColor];
}

- (UIButton *)defaultFirstButtonWithTitle:(NSString *)title{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [SDImageCache imageNamed:@"nav_back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setAdjustsImageWhenHighlighted:NO];
    [backButton setTintColor:[self prefersBackButtonColor]];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    //    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    //    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton setTitleColor:[self prefersBackButtonColor] forState:UIControlStateNormal];
    //    CGSize size = [backButton intrinsicContentSize];
    [backButton setSize:CGSizeMake(34, self.navigationController.navigationBar.height)];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

- (void)showCustomBackButtonWithTitle:(NSString *)title secondButtonTitle:(NSString *)secondTitle{
    
    UIButton *backButton = [self defaultFirstButtonWithTitle:title];
    
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondButton setAdjustsImageWhenHighlighted:NO];
    [secondButton setTitle:secondTitle forState:UIControlStateNormal];
    [secondButton setTitleColor:[self prefersBackButtonColor] forState:UIControlStateNormal];
    [secondButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [secondButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [secondButton sizeToFit];
    [secondButton setFrame:CGRectMake(backButton.right, 0, secondButton.width, 44.0f)];
    [secondButton addTarget:self action:@selector(backSecondButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = CGRectMake(0, 0, backButton.width + secondButton.width, MAX(secondButton.height, backButton.height));
    UIView *customView = [[UIView alloc] initWithFrame:frame];
    [customView addSubview:backButton];
    [customView addSubview:secondButton];
    [customView setBackgroundColor:[UIColor clearColor]];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 11)
    {
        NBBarButtonView *barBtnView = [[NBBarButtonView alloc] initWithFrame:customView.frame];
        [barBtnView setPosition:BarButtonViewPositionLeft];
        [barBtnView addSubview:customView];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:barBtnView]];
    }else{
        UIBarButtonItem *negativeSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeparator.width = -8;
        
        UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:customView];
        self.navigationItem.leftBarButtonItems = @[negativeSeparator, back];
    }
}

- (void)backSecondButtonAction{
    
}

- (void)backButtonAction{
    if ([self canDismissViewController]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIBarButtonItem *)setRightButtonWithTitle:(NSString *)title
                                      target:(id)target
                                    selector:(SEL)selector{
    UIBarButtonItem *button = nil;
    if (TTRuntimeOSVersionIsAtLeast(7.0)) {
        button = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
        [self.navigationItem setRightBarButtonItem:button animated:NO];
    }else{
        button = [self barButtonItemWithTitle:title target:target selector:selector];
        [self.navigationItem setRightBarButtonItem:button animated:NO];
    }
    return button;
}

- (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image
                           highlightedImage:(UIImage *)highlightedImage
                                     target:(id)target
                                   selector:(SEL)selector{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, 5.0f, 0, 5.0f)];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    [backButton addTarget:target
                   action:selector
         forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title
                                     target:(id)target
                                   selector:(SEL)selector{
    
    if (TTRuntimeOSVersionIsAtLeast(7.0)) {
        return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    }else{
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:title forState:UIControlStateNormal];
        [backButton setFrame:CGRectMake(0, 0, 60, 44)];
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, 5.0f, 0, 5.0f)];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [backButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [backButton sizeToFit];
        [backButton addTarget:target
                       action:selector
             forControlEvents:UIControlEventTouchUpInside];
        return [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
}

- (BOOL)canDismissViewController{
    return YES;
}

@end

