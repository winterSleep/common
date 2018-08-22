//
//  SDImageCache+XDImage.h
//  BussinessLink
//
//  Created by Li Zhiping on 14-3-17.
//  Copyright (c) 2014年 djp. All rights reserved.
//

#import <SDWebImage/SDImageCache.h>

@interface SDImageCache (XDImage)

/**
 *  从mainBundle下, 读取图片到内存, 并返回
 *
 *  @param imageName 图片名字
 *
 *  @return 内存中的图片
 */
+ (UIImage *)imageNamed:(NSString *)imageName;

@end
