//
//  NBCommentLoadingCellObject.m
//  Fish
//
//  Created by Li Zhiping on 5/11/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import "NBLoadingCellObject.h"
#import <Masonry/Masonry.h>
#import "UIView+FrameCategory.h"

@implementation NBLoadingCellObject

- (Class)cellClass{
    return [NBLoadingCell class];
}

@end

@interface NBLoadingCell ()

@property (strong, nonatomic)UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic)UILabel *hintTextLabel;

@end

@implementation NBLoadingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [indicatorView setHidesWhenStopped:NO];
        [indicatorView startAnimating];
        [indicatorView sizeToFit];
        self.indicatorView = indicatorView;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [textLabel setText:@"加载中..."];
        [textLabel setFont:[UIFont systemFontOfSize:13]];
        [textLabel setTextColor:[UIColor blackColor]];
        [textLabel sizeToFit];
        self.hintTextLabel = textLabel;
        
        CGFloat padding = 10.0f;
        CGFloat width = indicatorView.width + textLabel.width + padding;
        UIView *containView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:containView];
        [containView addSubview:indicatorView];
        [containView addSubview:textLabel];
        
        [containView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.mas_equalTo(width);
            make.height.equalTo(self.contentView.mas_height);
        }];
        
        [indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containView.mas_left);
            make.centerY.equalTo(containView.mas_centerY);
        }];
        
        [textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(containView.mas_right);
            make.centerY.equalTo(containView.mas_centerY);
        }];
    }
    return self;
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    [super shouldUpdateCellWithObject:object];
    UIColor *cellColor = [UIColor whiteColor];
    if ([object cellColor]) {
        cellColor = [object cellColor];
    }
    self.contentView.backgroundColor = cellColor;
    return YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.indicatorView startAnimating];
}

@end
