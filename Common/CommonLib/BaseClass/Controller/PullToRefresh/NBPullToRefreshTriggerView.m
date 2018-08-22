//
//  NBPullToRefreshTriggerView.m
//  Fish
//
//  Created by Li Zhiping on 8/13/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import "NBPullToRefreshTriggerView.h"
#import <Masonry/Masonry.h>

extern NSInteger const kPullToRefreshAnimationImagesCount;

@interface NBPullToRefreshTriggerView ()

@property (strong, nonatomic)UIImageView *imageView;

@end

@implementation NBPullToRefreshTriggerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pull_refresh_trigger_ani%li", kPullToRefreshAnimationImagesCount]];
        [self.imageView setImage:image];
        [self addSubview:self.imageView];
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(60.0f);
            make.height.mas_equalTo(60.0f);
        }];
    }
    return self;
}

@end
