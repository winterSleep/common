//
// UIScrollView+SVInfiniteScrolling.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <UIKit/UIKit.h>

@class SVInfiniteScrollingView;

@interface UIScrollView (SVInfiniteScrolling)

- (void)zy_addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
- (void)zy_triggerInfiniteScrolling;

@property (nonatomic, strong, readonly) SVInfiniteScrollingView *zy_infiniteScrollingView;
@property (nonatomic, assign) BOOL zy_showsInfiniteScrolling;

@end


enum {
    ZYSVInfiniteScrollingStateUnknown = 0,
	ZYSVInfiniteScrollingStateStopped,
    ZYSVInfiniteScrollingStateTriggered,
    ZYSVInfiniteScrollingStateLoading,
    ZYSVInfiniteScrollingStateAll = 10
};

typedef NSUInteger ZYSVInfiniteScrollingState;

@interface SVInfiniteScrollingView : UIView

@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic, readonly) ZYSVInfiniteScrollingState state;
@property (nonatomic, readwrite) BOOL enabled;

- (void)setCustomView:(UIView *)view forState:(ZYSVInfiniteScrollingState)state;

- (void)startAnimating;
- (void)stopAnimating;

//scrollView contentInset 变化时, 需要设置一下它.
@property (nonatomic, readwrite) CGFloat originalBottomInset;
- (void)setScrollViewContentInsetForInfiniteScrolling;

@end
