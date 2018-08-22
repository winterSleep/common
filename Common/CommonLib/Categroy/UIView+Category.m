//
//  UIView+Category.m
//  Fish
//
//  Created by Li Zhiping on 10/8/15.
//  Copyright © 2015 Li Zhiping. All rights reserved.
//

#import "UIView+Category.h"
#import <objc/runtime.h>

static const void *isViewSHowKey = &isViewSHowKey;

@implementation UIView (Category)

- (BOOL)isViewShow{
    return objc_getAssociatedObject(self, isViewSHowKey);
}

- (void)setIsViewShow:(BOOL)isViewShow{
    objc_setAssociatedObject(self, isViewSHowKey, @(isViewShow), OBJC_ASSOCIATION_ASSIGN);
}

- (void)viewWillAppear:(BOOL)animated{
    self.isViewShow = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    self.isViewShow = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.isViewShow = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    self.isViewShow = NO;
}

@end
