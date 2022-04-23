//
//  XDRightImageObject.m
//  leCar
//
//  Created by Li Zhiping on 14-1-3.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "XDRightImageObject.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TTGlobalUICommon.h"
#import "UIView+FrameCategory.h"

@interface XDRightImageObject ()

@end

@implementation XDRightImageObject

+ (id)objectWithTitle:(NSString *)title
             imageUrl:(NSURL *)imageUrl
     placeHolderImage:(UIImage *)placeHolderImage{
    
    XDRightImageObject *object = [self objectWithTitle:title];
    object.imageUrl = imageUrl;
    object.placeHolderImage = placeHolderImage;
    return object;
}

- (Class )cellClass{
    return [XDRightImageCell class];
}

@end

@implementation XDRightImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:16];
        [self.imageView.layer setMasksToBounds:YES];
    }
    return self;
}

- (BOOL)shouldUpdateCellWithObject:(XDRightImageObject *)object{
    [super shouldUpdateCellWithObject:object];
    [self.imageView sd_setImageWithURL:object.imageUrl
                      placeholderImage:object.placeHolderImage];
    return YES;
}

- (void)prepareForReuse{
    [self.imageView.layer setCornerRadius:0];
    [self.textLabel setFrame:CGRectZero];
    [self.imageView setFrame:CGRectZero];
}

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
    
    CGFloat titleHeight = self.contentView.height - titleInsets.top - titleInsets.bottom;
    CGFloat titleWidth = self.contentView.width - titleInsets.left - titleInsets.right - imageWidth - imageInsets.left - imageInsets.right;
    CGFloat titleLeft = titleInsets.left;
    CGFloat titleTop = titleInsets.top;
    [self.textLabel setFrame:CGRectMake(titleLeft, titleTop, titleWidth, titleHeight)];
    
    CGFloat imageLeft = self.textLabel.right + titleInsets.right + imageInsets.left;
    if (self.accessoryType != UITableViewCellAccessoryNone) {
        imageLeft = self.contentView.width - imageWidth;
    }
    CGFloat imageTop = imageInsets.top;
    [self.imageView setFrame:CGRectMake(imageLeft, imageTop, imageWidth, imageHeight)];
    
    if (cellObject.showRoundImage) {
        [self.imageView.layer setCornerRadius:imageWidth/2.0f];
    }
}

+ (UIEdgeInsets)defaultInsetsForImage{
    return NICellContentPadding();
}

+ (UIEdgeInsets)defaultInsetsForTitle{
    return UIEdgeInsetsMake(10, 10, 10, 0);
}

+ (CGFloat)heightForObject:(XDRightImageObject *)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    if ([object cellHeight] > 0) {
        return [object cellHeight];
    }
    return tableView.rowHeight;
}

@end
