//
//  XDNibCellObject.m
//  ERP
//
//  Created by Li Zhiping on 7/14/16.
//  Copyright © 2016 Ghost. All rights reserved.
//

#import "XDNibCellObject.h"
#import "UIResponder+Router.h"
#import <Masonry/Masonry.h>
#import "UIView+FrameCategory.h"

@implementation XDNibCellObject

+ (instancetype)cellObjectWithLineInsets:(UIEdgeInsets)insets{
    XDNibCellObject *cellObject = [[self alloc] init];
    cellObject.lineStyle = UITableViewCellSeparatorStyleSingleLine;
    cellObject.lineEdgeInsets = insets;
    return cellObject;
}

- (UINib *)cellNib{
    NSAssert(true, @"必须继承重写该方法");
    return nil;
}

- (Class)cellClassForHeight{
    return [XDNibCell class];
}

- (NSString *)cellIdentify{
    return NSStringFromClass([self class]);
}

@end

@interface XDNibCell ()

@property (strong, nonatomic)XDNibCellObject *cellObject;

@end

@implementation XDNibCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initialization];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self _initialization];
}

- (void)_initialization{
    self.lineView = [[XDCellLineView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.lineView];
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    self.cellObject = object;
    return YES;
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSMutableDictionary *)userInfo{
    if (userInfo) {
        [userInfo setObject:self.cellObject forKey:kTableViewCellObject];
    }else{
        userInfo = [NSMutableDictionary dictionaryWithObject:self.cellObject forKey:kTableViewCellObject];
    }
    //将广播再次进行传递
    [self.nextResponder routerEventWithName:eventName userInfo:userInfo];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.cellObject.lineStyle == UITableViewCellSeparatorStyleSingleLine) {
        CGFloat width = self.width - self.cellObject.lineEdgeInsets.left - self.cellObject.lineEdgeInsets.right;
        CGFloat left = self.cellObject.lineEdgeInsets.left;
        CGRect frame = CGRectMake(left, self.height - 0.5, width, 0.5);
        [_lineView setFrame:frame];
        [self bringSubviewToFront:_lineView];
    }else{
        [_lineView setFrame:CGRectZero];
    }
}

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    return 44.0f;
}

@end
