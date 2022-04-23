//
//  UINavigationItem+BackTitle.m
//  NBChat
//
//  Created by 长弓 on 14-11-13.
//  Copyright (c) 2014年 Li Zhiping. All rights reserved.
//

#import "UINavigationItem+BackTitle.h"

@implementation UINavigationItem (BackTitle)
-(void)resetNavigationBarBackTitle:(NSString *)title{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = title;
    self.backBarButtonItem = backItem;
}

@end
