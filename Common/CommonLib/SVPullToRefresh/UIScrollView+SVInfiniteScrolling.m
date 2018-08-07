//
// UIScrollView+SVInfiniteScrolling.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVInfiniteScrolling.h"


static CGFloat const SVInfiniteScrollingViewHeight = 60;

@interface SVInfiniteScrollingDotView : UIView

@property (nonatomic, strong) UIColor *arrowColor;

@end



@interface SVInfiniteScrollingView ()

@property (nonatomic, copy) void (^infiniteScrollingHandler)(void);

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, readwrite) ZYSVInfiniteScrollingState state;
@property (nonatomic, strong) NSMutableArray *viewForState;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;

@end



#pragma mark - UIScrollView (SVInfiniteScrollingView)
#import <objc/runtime.h>

static char ZYUIScrollViewInfiniteScrollingView;
UIEdgeInsets scrollViewOriginalContentInsets;

@implementation UIScrollView (SVInfiniteScrolling)

@dynamic zy_infiniteScrollingView;

- (void)zy_addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler {
    
    if(!self.zy_infiniteScrollingView) {
        SVInfiniteScrollingView *view = [[SVInfiniteScrollingView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.bounds.size.width, SVInfiniteScrollingViewHeight)];
        view.infiniteScrollingHandler = actionHandler;
        view.scrollView = self;
        [self addSubview:view];
        
        view.originalBottomInset = self.contentInset.bottom;
        self.zy_infiniteScrollingView = view;
        self.zy_showsInfiniteScrolling = YES;
    }
}

- (void)zy_triggerInfiniteScrolling {
    self.zy_infiniteScrollingView.state = ZYSVInfiniteScrollingStateTriggered;
    [self.zy_infiniteScrollingView startAnimating];
}

- (void)setZy_infiniteScrollingView:(SVInfiniteScrollingView *)infiniteScrollingView {
    [self willChangeValueForKey:@"zy_infiniteScrollingView"];
    objc_setAssociatedObject(self, &ZYUIScrollViewInfiniteScrollingView,
                             infiniteScrollingView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"zy_infiniteScrollingView"];
}

- (SVInfiniteScrollingView *)zy_infiniteScrollingView {
    return objc_getAssociatedObject(self, &ZYUIScrollViewInfiniteScrollingView);
}

- (void)setZy_showsInfiniteScrolling:(BOOL)showsInfiniteScrolling {
    self.zy_infiniteScrollingView.hidden = !showsInfiniteScrolling;
    
    if(!showsInfiniteScrolling) {
      if (self.zy_infiniteScrollingView.isObserving) {
        [self removeObserver:self.zy_infiniteScrollingView forKeyPath:@"contentOffset"];
        [self removeObserver:self.zy_infiniteScrollingView forKeyPath:@"contentSize"];
        [self.zy_infiniteScrollingView resetScrollViewContentInset];
        self.zy_infiniteScrollingView.isObserving = NO;
      }
    }
    else {
      if (!self.zy_infiniteScrollingView.isObserving) {
        [self addObserver:self.zy_infiniteScrollingView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self.zy_infiniteScrollingView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        self.zy_infiniteScrollingView.originalBottomInset = self.contentInset.bottom;
        [self.zy_infiniteScrollingView setScrollViewContentInsetForInfiniteScrolling];
        self.zy_infiniteScrollingView.isObserving = YES;
          
        [self.zy_infiniteScrollingView setNeedsLayout];
        self.zy_infiniteScrollingView.frame = CGRectMake(0, self.contentSize.height, self.zy_infiniteScrollingView.bounds.size.width, SVInfiniteScrollingViewHeight);
      }
    }
}

- (BOOL)zy_showsInfiniteScrolling {
    return !self.zy_infiniteScrollingView.hidden;
}

@end


#pragma mark - SVInfiniteScrollingView
@implementation SVInfiniteScrollingView

// public properties
@synthesize infiniteScrollingHandler, activityIndicatorViewStyle;

@synthesize state = _state;
@synthesize scrollView = _scrollView;
@synthesize activityIndicatorView = _activityIndicatorView;

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        // default styling values
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = ZYSVInfiniteScrollingStateUnknown;
        self.enabled = YES;
        
        self.viewForState = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", nil];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.zy_showsInfiniteScrolling) {
          if (self.isObserving) {
            [scrollView removeObserver:self forKeyPath:@"contentOffset"];
            [scrollView removeObserver:self forKeyPath:@"contentSize"];
            self.isObserving = NO;
          }
        }
    }
}

- (void)layoutSubviews {
    self.activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = self.originalBottomInset;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForInfiniteScrolling {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = self.originalBottomInset + SVInfiniteScrollingViewHeight;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:NULL];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {    
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.bounds.size.width, SVInfiniteScrollingViewHeight);
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if(self.state != ZYSVInfiniteScrollingStateLoading && self.enabled) {
        CGFloat scrollViewContentHeight = self.scrollView.contentSize.height;
        CGFloat scrollOffsetThreshold = scrollViewContentHeight-self.scrollView.bounds.size.height;
        if(!self.scrollView.isDragging && self.state == ZYSVInfiniteScrollingStateTriggered)
            self.state = ZYSVInfiniteScrollingStateLoading;
        else if(contentOffset.y > scrollOffsetThreshold && self.state == ZYSVInfiniteScrollingStateStopped && self.scrollView.isDragging){
            self.state = ZYSVInfiniteScrollingStateTriggered;
        }
        else if(contentOffset.y < scrollOffsetThreshold  && self.state != ZYSVInfiniteScrollingStateStopped)
            self.state = ZYSVInfiniteScrollingStateStopped;
    }
}

#pragma mark - Getters

- (UIActivityIndicatorView *)activityIndicatorView {
    if(!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    return self.activityIndicatorView.activityIndicatorViewStyle;
}

#pragma mark - Setters

- (void)setCustomView:(UIView *)view forState:(ZYSVInfiniteScrollingState)state {
    id viewPlaceholder = view;
    
    if(!viewPlaceholder)
        viewPlaceholder = @"";
    
    if(state == ZYSVInfiniteScrollingStateAll)
        [self.viewForState replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[viewPlaceholder, viewPlaceholder, viewPlaceholder]];
    else
        [self.viewForState replaceObjectAtIndex:state withObject:viewPlaceholder];
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

#pragma mark -

- (void)triggerRefresh {
    self.state = ZYSVInfiniteScrollingStateTriggered;
    self.state = ZYSVInfiniteScrollingStateLoading;
}

- (void)startAnimating{
    self.state = ZYSVInfiniteScrollingStateLoading;
}

- (void)stopAnimating {
    self.state = ZYSVInfiniteScrollingStateStopped;
}

- (void)setState:(ZYSVInfiniteScrollingState)newState {
    
    if(_state == newState)
        return;
    
    ZYSVInfiniteScrollingState previousState = _state;
    _state = newState;
    
    if (_state != ZYSVInfiniteScrollingStateUnknown) {
        id customView = [self.viewForState objectAtIndex:_state];
        BOOL hasCustomView = [customView isKindOfClass:[UIView class]];
        if(hasCustomView) {
            for(id otherView in self.viewForState) {
                if([otherView isKindOfClass:[UIView class]]){
                    if (otherView != customView) {
                        [otherView removeFromSuperview];
                    }
                }
            }
            [self addSubview:customView];
            [customView setFrame:self.bounds];
        }
        else {
            CGRect viewBounds = [self.activityIndicatorView bounds];
            CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
            [self.activityIndicatorView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
            
            switch (newState) {
                case ZYSVInfiniteScrollingStateStopped:
                    [self.activityIndicatorView stopAnimating];
                    break;
                    
                case ZYSVInfiniteScrollingStateTriggered:
                    break;
                    
                case ZYSVInfiniteScrollingStateLoading:
                    [self.activityIndicatorView startAnimating];
                    break;
            }
        }
        
        if(previousState == ZYSVInfiniteScrollingStateTriggered && newState == ZYSVInfiniteScrollingStateLoading && self.infiniteScrollingHandler && self.enabled)
            self.infiniteScrollingHandler();
    }
}

@end
