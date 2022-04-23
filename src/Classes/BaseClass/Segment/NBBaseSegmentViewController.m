//
//  NBBaseSegmentViewController.m
//  Fish
//
//  Created by Li Zhiping on 5/5/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import "NBBaseSegmentViewController.h"
#import "NBSegmentView.h"
#import <Masonry/Masonry.h>
#import "UIView+FrameCategory.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface NBSegmentScrollView : UIScrollView

@property (weak, nonatomic)id <UIGestureRecognizerDelegate> panGestureDelegate;

@end

@implementation NBSegmentScrollView

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.panGestureRecognizer &&
        [self.panGestureDelegate respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [self.panGestureDelegate gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return NO;
}

@end

@interface NBBaseSegmentViewController ()<UIScrollViewDelegate, NBSegmentViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic)UIView <NBSegmentView> *titleSegment;

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, assign)BOOL shouldResize;

@property (strong, nonatomic)NSArray <UIViewController <NBBaseSegmentChildViewController> *>*segmentViewControllers;

@end

@implementation NBBaseSegmentViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self configViews];
}

- (void)configViews{
    
    NSInteger segmentCount = [self numberOfSegment];
    NSMutableArray *itemTitles = [NSMutableArray array];
    for (int i=0; i<segmentCount; i++) {
        [itemTitles addObject:[self titleForSegmentAtIndex:i]];
    }
    //顶部两 Button view
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i<itemTitles.count; i++) {
        NBSquareSegmentItem *item = [[NBSquareSegmentItem alloc] init];
        item.title = itemTitles[i];
        [items addObject:item];
    }
    CGFloat segmentViewHeight = [self segmentViewHeight];
    self.titleSegment = [[[self classForTitleSegment] alloc] initWithItems:items];
    [self.titleSegment setDelegate:self];
    
    if (self.segmentShowAtTopBar) {
        UIView *parentView = self.navigationController.navigationBar;
        CGFloat segmentWidth = 60 * [self numberOfSegment];
        [self.navigationController.navigationBar addSubview:self.titleSegment];
        [self.titleSegment setFrame:CGRectMake((parentView.width-segmentWidth)/2.0f, 0, segmentWidth, 44.0f)];
    }else{
        [self.view addSubview:self.titleSegment];
        [self.titleSegment mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(segmentViewHeight);
            make.top.mas_equalTo(0);
        }];
    }
    
    //容器view
    NBSegmentScrollView *scrollView = [[NBSegmentScrollView alloc] initWithFrame:CGRectMake(0, segmentViewHeight, self.view.width, self.view.height-segmentViewHeight)];
    [scrollView setPanGestureDelegate:self];
    [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO;
    [scrollView setDelegate:self];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    self.scrollView = scrollView;
    
    NSMutableArray *segmentViewControllers = [NSMutableArray array];
    
    for (int i=0; i<segmentCount; i++) {
        UIViewController <NBBaseSegmentChildViewController> *viewController = [self viewControllerForSegmentAtIndex:i];
        [self.scrollView addSubview:viewController.view];
        [self addChildViewController:viewController];
        [viewController.view setFrame:CGRectMake(self.view.width*i, 0, self.view.width, self.scrollView.height)];
        [segmentViewControllers addObject:viewController];
    }
    
    [self.view addSubview:self.scrollView];
    
    self.segmentViewControllers = segmentViewControllers;
    
    self.scrollView.panGestureRecognizer.delaysTouchesBegan = true;
}

- (CGFloat)segmentViewHeight{
    return 44.0f;
}

- (UIEdgeInsets)scrollViewInsets{
    return UIEdgeInsetsZero;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat segmentViewHeight = [self segmentViewHeight];
    NSInteger segmentCount = [self numberOfSegment];
    UIEdgeInsets insets = [self scrollViewInsets];
    
    if (self.segmentShowAtTopBar) {
        [self.scrollView setFrame:CGRectMake(insets.left, insets.top, self.view.width-insets.left-insets.right, self.view.height-insets.top-insets.bottom)];
    }else{
        [self.scrollView setFrame:CGRectMake(insets.left, insets.top+segmentViewHeight, self.view.width-insets.left-insets.right, self.view.height-insets.top-insets.bottom - segmentViewHeight)];
    }
    
    CGFloat contentWidth = segmentCount*self.scrollView.width;
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.scrollView.height);
    
    for (int i=0; i<segmentCount; i++) {
        UIViewController <NBBaseSegmentChildViewController>*viewController = [self.segmentViewControllers objectAtIndex:i];
        [viewController.view setFrame:CGRectMake(self.scrollView.width*i, 0, self.scrollView.width, self.scrollView.height)];
    }
    
    if (self.shouldResize) {
        self.shouldResize = NO;
        [self squareSegmentView:self.titleSegment didSelectedAtIndex:self.titleSegment.selectedIndex];
    }
}

#pragma mark - utils

- (void)setSegmentViewSelectedIndex:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    [self.titleSegment setSelectedIndex:index animated:NO];
}

- (void)updateChildControllerStatus:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    for (int i=0; i<self.segmentViewControllers.count; i++) {
        id <NBBaseSegmentChildViewController> vc = [self.segmentViewControllers objectAtIndex:i];
        BOOL isShow = NO;
        if (i == index) {
            isShow = YES;
            [vc updateDataIfNeed];
        }
        [vc setScrollsToTop:isShow];
    }
    
    [self willShowViewControllerAtIndex:index];
}

#pragma mark - scrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    for (int i=0; i<self.segmentViewControllers.count; i++) {
        id <NBBaseSegmentChildViewController> vc = [self.segmentViewControllers objectAtIndex:i];
        [vc setScrollViewScrollEnable:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滑动过程中的操作
    [self.titleSegment setOffsetWithScrollViewWidth:scrollView.width scrollViewOffset:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //调用 scrollToOffset 结束后的回调
    [self updateChildControllerStatus:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //滑动停止后，且之后不再自动滑动了
    if (!decelerate) {
        [self setSegmentViewSelectedIndex:scrollView];
        [self updateChildControllerStatus:scrollView];
        
        for (int i=0; i<self.segmentViewControllers.count; i++) {
            id <NBBaseSegmentChildViewController> vc = [self.segmentViewControllers objectAtIndex:i];
            [vc setScrollViewScrollEnable:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //滑动彻底结束后的操作
    [self setSegmentViewSelectedIndex:scrollView];
    [self updateChildControllerStatus:scrollView];
    
    for (int i=0; i<self.segmentViewControllers.count; i++) {
        id <NBBaseSegmentChildViewController> vc = [self.segmentViewControllers objectAtIndex:i];
        [vc setScrollViewScrollEnable:YES];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    self.shouldResize = YES;
}

#pragma mark - NBSegmentView delegate

- (void)squareSegmentView:(id<NBSegmentView>)segmentView didSelectedAtIndex:(NSInteger)index{
    CGFloat xOffset = index * self.scrollView.width;
    [self.scrollView setContentOffset:CGPointMake(xOffset, 0) animated:NO];
    [self updateChildControllerStatus:self.scrollView];
}

#pragma mark - NBBaseSegmentDataSource

- (NSInteger)numberOfSegment{
    return 0;
}

- (NSString *)titleForSegmentAtIndex:(NSInteger)index{
    return nil;
}

- (id <NBBaseSegmentChildViewController>)viewControllerForSegmentAtIndex:(NSInteger)index{
    return nil;
}

- (void)willShowViewControllerAtIndex:(NSInteger)index{
    
}

- (UIViewController *)currentViewController{
    if (self.titleSegment.selectedIndex < self.segmentViewControllers.count &&
        self.titleSegment.selectedIndex >= 0) {
        return [self.segmentViewControllers objectAtIndex:self.titleSegment.selectedIndex];
    }
    return nil;
}

- (Class)classForTitleSegment{
    return [NBSegmentView class];
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStatePossible) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)fullscreenPopGestureShouldBegin:(UIGestureRecognizer *)gesture{
    if (self.scrollView.contentOffset.x == 0.0f) {
        [self.scrollView setScrollEnabled:NO];
        return YES;
    }
    return NO;
}

- (void)fullscreenPopGestureDidEnded:(UIGestureRecognizer *)gesture{
    [self.scrollView setScrollEnabled:YES];
}

@end
