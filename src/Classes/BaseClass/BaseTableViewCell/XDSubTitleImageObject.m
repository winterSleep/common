//
//  XDSubTitleImageObject.m
//  leCar
//
//  Created by Li Zhiping on 14-1-6.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "XDSubTitleImageObject.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TTGlobalUICommon.h"
#import "UIFontAdditions.h"
#import "UIView+FrameCategory.h"

@implementation XDSubTitleImageObject

- (Class)cellClass{
    return [XDSubTitleImageCell class];
}

@end

const CGFloat subTitleImageHeight = 50.0f;
const CGFloat sutTitleWithTitlePadding = 5.0f;

@implementation XDSubTitleImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.detailTextLabel setFont:[self detailLabelFont]];
        [self.detailTextLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.detailTextLabel setTextAlignment:NSTextAlignmentLeft];
        self.textLabel.font = [self textLabelFont];
        
        self.rightTopCaptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.rightTopCaptionLabel setBackgroundColor:[UIColor clearColor]];
        [self.rightTopCaptionLabel setTextColor:[UIColor grayColor]];
        [self.rightTopCaptionLabel setFont:[self captionLabelFont]];
        [self.rightTopCaptionLabel setNumberOfLines:1];
        [self.rightTopCaptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self addSubview:self.rightTopCaptionLabel];
        
    }
    return self;
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    [super shouldUpdateCellWithObject:object];
    
    self.object = object;
    
    XDSubTitleImageObject *subTitleImageObj = (XDSubTitleImageObject *)object;
    [self.textLabel setText:subTitleImageObj.title];
    [self.detailTextLabel setText:subTitleImageObj.subtitle];
    [self.detailTextLabel setNumberOfLines:subTitleImageObj.subTitleLines];
    [self.rightTopCaptionLabel setText:subTitleImageObj.rightTopCaption];
    
    [self.imageView sd_setImageWithURL:subTitleImageObj.imageUrl
                      placeholderImage:subTitleImageObj.placeHolderImage];
    
    return YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    XDSubTitleImageObject *subTitleImageObj = (XDSubTitleImageObject *)self.object;
    self.accessoryType = subTitleImageObj.accessoryType;
    
    CGFloat contentViewWidth = [self contentViewWidth];
    
    //设置图片的frame
    if (self.imageView.image) {
        [self.imageView setFrame:CGRectMake(NICellContentPadding().left,
                                            NICellContentPadding().top,
                                            subTitleImageHeight,
                                            subTitleImageHeight)];
    }
    
    if (TTRuntimeOSVersionIsAtLeast(7.0)) {
        self.separatorInset = UIEdgeInsetsMake(0, self.imageView.right, 0, 0);
    }
    
    CGFloat labelWidth = contentViewWidth - self.imageView.width - NICellContentPadding().left;
    CGFloat rightCaptionWidth = labelWidth/2.0f;
    NSDictionary *attributes = @{NSFontAttributeName:[self captionLabelFont]};
    CGSize captionSize = [self.rightTopCaptionLabel.text sizeWithAttributes:attributes];;
    rightCaptionWidth = MIN(rightCaptionWidth, captionSize.width);
    
    //设置标题的frame
    CGFloat labelLeft = self.imageView.right + NICellContentPadding().right;
    
    [self.textLabel setFrame:CGRectMake(labelLeft,
                                        NICellContentPadding().top,
                                        labelWidth - rightCaptionWidth,
                                        [[self textLabelFont] ttLineHeight])];
    
    [self.rightTopCaptionLabel setFrame:CGRectMake(self.textLabel.right,
                                                   NICellContentPadding().top,
                                                   rightCaptionWidth,
                                                   [[self captionLabelFont] ttLineHeight])];
    
    [self.rightTopCaptionLabel setCenterY:self.textLabel.centerY];
    
    //设置subTitle的frame
    CGFloat detailLabelTop = self.textLabel.bottom + sutTitleWithTitlePadding;
    CGFloat detailLabelHeight = 0;
    
    NSString *text = self.detailTextLabel.text;
    attributes = @{NSFontAttributeName:[self detailLabelFont]};
    detailLabelHeight = [text boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    if (self.detailTextLabel.numberOfLines > 0) {
        detailLabelHeight = MIN(detailLabelHeight,[[self detailLabelFont] heightWithLines:self.detailTextLabel.numberOfLines]);
    }
    
    [self.detailTextLabel setFrame:CGRectMake(labelLeft, detailLabelTop, labelWidth, detailLabelHeight)];
}

- (CGFloat)contentViewWidth{
    XDSubTitleImageObject *subTitleImageObj = (XDSubTitleImageObject *)self.object;
    CGFloat contentViewWidth = 0;
    if (subTitleImageObj.accessoryType == UITableViewCellAccessoryNone) {
        contentViewWidth = self.contentView.width - NICellContentPadding().left - NICellContentPadding().right;
    }else{
        contentViewWidth = self.contentView.width - NICellContentPadding().left;
    }
    return contentViewWidth;
}

- (UIFont *)textLabelFont{
    return [[self class] textLabelFont];
}

- (UIFont *)detailLabelFont{
    return [[self class] detailLabelFont];
}

- (UIFont *)captionLabelFont{
    return [[self class] captionLabelFont];
}

+ (CGFloat)contentViewWidthForObject:(id)object
                         atIndexPath:(NSIndexPath *)indexPath
                           tableView:(UITableView *)tableView{
    XDSubTitleImageObject *subTitleImageObj = (XDSubTitleImageObject *)object;
    
    CGFloat contentViewWidth = 0;
    if (subTitleImageObj.accessoryType == UITableViewCellAccessoryNone) {
        contentViewWidth = tableView.width - NICellContentPadding().left - NICellContentPadding().right;
    }else{
        contentViewWidth = tableView.width - NICellContentPadding().left - 33;
    }
    return contentViewWidth;
}

+ (UIFont *)textLabelFont{
    return [UIFont systemFontOfSize:15];
}

+ (UIFont *)detailLabelFont{
    return [UIFont systemFontOfSize:15];
}

+ (UIFont *)captionLabelFont{
    return [UIFont systemFontOfSize:12];
}

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    CGFloat height = 0;
    
    //标题的高度
    CGFloat titleHeight = [[self textLabelFont] lineHeight];
    
    CGFloat subTitleHeight = [self subTitleHeightForObject:object atIndexPath:indexPath tableView:tableView];
    
    height += NICellContentPadding().top + titleHeight + sutTitleWithTitlePadding + subTitleHeight + NICellContentPadding().bottom;
    
    return MAX(subTitleImageHeight + NICellContentPadding().top + NICellContentPadding().bottom, height);
}

+ (CGFloat)titleHeightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    return [[self textLabelFont] lineHeight];
}

+ (CGFloat)subTitleHeightForObject:(id)object
                       atIndexPath:(NSIndexPath *)indexPath
                         tableView:(UITableView *)tableView{
    
    XDSubTitleImageObject *subTitleObj = object;
    CGFloat contentViewWidth = [self contentViewWidthForObject:object atIndexPath:indexPath tableView:tableView];
    
    //子标题的宽度
    CGFloat labelWidth = contentViewWidth - subTitleImageHeight - NICellContentPadding().left;
    NSString *text = subTitleObj.subtitle;
    NSDictionary *attributes = @{NSFontAttributeName:[self detailLabelFont]};
    CGFloat subTitleHeight = [text boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    
    //如果限制了行数
    if (subTitleObj.subTitleLines > 0) {
        subTitleHeight = MIN(subTitleHeight,[[self detailLabelFont] heightWithLines:subTitleObj.subTitleLines]);
    }
    
    return subTitleHeight;
}

@end
