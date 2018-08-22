//
//  ViewController.m
//  CollectionViewTest
//
//  Created by Li Zhiping on 5/30/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import "NBBaseCollectionViewController.h"
#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"
#import "NBPullToRefreshLoadingView.h"
#import "NBPullToRefreshTriggerView.h"
#import "NBPullToRefreshStopView.h"
#import "NBMutableCollectionViewModel.h"
#import "NBCollectionCellFactory.h"
#import "NBCollectionHeaderViewObject.h"
#import "NBCollectionFooterViewObject.h"
#import "NBPullToRefreshBaseView.h"
#import <Masonry/Masonry.h>
#import "UIView+FrameCategory.h"

@interface NBBaseCollectionViewController ()

@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)UICollectionViewFlowLayout *collectionViewLayout;

@property (assign, nonatomic)BOOL isShowsPullToRefresh;
@property (assign, nonatomic)BOOL isShowsInfiniteScrolling;

@property (strong, nonatomic)NBCollectionActions *actions;

@end

@implementation NBBaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self resetActions];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //初始化下拉刷新和上拉加载更多操作
    __weak NBBaseCollectionViewController *weakSelf = self;
    [self.collectionView zy_addPullToRefreshWithActionHandler:^(BOOL isTriggered) {
        if (isTriggered) {
            [weakSelf triggerPullRefreshAction];
        }else{
            [weakSelf pullToRefreshAction];
        }
    }];
    [self.collectionView setZy_showsPullToRefresh:NO];
    
    [self.collectionView zy_addInfiniteScrollingWithActionHandler:^{
        [weakSelf infiniteScrollingAction];
    }];
    [self.collectionView setZy_showsInfiniteScrolling:NO];
    
    NBPullToRefreshLoadingView *refreshLoadingView = [[NBPullToRefreshLoadingView alloc] initWithFrame:CGRectZero];
    [self.collectionView.zy_pullToRefreshView setCustomView:refreshLoadingView forState:ZYSVPullToRefreshStateLoading];
    
    NBPullToRefreshTriggerView *refreshTriggerView = [[NBPullToRefreshTriggerView alloc] initWithFrame:CGRectZero];
    [self.collectionView.zy_pullToRefreshView setCustomView:refreshTriggerView forState:ZYSVPullToRefreshStateTriggered];
    
    NBPullToRefreshStopView *refreshStopView = [[NBPullToRefreshStopView alloc] initWithFrame:CGRectZero];
    [self.collectionView.zy_pullToRefreshView setCustomView:refreshStopView forState:ZYSVPullToRefreshStateStopped];
    [self.collectionView.zy_infiniteScrollingView setCustomView:refreshLoadingView forState:ZYSVInfiniteScrollingStateLoading];
    
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.collectionView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)resetActions{
    self.actions = [[NBCollectionActions alloc] initWithTarget:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object == self.collectionView) {
        if ([keyPath isEqualToString:@"frame"] ||
            [keyPath isEqualToString:@"contentOffset"]) {
            NBPullToRefreshBaseView *view = (NBPullToRefreshBaseView *)[self.collectionView.zy_pullToRefreshView customViewForState:ZYSVPullToRefreshStateLoading];
            [view scrollViewDidScroll:self.collectionView];
            view = (NBPullToRefreshBaseView *)[self.collectionView.zy_pullToRefreshView customViewForState:ZYSVPullToRefreshStateTriggered];
            [view scrollViewDidScroll:self.collectionView];
            view = (NBPullToRefreshBaseView *)[self.collectionView.zy_pullToRefreshView customViewForState:ZYSVPullToRefreshStateStopped];
            [view scrollViewDidScroll:self.collectionView];
        }
    }
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NBPullToRefreshBaseView *view = (NBPullToRefreshBaseView *)[self.collectionView.zy_pullToRefreshView customViewForState:ZYSVPullToRefreshStateLoading];
    [view scrollViewWillBeginDragging:self.collectionView];
    view = (NBPullToRefreshBaseView *)[self.collectionView.zy_pullToRefreshView customViewForState:ZYSVPullToRefreshStateTriggered];
    [view scrollViewWillBeginDragging:self.collectionView];
    view = (NBPullToRefreshBaseView *)[self.collectionView.zy_pullToRefreshView customViewForState:ZYSVPullToRefreshStateStopped];
    [view scrollViewWillBeginDragging:self.collectionView];
}

#pragma mark - load views

- (void)setDataSource:(NBMutableCollectionViewModel *)dataSource{
    if (_dataSource != dataSource) {
        [self willChangeValueForKey:@"dataSource"];
        _dataSource = dataSource;
        [self didChangeValueForKey:@"dataSource"];
        self.collectionView.dataSource = dataSource;
    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [self flowLayoutForCollectionView];
        self.collectionViewLayout = flowLayout;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayoutForCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumLineSpacing:4];
    [layout setMinimumInteritemSpacing:0];
    return layout;
}

- (UICollectionViewCell *)collectionViewModel:(NBCollectionViewModel *)collectionViewModel
                        cellForCollectionView:(UICollectionView *)collectionView
                                  atIndexPath:(NSIndexPath *)indexPath
                                   withObject:(id)object{
    return [NBCollectionCellFactory collectionViewModel:collectionViewModel cellForCollectionView:collectionView atIndexPath:indexPath withObject:object];
}

- (UICollectionReusableView *)collectionViewModel:(NBCollectionViewModel *)collectionViewModel collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    return [NBCollectionCellFactory collectionViewModel:collectionViewModel collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath withObject:object];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [NBCollectionCellFactory collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath model:self.dataSource];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return [NBCollectionCellFactory collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section model:self.dataSource];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return [NBCollectionCellFactory collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section model:self.dataSource];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.actions collectionView:collectionView
        didSelectItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(cellWillDisplay)]) {
        [cell performSelector:@selector(cellWillDisplay) withObject:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh{
    self.isShowsPullToRefresh = showsPullToRefresh;
    
    [self.collectionView setZy_showsPullToRefresh:showsPullToRefresh];
}

- (void)triggerPullToRefresh{
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView zy_triggerPullToRefresh];
    });
}

- (void)pullToRefreshAction{
    
}

/*!
 *  trigger
 */
- (void)triggerPullRefreshAction{
    
}

- (void)stopPullAnnimation{
    if (self.isShowsPullToRefresh && [self isPullAnimation]) {
        [self.collectionView.zy_pullToRefreshView stopAnimating];
    }
}

- (BOOL)isPullAnimation{
    return self.collectionView.zy_pullToRefreshView.state == ZYSVPullToRefreshStateLoading;
}

- (BOOL)isInfiniteAnimation{
    return self.collectionView.zy_infiniteScrollingView.state == ZYSVInfiniteScrollingStateLoading;
}

#pragma mark -

- (void)setShowsInfiniteScrolling:(BOOL)showsInfiniteScrolling{
    self.isShowsInfiniteScrolling = showsInfiniteScrolling;
    
    [self.collectionView setZy_showsInfiniteScrolling:showsInfiniteScrolling];
}

- (void)infiniteScrollingAction{
    
}

- (void)stopInfiniteAnimation{
    if ([self isInfiniteAnimation]) {
        [self.collectionView.zy_infiniteScrollingView stopAnimating];
    }
}

- (void)dealloc{
    [_collectionView removeObserver:self forKeyPath:@"contentOffset"];
    [_collectionView removeObserver:self forKeyPath:@"frame"];
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
    _collectionView = nil;
    _dataSource = nil;
    _actions = nil;
}

@end
