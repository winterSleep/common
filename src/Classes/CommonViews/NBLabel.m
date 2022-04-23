//
//  NBLabel.m
//  Fish
//
//  Created by Li Zhiping on 02/12/2017.
//  Copyright © 2017 Li Zhiping. All rights reserved.
//

#import "NBLabel.h"
#import <Masonry/Masonry.h>

@interface NBLabel ()

@property(strong, nonatomic)UILabel *titleLabel;

@end

@implementation NBLabel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
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
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:self.titleLabel];
}

- (void)setInsets:(UIEdgeInsets)insets{
    _insets = insets;
}

- (void)updateConstraints{
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(_insets);
    }];
    [super updateConstraints];
}

- (CGSize)intrinsicContentSize{
    CGSize size = [self.titleLabel intrinsicContentSize];
    return CGSizeMake(size.width + self.insets.left + self.insets.right, size.height + self.insets.top + self.insets.bottom);
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize old_size = [self.titleLabel sizeThatFits:size];
    return CGSizeMake(old_size.width + self.insets.left + self.insets.right, old_size.height + self.insets.top + self.insets.bottom);
}

@end
