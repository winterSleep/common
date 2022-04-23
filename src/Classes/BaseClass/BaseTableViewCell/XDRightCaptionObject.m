//
//  XDRightCaptionObject.m
//  leCar
//
//  Created by Li Zhiping on 14-1-3.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "XDRightCaptionObject.h"
#import "TTGlobalUICommon.h"
#import <Masonry/Masonry.h>
#import "Colours.h"
#import "UIView+FrameCategory.h"

@implementation XDRightCaptionObject

+ (id)objectWithTitle:(NSString *)title caption:(NSString *)caption{
    XDRightCaptionObject *object = [self objectWithTitle:title];
    object.caption = caption;
    return object;
}

- (Class)cellClass{
    return [XDRightCaptionCell class];
}

@end

@interface XDRightCaptionCell ()

@property (strong, nonatomic)UILabel *leftTextLabel;
@property (strong, nonatomic)UILabel *rightTextLabel;

@end

@implementation XDRightCaptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.rightTextLabel setFont:[UIFont systemFontOfSize:14]];
        [self.rightTextLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self.rightTextLabel setNumberOfLines:0];
        [self.rightTextLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        self.leftTextLabel.font = [UIFont systemFontOfSize:16];
        
        [self.contentView removeAllSubviews];
        
        [self.contentView addSubview:self.rightTextLabel];
        [self.contentView addSubview:self.leftTextLabel];
    }
    return self;
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    [super shouldUpdateCellWithObject:object];
    XDRightCaptionObject *captionObj = (XDRightCaptionObject *)object;
    [self.textLabel setText:nil];
    [self.detailTextLabel setText:nil];
    
    [self.rightTextLabel setText:captionObj.caption];
    [self.leftTextLabel setText:captionObj.title];
    
    return YES;
}

- (void)updateConstraints{
    [self configConstraints];
    [super updateConstraints];
}

- (void)configConstraints{
    [self.leftTextLabel invalidateIntrinsicContentSize];
    [self.leftTextLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightTextLabel invalidateIntrinsicContentSize];
    
    [self.leftTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    if (self.accessoryType == UITableViewCellAccessoryNone) {
        [self.rightTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-NICellContentPadding().left);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }else{
        [self.rightTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
}

- (void)layoutSubviews{

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [super layoutSubviews];
    
    //计算右侧换行的label的最大宽度
    UIFont *font = self.leftTextLabel.font;
    NSString *leftLabelText = self.leftTextLabel.text;
    CGSize leftLabelSize = [leftLabelText sizeWithAttributes:@{NSFontAttributeName:font}];
    
    CGFloat rightTextLabelMaxWidth = self.contentView.width - NICellContentPadding().left - leftLabelSize.width - NICellContentPadding().left - NICellContentPadding().right;
    [self.rightTextLabel setPreferredMaxLayoutWidth:rightTextLabelMaxWidth];
    
}

- (void)updateTitleText{
    NSString *title = ((XDRightCaptionObject *)self.cellObject).title;
    [[self leftTextLabel] setText:title];
}

- (UILabel *)leftTextLabel{
    if (!_leftTextLabel) {
        _leftTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _leftTextLabel;
}

- (UILabel *)rightTextLabel{
    if (!_rightTextLabel) {
        _rightTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _rightTextLabel;
}

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    return 44.0f;
}

@end
