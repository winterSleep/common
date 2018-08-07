//
//  XDSeparatorLineObject.m
//  leCar
//
//  Created by Li Zhiping on 14-2-25.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "XDSeparatorLineObject.h"
#import "XDCellLineView.h"
#import "UIView+FrameCategory.h"

@implementation XDSeparatorLineObject

+ (instancetype)object{
    return [[XDSeparatorLineObject alloc] init];
}

+ (instancetype)objectWithInset:(UIEdgeInsets)inset{
    XDSeparatorLineObject *cellObject = [self object];
    [cellObject setLineEdgeInsets:inset];
    return cellObject;
}

- (Class)cellClass{
    return [XDSeparatorLineCell class];
}

@end

@interface XDSeparatorLineCell (){
    XDCellLineView *_lineView;
    XDSeparatorLineObject *_cellObject;
}

@end

@implementation XDSeparatorLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lineView = [[XDCellLineView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    
    if (_cellObject != object) {
        _cellObject = object;
    }
    
    return YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets inset = _cellObject.lineEdgeInsets;
    CGFloat width = self.contentView.width - inset.left - inset.right;
    CGFloat height = self.contentView.height;
    CGRect frame = CGRectMake(inset.left, 0, width, height);
    [_lineView setFrame:frame];
}

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    return 1.0f;
}

@end
