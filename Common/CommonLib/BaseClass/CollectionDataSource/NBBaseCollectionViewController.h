//
//  ViewController.h
//  CollectionViewTest
//
//  Created by Li Zhiping on 5/30/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBBaseViewController.h"
#import "NBMutableCollectionViewModel.h"
#import "NBCollectionActions.h"

@interface NBBaseCollectionViewController : NBBaseViewController<UICollectionViewDelegateFlowLayout,NBCollectionViewModelDelegate>

@property (strong, nonatomic)NBMutableCollectionViewModel *dataSource;

@property (strong, nonatomic, readonly)UICollectionView *collectionView;

@property (strong, nonatomic, readonly)UICollectionViewFlowLayout *collectionViewLayout;

//用于cell点击, tableView的delegate事件传递等操作
@property (strong, nonatomic, readonly) NBCollectionActions *actions;

- (void)resetActions;

//子类可以返回自定义参数的 flowLayout
- (UICollectionViewFlowLayout *)flowLayoutForCollectionView;

/**
 *  设置是否显示下拉刷新控件
 *
 *  @param showsPullToRefresh (YES为显示, NO为隐藏)
 */
- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh;

- (BOOL)isShowsPullToRefresh;

/*!
 *  触发下拉刷新
 */
- (void)triggerPullToRefresh;

/**
 *  下拉刷新时, 会回调的操作
 */
- (void)pullToRefreshAction;

/*!
 *  trigger 下拉刷新时, 会回调的操作
 */
- (void)triggerPullRefreshAction;

/**
 *  下拉刷新操作完成后, 停止下拉刷新动画
 */
- (void)stopPullAnnimation;

/**
 *  设置是否显示滑动到底部自动加载更多控件
 *
 *  @param showsInfiniteScrolling (YES为显示, NO为隐藏)
 */
- (void)setShowsInfiniteScrolling:(BOOL)showsInfiniteScrolling;

- (BOOL)isShowsInfiniteScrolling;
/**
 *  上拉加载更多时, 会回调的操作
 */
- (void)infiniteScrollingAction;

/**
 *  上拉加载更多操作完成后, 停止加载更多动画
 */
- (void)stopInfiniteAnimation;

@end

