//
//  BLTableViewController.h
//  BussinessLink
//
//  Created by Li Zhiping on 14-3-6.
//  Copyright (c) 2014年 djp. All rights reserved.
//

#import "NBBaseViewController.h"

@interface NBTableViewController : NBBaseViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
}

- (id)initWithStyle:(UITableViewStyle)style;

@property (strong, nonatomic) UITableView *tableView;

/**
 * A Boolean value indicating if the controller clears the selection when the table appears.
 * Default is YES.
 */
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

/////////////////以下api被废弃//////////////////

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
