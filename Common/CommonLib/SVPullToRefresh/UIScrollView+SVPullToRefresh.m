//
// UIScrollView+SVPullToRefresh.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVPullToRefresh.h"

//fequalzro() from http://stackoverflow.com/a/1614761/184130
#define fequalzero(a) (fabs(a) < FLT_EPSILON)

@interface SVPullToRefreshArrow : UIView

@property (nonatomic, strong) UIColor *arrowColor;

@end


@interface SVPullToRefreshView ()

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(BOOL isTriggered);

@property (nonatomic, strong) SVPullToRefreshArrow *arrow;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *subtitleLabel;
@property (nonatomic, readwrite) ZYSVPullToRefreshState state;
@property (nonatomic, readwrite) BOOL isTriggedWithMethod;

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *subtitles;
@property (nonatomic, strong) NSMutableArray *viewForState;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalTopInset;

@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL showsPullToRefresh;
@property (nonatomic, assign) BOOL showsDateLabel;
@property(nonatomic, assign) BOOL isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForLoading;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;
- (void)rotateArrow:(float)degrees hide:(BOOL)hide;

@end



#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char ZYUIScrollViewPullToRefreshView;
static char ZYUIScrollViewPullToRefreshViewHeight;

@implementation UIScrollView (SVPullToRefresh)

@dynamic zy_pullToRefreshView, zy_showsPullToRefresh, zy_pullToRefreshViewHeight;

- (void)zy_addPullToRefreshWithActionHandler:(void (^)(BOOL isTriggered))actionHandler {
    
    if(!self.zy_pullToRefreshView) {
        if (self.zy_pullToRefreshViewHeight <= 0) {
            self.zy_pullToRefreshViewHeight = 60.0f;
        }
        SVPullToRefreshView *view = [[SVPullToRefreshView alloc] initWithFrame:CGRectMake(0, -self.zy_pullToRefreshViewHeight, self.bounds.size.width, self.zy_pullToRefreshViewHeight)];
        view.pullToRefreshActionHandler = actionHandler;
        view.scrollView = self;
        [self addSubview:view];
        
        view.originalTopInset = self.contentInset.top;
        self.zy_pullToRefreshView = view;
        self.zy_showsPullToRefresh = YES;
    }
}

- (void)zy_triggerPullToRefresh {
    if (self.zy_pullToRefreshView.state != ZYSVPullToRefreshStateLoading) {
        self.zy_pullToRefreshView.isTriggedWithMethod = YES;
        self.zy_pullToRefreshView.state = ZYSVPullToRefreshStateTriggered;
        [self.zy_pullToRefreshView startAnimating];
    }
}

- (void)setZy_pullToRefreshView:(SVPullToRefreshView *)pullToRefreshView {
    [self willChangeValueForKey:@"zy_triggerPullToRefresh"];
    objc_setAssociatedObject(self, &ZYUIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"zy_triggerPullToRefresh"];
}

- (SVPullToRefreshView *)zy_pullToRefreshView {
    return objc_getAssociatedObject(self, &ZYUIScrollViewPullToRefreshView);
}

- (void)setZy_pullToRefreshViewHeight:(CGFloat)zy_pullToRefreshViewHeight{
    [self willChangeValueForKey:@"zy_pullToRefreshViewHeight"];
    objc_setAssociatedObject(self, &ZYUIScrollViewPullToRefreshViewHeight,
                             @(zy_pullToRefreshViewHeight),
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (self.zy_pullToRefreshView) {
        [self.zy_pullToRefreshView setFrame:CGRectMake(0, -zy_pullToRefreshViewHeight, self.bounds.size.width, zy_pullToRefreshViewHeight)];
    }
    
    [self didChangeValueForKey:@"zy_pullToRefreshViewHeight"];
}

- (CGFloat)zy_pullToRefreshViewHeight {
    return [objc_getAssociatedObject(self, &ZYUIScrollViewPullToRefreshViewHeight) floatValue];
}

- (void)setZy_showsPullToRefresh:(BOOL)showsPullToRefresh {
    self.zy_pullToRefreshView.hidden = !showsPullToRefresh;
    
    if(!showsPullToRefresh) {
        if (self.zy_pullToRefreshView.isObserving) {
            [self removeObserver:self.zy_pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.zy_pullToRefreshView forKeyPath:@"frame"];
            [self.zy_pullToRefreshView resetScrollViewContentInset];
            self.zy_pullToRefreshView.isObserving = NO;
        }
    }
    else {
        if (!self.zy_pullToRefreshView.isObserving) {
            [self addObserver:self.zy_pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.zy_pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.zy_pullToRefreshView.isObserving = YES;
        }
    }
}

- (BOOL)zy_showsPullToRefresh {
    return !self.zy_pullToRefreshView.hidden;
}

@end

@interface SVPullCustomRefreshView ()

@property (assign, nonatomic)ZYSVPullToRefreshState state;
@property (weak, nonatomic)UIScrollView *scrollView;

- (void)updateViewWithState:(ZYSVPullToRefreshState)state;

@end

@implementation SVPullCustomRefreshView

- (void)updateViewWithState:(ZYSVPullToRefreshState)state{
    self.state = state;
}

@end

#pragma mark - SVPullToRefresh
@implementation SVPullToRefreshView

// public properties
@synthesize pullToRefreshActionHandler, arrowColor, textColor, activityIndicatorViewStyle, lastUpdatedDate, dateFormatter;

@synthesize state = _state;
@synthesize scrollView = _scrollView;
@synthesize showsPullToRefresh = _showsPullToRefresh;
@synthesize arrow = _arrow;
@synthesize activityIndicatorView = _activityIndicatorView;

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;


- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        // default styling values
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.textColor = [UIColor darkGrayColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = ZYSVPullToRefreshStateUnknown;
        self.showsDateLabel = NO;
        
        self.titles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Pull to refresh...",),
                       NSLocalizedString(@"Pull to refresh...",),
                       NSLocalizedString(@"Release to refresh...",),
                       NSLocalizedString(@"Loading...",),
                       nil];
        
        self.subtitles = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", nil];
        self.viewForState = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", nil];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        //use self.superview, not self.scrollView. Why self.scrollView == nil here?
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.zy_showsPullToRefresh) {
            if (self.isObserving) {
                //If enter this branch, it is the moment just before "SVPullToRefreshView's dealloc", so remove observer here
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.state == ZYSVPullToRefreshStateUnknown) {
        return;
    }
    
    CGFloat remainingWidth = self.superview.bounds.size.width-200;
    float position = 0.50;
    
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = ceilf(remainingWidth*position+44);
    titleFrame.origin.y = self.bounds.size.height-(self.subtitleLabel.text ? 48 : 40);
    self.titleLabel.frame = titleFrame;
    
    CGRect subtitleFrame = self.subtitleLabel.frame;
    subtitleFrame.origin.x = titleFrame.origin.x;
    subtitleFrame.origin.y = self.bounds.size.height-32;
    self.subtitleLabel.frame = subtitleFrame;
    
    CGRect arrowFrame = self.arrow.frame;
    arrowFrame.origin.x = ceilf(remainingWidth*position);
    self.arrow.frame = arrowFrame;
    
    self.activityIndicatorView.center = self.arrow.center;
    
    id customView = [self.viewForState objectAtIndex:self.state];
    BOOL hasCustomView = [customView isKindOfClass:[SVPullCustomRefreshView class]];
    
    self.titleLabel.hidden = hasCustomView;
    self.subtitleLabel.hidden = hasCustomView;
    self.arrow.hidden = hasCustomView;
    
    if(hasCustomView) {
        [customView setFrame:self.bounds];
    }
    else {
        self.titleLabel.text = [self.titles objectAtIndex:self.state];
        
        NSString *subtitle = [self.subtitles objectAtIndex:self.state];
        if(subtitle.length > 0)
            self.subtitleLabel.text = subtitle;
        
        switch (self.state) {
            case ZYSVPullToRefreshStateStopped:
                self.arrow.alpha = 1;
                [self.activityIndicatorView stopAnimating];
                [self rotateArrow:0 hide:NO];
                break;
                
            case ZYSVPullToRefreshStateTriggered:
                [self rotateArrow:(float)M_PI hide:NO];
                break;
                
            case ZYSVPullToRefreshStateLoading:
                [self.activityIndicatorView startAnimating];
                [self rotateArrow:0 hide:YES];
                break;
        }
    }
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset;
    [self setScrollViewContentInset:currentInsets isReset:YES];
}

- (void)setScrollViewContentInsetForLoading {
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = MIN(offset, self.originalTopInset + self.bounds.size.height);
    [self setScrollViewContentInset:currentInsets isReset:NO];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset isReset:(BOOL)isReset{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                         if (!isReset) {
                             if (self.originalTopInset != 0) {
                                 [self.scrollView setContentOffset:CGPointMake(0, -self.originalTopInset - self.bounds.size.height)];
                             }
                         }
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if(self.state != ZYSVPullToRefreshStateLoading) {
        CGFloat scrollOffsetThreshold = self.frame.origin.y-self.originalTopInset;
        
        if(!self.scrollView.isDragging && self.state == ZYSVPullToRefreshStateTriggered)
            self.state = ZYSVPullToRefreshStateLoading;
        else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == ZYSVPullToRefreshStateStopped)
            self.state = ZYSVPullToRefreshStateTriggered;
        else if(contentOffset.y >= scrollOffsetThreshold && self.state != ZYSVPullToRefreshStateStopped)
            self.state = ZYSVPullToRefreshStateStopped;
    } else  {
//        CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
//        offset = MIN(offset, self.originalTopInset + self.bounds.size.height);
//        UIEdgeInsets contentInset = self.scrollView.contentInset;
//        self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
    }
}

#pragma mark - Getters

- (SVPullToRefreshArrow *)arrow {
    if(!_arrow) {
        _arrow = [[SVPullToRefreshArrow alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-54, 22, 48)];
        _arrow.backgroundColor = [UIColor clearColor];
        [self addSubview:_arrow];
    }
    return _arrow;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if(!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
        _titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = textColor;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if(!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.textColor = textColor;
        [self addSubview:_subtitleLabel];
    }
    return _subtitleLabel;
}

- (UILabel *)dateLabel {
    return self.showsDateLabel ? self.subtitleLabel : nil;
}

- (NSDateFormatter *)dateFormatter {
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        dateFormatter.locale = [NSLocale currentLocale];
    }
    return dateFormatter;
}

- (UIColor *)arrowColor {
    return self.arrow.arrowColor; // pass through
}

- (UIColor *)textColor {
    return self.titleLabel.textColor;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    return self.activityIndicatorView.activityIndicatorViewStyle;
}

#pragma mark - Setters

- (void)setArrowColor:(UIColor *)newArrowColor {
    self.arrow.arrowColor = newArrowColor; // pass through
    [self.arrow setNeedsDisplay];
}

- (void)setTitle:(NSString *)title forState:(ZYSVPullToRefreshState)state {
    if(!title)
        title = @"";
    
    if(state == ZYSVPullToRefreshStateAll)
        [self.titles replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[title, title, title]];
    else
        [self.titles replaceObjectAtIndex:state withObject:title];
    
    [self setNeedsLayout];
}

- (void)setSubtitle:(NSString *)subtitle forState:(ZYSVPullToRefreshState)state {
    if(!subtitle)
        subtitle = @"";
    
    if(state == ZYSVPullToRefreshStateAll)
        [self.subtitles replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[subtitle, subtitle, subtitle]];
    else
        [self.subtitles replaceObjectAtIndex:state withObject:subtitle];
    
    [self setNeedsLayout];
}

- (void)setCustomView:(SVPullCustomRefreshView *)view forState:(ZYSVPullToRefreshState)state {
    id viewPlaceholder = view;
    
    if(!viewPlaceholder)
        viewPlaceholder = @"";
    
    if(state == ZYSVPullToRefreshStateAll)
        [self.viewForState replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[viewPlaceholder, viewPlaceholder, viewPlaceholder]];
    else
        [self.viewForState replaceObjectAtIndex:state withObject:viewPlaceholder];
}

- (void)setTextColor:(UIColor *)newTextColor {
    textColor = newTextColor;
    self.titleLabel.textColor = newTextColor;
    self.subtitleLabel.textColor = newTextColor;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

- (void)setLastUpdatedDate:(NSDate *)newLastUpdatedDate {
    self.showsDateLabel = YES;
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@",), newLastUpdatedDate?[self.dateFormatter stringFromDate:newLastUpdatedDate]:NSLocalizedString(@"Never",)];
}

- (void)setDateFormatter:(NSDateFormatter *)newDateFormatter {
    dateFormatter = newDateFormatter;
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@",), self.lastUpdatedDate?[newDateFormatter stringFromDate:self.lastUpdatedDate]:NSLocalizedString(@"Never",)];
}

#pragma mark -

- (void)triggerRefresh {
    [self.scrollView zy_triggerPullToRefresh];
}

- (void)startAnimating{
    if(fequalzero(self.scrollView.contentOffset.y)) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.frame.size.height) animated:YES];
        self.wasTriggeredByUser = NO;
    }
    else
        self.wasTriggeredByUser = YES;
    
    self.state = ZYSVPullToRefreshStateLoading;
}

- (void)stopAnimating {
    self.state = ZYSVPullToRefreshStateStopped;
    
    if(!self.wasTriggeredByUser)
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.originalTopInset) animated:YES];
}

- (SVPullCustomRefreshView *)customViewForState:(ZYSVPullToRefreshState)state{
    return [self.viewForState objectAtIndex:state];
}

- (void)setState:(ZYSVPullToRefreshState)newState {
    
    if(_state == newState)
        return;
    
    ZYSVPullToRefreshState previousState = _state;
    _state = newState;
    
    if (_state != ZYSVPullToRefreshStateUnknown) {
        SVPullCustomRefreshView *customView = [self.viewForState objectAtIndex:_state];
        BOOL hasCustomView = [customView isKindOfClass:[SVPullCustomRefreshView class]];
        if(hasCustomView) {
            for(SVPullCustomRefreshView *otherView in self.viewForState) {
                if([otherView isKindOfClass:[SVPullCustomRefreshView class]]){
                    if (otherView != customView) {
                        [otherView removeFromSuperview];
                        [otherView updateViewWithState:_state];
                    }
                }
            }
            [customView updateViewWithState:_state];
            [self addSubview:customView];
        }
        
        [self setNeedsLayout];
        
        switch (newState) {
            case ZYSVPullToRefreshStateStopped:
                [self resetScrollViewContentInset];
                break;
                
            case ZYSVPullToRefreshStateTriggered:
                break;
                
            case ZYSVPullToRefreshStateLoading:
                [self setScrollViewContentInsetForLoading];
                
                if(previousState == ZYSVPullToRefreshStateTriggered && pullToRefreshActionHandler)
                    pullToRefreshActionHandler(self.isTriggedWithMethod);
                self.isTriggedWithMethod = NO;
                break;
        }
    }
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        self.arrow.layer.opacity = !hide;
        //[self.arrow setNeedsDisplay];//ios 4
    } completion:NULL];
}

@end


#pragma mark - SVPullToRefreshArrow

@implementation SVPullToRefreshArrow
@synthesize arrowColor;

- (UIColor *)arrowColor {
    if (arrowColor) return arrowColor;
    return [UIColor grayColor]; // default Color
}

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    // the rects above the arrow
    CGContextAddRect(c, CGRectMake(5, 0, 12, 4)); // to-do: use dynamic points
    CGContextAddRect(c, CGRectMake(5, 6, 12, 4)); // currently fixed size: 22 x 48pt
    CGContextAddRect(c, CGRectMake(5, 12, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 18, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 24, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 30, 12, 4));
    
    // the arrow
    CGContextMoveToPoint(c, 0, 34);
    CGContextAddLineToPoint(c, 11, 48);
    CGContextAddLineToPoint(c, 22, 34);
    CGContextAddLineToPoint(c, 0, 34);
    CGContextClosePath(c);
    
    CGContextSaveGState(c);
    CGContextClip(c);
    
    // Gradient Declaration
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat alphaGradientLocations[] = {0, 0.8f};
    
    CGGradientRef alphaGradient = nil;
    if([[[UIDevice currentDevice] systemVersion]floatValue] >= 5){
        NSArray* alphaGradientColors = [NSArray arrayWithObjects:
                                        (id)[self.arrowColor colorWithAlphaComponent:0].CGColor,
                                        (id)[self.arrowColor colorWithAlphaComponent:1].CGColor,
                                        nil];
        alphaGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)alphaGradientColors, alphaGradientLocations);
    }else{
        const CGFloat * components = CGColorGetComponents([self.arrowColor CGColor]);
        int numComponents = (int)CGColorGetNumberOfComponents([self.arrowColor CGColor]);
        CGFloat colors[8];
        switch(numComponents){
            case 2:{
                colors[0] = colors[4] = components[0];
                colors[1] = colors[5] = components[0];
                colors[2] = colors[6] = components[0];
                break;
            }
            case 4:{
                colors[0] = colors[4] = components[0];
                colors[1] = colors[5] = components[1];
                colors[2] = colors[6] = components[2];
                break;
            }
        }
        colors[3] = 0;
        colors[7] = 1;
        alphaGradient = CGGradientCreateWithColorComponents(colorSpace,colors,alphaGradientLocations,2);
    }
    
    
    CGContextDrawLinearGradient(c, alphaGradient, CGPointZero, CGPointMake(0, rect.size.height), 0);
    
    CGContextRestoreGState(c);
    
    CGGradientRelease(alphaGradient);
    CGColorSpaceRelease(colorSpace);
}
@end
