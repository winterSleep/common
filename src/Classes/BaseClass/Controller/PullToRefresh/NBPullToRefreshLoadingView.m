//
//  NBPullToRefreshLoadingView.m
//  Fish
//
//  Created by Li Zhiping on 8/13/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import "NBPullToRefreshLoadingView.h"
#import <Masonry/Masonry.h>
#import "NBCommonLib.h"
#import <Nimbus/NimbusCore.h>
#import "NSBundle+AssociatedBundle.h"

@interface NBPullToRefreshLoadingView ()

@property (strong, nonatomic)UIImageView *imageView;

@end

@implementation NBPullToRefreshLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        NSMutableArray *animationImages = [NSMutableArray array];
        NSBundle *bundle = [NSBundle bundleWithBundleName:@"Common" podName:@"WinterCommon"];
        for (int i=0; i<4; i++) {
            NSString *imagePath = NIPathForBundleResource(bundle, [NSString stringWithFormat:@"pull_refresh_loading_%i", i]);
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            if (image) {
                [animationImages addObject:image];
            }
        }
        [self.imageView setAnimationImages:animationImages];
        [self addSubview:self.imageView];
        [self.imageView setAnimationDuration:0.6];
        
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(61.0f);
            make.height.mas_equalTo(60.0f);
        }];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self.imageView startAnimating];
    }else{
        [self.imageView stopAnimating];
    }
}

@end
