//
//  SDImageCache+XDImage.m
//  BussinessLink
//
//  Created by Li Zhiping on 14-3-17.
//  Copyright (c) 2014年 djp. All rights reserved.
//

#import "SDImageCache+XDImage.h"
#import <SDWebImage/UIImage+GIF.h>
#import <Nimbus/NimbusCore.h>

@implementation SDImageCache (XDImage)

+ (UIImage *)imageNamed:(NSString *)imageName{
    if (imageName.length > 0) {
        NSString *md5String = NIMD5HashFromString(imageName);
        UIImage *image = [[self sharedImageCache] imageFromMemoryCacheForKey:md5String];
        if (!image) {
            NSString *filePath = NIPathForBundleResource([NSBundle mainBundle], imageName);
            image = [UIImage imageWithContentsOfFile:filePath];
            if (!image) {
                image = [UIImage imageNamed:imageName];
            }
            if (!image) {
                image = [UIImage imageWithContentsOfFile:imageName];
            }
            
            [[self sharedImageCache] storeImage:image forKey:md5String toDisk:NO completion:nil];
        }
        return image;
    }
    return nil;
}

@end
