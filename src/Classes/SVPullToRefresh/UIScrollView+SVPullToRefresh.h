//
// UIScrollView+SVPullToRefresh.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

@class SVPullToRefreshView;

@interface UIScrollView (SVPullToRefresh)

- (void)zy_addPullToRefreshWithActionHandler:(void (^)(BOOL isTriggered))actionHandler;
- (void)zy_triggerPullToRefresh;

@property (nonatomic, strong, readonly) SVPullToRefreshView *zy_pullToRefreshView;
@property (nonatomic, assign) BOOL zy_showsPullToRefresh;
@property (nonatomic, assign) CGFloat zy_pullToRefreshViewHeight;

@end


enum {
    ZYSVPullToRefreshStateUnknown = 0,
    ZYSVPullToRefreshStateStopped,
    ZYSVPullToRefreshStateTriggered,
    ZYSVPullToRefreshStateLoading,
    ZYSVPullToRefreshStateAll = 10
};

typedef NSUInteger ZYSVPullToRefreshState;

@interface SVPullCustomRefreshView : UIView

@property (assign, nonatomic, readonly)ZYSVPullToRefreshState state;
@property (weak, nonatomic, readonly)UIScrollView *scrollView;

- (void)updateViewWithState:(ZYSVPullToRefreshState)state;

@end

@interface SVPullToRefreshView : UIView

@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;
@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property (nonatomic, readonly) ZYSVPullToRefreshState state;

//是否是通过triggerPullToRefresh来进行来下拉刷新的
@property (nonatomic, readonly) BOOL isTriggedWithMethod;

- (void)setTitle:(NSString *)title forState:(ZYSVPullToRefreshState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(ZYSVPullToRefreshState)state;
- (void)setCustomView:(SVPullCustomRefreshView *)view forState:(ZYSVPullToRefreshState)state;
- (SVPullCustomRefreshView *)customViewForState:(ZYSVPullToRefreshState)state;

- (void)startAnimating;
- (void)stopAnimating;

// deprecated; use setSubtitle:forState: instead
@property (nonatomic, strong, readonly) UILabel *dateLabel DEPRECATED_ATTRIBUTE;
@property (nonatomic, strong) NSDate *lastUpdatedDate DEPRECATED_ATTRIBUTE;
@property (nonatomic, strong) NSDateFormatter *dateFormatter DEPRECATED_ATTRIBUTE;

// deprecated; use [self.scrollView triggerPullToRefresh] instead
- (void)triggerRefresh DEPRECATED_ATTRIBUTE;

@end
