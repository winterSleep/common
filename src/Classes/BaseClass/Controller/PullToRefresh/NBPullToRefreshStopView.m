//
//  NBPullToRefreshStopView.m
//  Fish
//
//  Created by Li Zhiping on 8/13/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import "NBPullToRefreshStopView.h"
#import <Masonry/Masonry.h>
#import <Nimbus/NimbusCore.h>
#import "NSBundle+AssociatedBundle.h"

NSInteger const kPullToRefreshAnimationImagesCount = 20;

@interface NBPullToRefreshStopView ()

@property (strong, nonatomic)UIImageView *imageView;

//用于处理pullToRefreshView state 的状态 从 loading 变成 stop 的时候, 动画的图片会随机变成第1张或第2张或第3张的bug
@property (assign, nonatomic)BOOL shouldAnimate;

@end

@implementation NBPullToRefreshStopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.shouldAnimate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.shouldAnimate) {
        
    }
}

- (void)updateViewWithState:(ZYSVPullToRefreshState)state{
//    [self pullToRefreshViewChangeStateFrom:self.state toState:state];
    [super updateViewWithState:state];
}

- (void)pullToRefreshViewChangeStateFrom:(ZYSVPullToRefreshState)fromState
                                 toState:(ZYSVPullToRefreshState)toState{
    
}

@end
