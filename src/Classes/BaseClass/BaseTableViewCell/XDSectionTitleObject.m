//
//  XDSectionTitleObject.m
//  leCar
//
//  Created by Li Zhiping on 14-2-25.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "XDSectionTitleObject.h"
#import "UIView+FrameCategory.h"

@implementation XDSectionTitleObject

+ (instancetype)objectWithTitle:(NSString *)title sectionHeight:(CGFloat)height{
    XDSectionTitleObject *object = [self objectWithTitle:title];
    [object setSectionHeight:height];
    return object;
}

+ (instancetype)objectWithHeight:(CGFloat)height{
    return [self objectWithTitle:nil sectionHeight:height];
}

- (Class)cellClass{
    return [XDSectionTitleCell class];
}

@end

@implementation XDSectionTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.textLabel setNumberOfLines:0];
        [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    XDSectionTitleObject *cellObject = (XDSectionTitleObject *)self.cellObject;
    self.backgroundColor = cellObject.sectionColor;
    self.contentView.backgroundColor = cellObject.sectionColor;
    
    UIFont *font = [[self class] defaultLabelFont];
    if (cellObject.titleFont) {
        font = cellObject.titleFont;
    }
    [self.textLabel setFont:font];
    [self.textLabel setTextColor:cellObject.titleColor];
    UIEdgeInsets titleInset = cellObject.titleInsets;
    [self.textLabel setFrame:UIEdgeInsetsInsetRect(self.contentView.bounds, titleInset)];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    XDSectionTitleObject *cellObject = (XDSectionTitleObject *)object;
    if (cellObject.sectionHeight > 0) {
        return cellObject.sectionHeight;
    }
    
    if (cellObject.title) {
        CGFloat width = tableView.width - NICellContentPadding().left - NICellContentPadding().right;
        UIFont *font = [self defaultLabelFont];
        if (cellObject.titleFont) {
            font = cellObject.titleFont;
        }
//        CGSize size = [cellObject.title sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        NSDictionary *attribute = @{NSFontAttributeName:font};
        CGSize size = [cellObject.title boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        return size.height + NICellContentPadding().top + NICellContentPadding().bottom;
    }
    
    return tableView.rowHeight;
}

+ (UIFont *)defaultLabelFont{
    return [UIFont systemFontOfSize:15];
}

@end
