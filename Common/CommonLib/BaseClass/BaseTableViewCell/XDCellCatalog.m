//
//  XDCellCatalog.m
//  BussinessLink
//
//  Created by Li Zhiping on 14-3-14.
//  Copyright (c) 2014年 djp. All rights reserved.
//

#import "XDCellCatalog.h"
#import "UIResponder+Router.h"
#import "UIView+FrameCategory.h"

@implementation XDSubtitleCellObject

- (instancetype)copyWithZone:(NSZone *)zone{
    XDSubtitleCellObject *object = [[[self class] allocWithZone:zone] init];
    object.subtitle = self.subtitle;
    object.cellStyle = self.cellStyle;
    object.title = self.title;
    object.image = self.image;
    object.titleColor = self.titleColor;
    object.subtitleColor = self.subtitleColor;
    object.lineEdgeInsets = self.lineEdgeInsets;
    object.lineStyle = self.lineStyle;
    object.userInfo = self.userInfo;
    return object;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass {
    return [XDTextCell class];
}

@end

@implementation XDTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lineView = [[XDCellLineView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.lineView];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.detailTextLabel setWidth:(self.contentView.width - NICellContentPadding().left - NICellContentPadding().right)];
    
    [self.detailTextLabel setLeft:NICellContentPadding().left];
    if ([self.cellObject isKindOfClass:[XDTitleCellObject class]]) {
        XDTitleCellObject *object = self.cellObject;
        [self.textLabel setTextAlignment:object.textAlignment];
        self.accessoryType = object.accessoryType;
    }
    
    UIEdgeInsets insets = [self defaultTitleInsets];
    if ([self.cellObject respondsToSelector:@selector(titleInsets)]) {
        if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, [self.cellObject titleInsets])) {
            insets = [self.cellObject titleInsets];
        }
    }
    [self.textLabel setLeft:insets.left];
    
    if (self.lineStyle == UITableViewCellSeparatorStyleSingleLine) {
        CGFloat width = self.width - self.lineEdgeInsets.left - self.lineEdgeInsets.right;
        CGFloat left = self.lineEdgeInsets.left;
        CGRect frame = CGRectMake(left, self.height - 0.5, width, 0.5);
        [_lineView setFrame:frame];
        [self bringSubviewToFront:_lineView];
    }else{
        [_lineView setFrame:CGRectZero];
    }
}

- (UIEdgeInsets)defaultTitleInsets{
    return NICellContentPadding();
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    [super shouldUpdateCellWithObject:object];
    self.cellObject = object;
    
    if ([object isKindOfClass:[XDTitleCellObject class]]) {
        XDTitleCellObject* titleObject = object;
        self.textLabel.textColor = titleObject.titleColor;
        self.lineEdgeInsets = titleObject.lineEdgeInsets;
        self.lineStyle = titleObject.lineStyle;
    }
    
    if ([object isKindOfClass:[XDSubtitleCellObject class]]) {
        XDSubtitleCellObject* subtitleObject = object;
        self.textLabel.textColor = subtitleObject.titleColor;
        self.detailTextLabel.textColor = subtitleObject.subtitleColor;
        self.detailTextLabel.text = subtitleObject.subtitle;
        self.lineEdgeInsets = subtitleObject.lineEdgeInsets;
        self.lineStyle = subtitleObject.lineStyle;
    }
    
    return YES;
}

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    if ([object isKindOfClass:[XDTitleCellObject class]]) {
        XDTitleCellObject *cellObject = object;
        if (cellObject.cellHeight > 0) {
            return cellObject.cellHeight;
        }
    }
    return 44.0f;
}

@end

@implementation XDTitleCellObject

- (instancetype)copyWithZone:(NSZone *)zone{
    XDTitleCellObject *object = [[[self class] allocWithZone:zone] init];
    object.title = self.title;
    object.image = self.image;
    
    object.textAlignment = self.textAlignment;
    object.titleColor = self.titleColor;
    object.lineEdgeInsets = self.lineEdgeInsets;
    object.lineStyle = self.lineStyle;
    object.userInfo = self.userInfo;
    return object;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass {
    return [XDTextCell class];
}

@end

@implementation XDDrawRectBlockCellObject

@end

@implementation XDDrawRectBlockCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lineView = [[XDCellLineView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.lineStyle == UITableViewCellSeparatorStyleSingleLine) {
        CGFloat width = self.width - self.lineEdgeInsets.left - self.lineEdgeInsets.right;
        CGFloat left = self.lineEdgeInsets.left;
        CGRect frame = CGRectMake(left, self.frame.size.height - 0.5, width, 0.5);
        [_lineView setFrame:frame];
        [self bringSubviewToFront:_lineView];
    }else{
        [_lineView setFrame:CGRectZero];
    }
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    [super shouldUpdateCellWithObject:object];
    self.cellObject = object;
    XDDrawRectBlockCellObject *cellObject = object;
    self.lineEdgeInsets = cellObject.lineEdgeInsets;
    self.lineStyle = cellObject.lineStyle;
    return YES;
}

@end

NSString *const kTableViewCellObject = @"kTableViewCellObject";

@implementation XDTextCell (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSMutableDictionary *)userInfo{
    if (userInfo) {
        [userInfo setObject:self.cellObject forKey:kTableViewCellObject];
    }else{
        userInfo = [NSMutableDictionary dictionaryWithObject:self.cellObject forKey:kTableViewCellObject];
    }
    //将广播再次进行传递
    [self.nextResponder routerEventWithName:eventName userInfo:userInfo];
}

@end
