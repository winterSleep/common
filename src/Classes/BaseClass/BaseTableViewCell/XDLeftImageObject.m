//
//  XDLeftImageObject.m
//  leCar
//
//  Created by Li Zhiping on 14-3-6.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "XDLeftImageObject.h"
#import "UIView+FrameCategory.h"

@implementation XDLeftImageObject

- (Class )cellClass{
    return [XDLeftImageCell class];
}

@end

@implementation XDLeftImageCell

- (void)layoutSubviews{
    [super layoutSubviews];
    
    XDRightImageObject *cellObject = self.cellObject;
    UIEdgeInsets imageInsets = [cellObject imageInsets];
    if (UIEdgeInsetsEqualToEdgeInsets(imageInsets, UIEdgeInsetsZero)) {
        imageInsets = [[self class] defaultInsetsForImage];
    }
    
    UIEdgeInsets titleInsets = [cellObject titleInsets];
    if (UIEdgeInsetsEqualToEdgeInsets(titleInsets, UIEdgeInsetsZero)) {
        titleInsets = [[self class] defaultInsetsForTitle];
    }
    
    CGFloat imageHeight = self.contentView.height - imageInsets.top - imageInsets.bottom;
    CGFloat imageWidth = imageHeight;
    CGFloat imageLeft = imageInsets.left;
    CGFloat imageTop = imageInsets.top;
    [self.imageView setFrame:CGRectMake(imageLeft, imageTop, imageWidth, imageHeight)];
    
    CGFloat titleHeight = self.contentView.height - titleInsets.top - titleInsets.bottom;
    CGFloat titleWidth = self.contentView.width - titleInsets.left - titleInsets.right - imageWidth - imageInsets.left - imageInsets.right;
    CGFloat titleLeft = self.imageView.right + imageInsets.right + titleInsets.left;
    CGFloat titleTop = titleInsets.top;
    [self.textLabel setFrame:CGRectMake(titleLeft, titleTop, titleWidth, titleHeight)];
    
}

+ (UIEdgeInsets)defaultInsetsForImage{
    return NICellContentPadding();
}

+ (UIEdgeInsets)defaultInsetsForTitle{
    return UIEdgeInsetsMake(10, 0, 10, 10);
}
@end
