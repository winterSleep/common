//
//  XDRightImageObject.h
//  leCar
//
//  Created by Li Zhiping on 14-1-3.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "XDCellCatalog.h"

//左侧标题, 右侧图片显示Cell样式.
@interface XDRightImageObject : XDTitleCellObject

+ (id)objectWithTitle:(NSString *)title
             imageUrl:(NSURL *)imageUrl
     placeHolderImage:(UIImage *)placeHolderImage;

@property (strong, nonatomic)UIImage *placeHolderImage;

@property (strong, nonatomic)NSURL *imageUrl;

@property (assign, nonatomic)UIEdgeInsets imageInsets;

//显示圆形图片
@property (assign, nonatomic)BOOL showRoundImage;

//Cell的高度, 同时用于确定ImageView的高度
@property (assign, nonatomic)CGFloat cellHeight;

@end

@interface XDRightImageCell: XDTextCell

+ (UIEdgeInsets)defaultInsetsForImage;

+ (UIEdgeInsets)defaultInsetsForTitle;

@end
