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
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
}

@end
