//
//  BLTableViewController.m
//  BussinessLink
//
//  Created by Li Zhiping on 14-3-6.
//  Copyright (c) 2014年 djp. All rights reserved.
//

#import "NBTableViewController.h"
#import <Masonry/Masonry.h>
#import "SVPullToRefresh.h"
#import "NBPullToRefreshLoadingView.h"
#import "NBPullToRefreshTriggerView.h"
#import "NBPullToRefreshStopView.h"
#import "NBPullToRefreshBaseView.h"

@interface NBTableViewController ()
{
    UITableViewStyle _tableViewStyle;
}

@property (assign, nonatomic)BOOL isShowsPullToRefresh;
@property (assign, nonatomic)BOOL isShowsInfiniteScrolling;

@end

@implementation NBTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.clearsSelectionOnViewWillAppear = YES;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _tableViewStyle = style;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //初始化下拉刷新和上拉加载更多操作
    __weak NBTableViewController *weakSelf = self;
    [self.tableView zy_addPullToRefreshWithActionHandler:^(BOOL isTriggered) {
        if (isTriggered) {
            [weakSelf triggerPullRefreshAction];
        }else{
            [weakSelf pullToRefreshAction];
        }
    }];
    [self.tableView setZy_showsPullToRefresh:NO];
    
    [self.tableView zy_addInfiniteScrollingWithActionHandler:^{
        [weakSelf infiniteScrollingAction];
    }];
    [self.tableView setZy_showsInfiniteScrolling:NO];
    
    NBPullToRefreshLoadingView *refreshLoadingView = [[NBPullToRefreshLoadingView alloc] initWithFrame:CGRectZero];
    [self.tableView.zy_pullToRefreshView setCustomView:refreshLoadingView forState:ZYSVPullToRefreshStateLoading];
    
    NBPullToRefreshTriggerView *refreshTriggerView = [[NBPullToRefreshTriggerView alloc] initWithFrame:CGRectZero];
    [self.tableView.zy_pullToRefreshView setCustomView:refreshTriggerView forState:ZYSVPullToRefreshStateTriggered];
    
    NBPullToRefreshStopView *refreshStopView = [[NBPullToRefreshStopView alloc] initWithFrame:CGRectZero];
    [self.tableView.zy_pullToRefreshView setCustomView:refreshStopView forState:ZYSVPullToRefreshStateStopped];
    
    [self.tableView.zy_infiniteScrollingView setCustomView:refreshLoadingView forState:ZYSVInfiniteScrollingStateLoading];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object == self.tableView) {
        if ([keyPath isEqualToString:@"frame"] ||
            [keyPath isEqualToString:@"contentOffset"]) {
            NBPullToRefreshBaseView *view = (NBPullToRefreshBaseView *)[self.tableView.zy_pullToRefreshView customViewForState:ZYSVPullToRefreshStateLoading];
            [view scrollViewDidScroll:self.tableView];
            view = (NBPullToRefreshBaseView *)[self.tableView.zy_pullToRefreshView customViewForState:ZYSVPullToRefreshStateTriggered];
            [view scrollViewDidScroll:self.tableView];
            view = (NBPullToRefreshBaseView *)[self.tableView.zy_pullToRefreshView customViewForState:ZYSVPullToRefreshStateStopped];
            [view scrollViewDidScroll:self.tableView];
        }
    }
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
    }
    return _tableView;
}

- (void)setTableView:(UITableView *)tableView{
    if (tableView != _tableView) {
        _tableView = tableView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_clearsSelectionOnViewWillAppear) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - TableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NBPullToRefreshBaseView *view = (NBPullToRefreshBaseView *)[self.tableView.zy_pullToRefreshView customViewForState:ZYSVPullToRefreshStateLoading];
    [view scrollViewWillBeginDragging:self.tableView];
    view = (NBPullToRefreshBaseView *)[self.tableView.zy_pullToRefreshView customViewForState:ZYSVPullToRefreshStateTriggered];
    [view scrollViewWillBeginDragging:self.tableView];
    view = (NBPullToRefreshBaseView *)[self.tableView.zy_pullToRefreshView customViewForState:ZYSVPullToRefreshStateStopped];
    [view scrollViewWillBeginDragging:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark -

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh{
    self.isShowsPullToRefresh = showsPullToRefresh;
    
    [self.tableView setZy_showsPullToRefresh:showsPullToRefresh];
}

- (void)triggerPullToRefresh{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView zy_triggerPullToRefresh];
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
        [self.tableView.zy_pullToRefreshView stopAnimating];
    }
}

- (BOOL)isPullAnimation{
    return self.tableView.zy_pullToRefreshView.state == ZYSVPullToRefreshStateLoading;
}

- (BOOL)isInfiniteAnimation{
    return self.tableView.zy_infiniteScrollingView.state == ZYSVInfiniteScrollingStateLoading;
}

#pragma mark -

- (void)setShowsInfiniteScrolling:(BOOL)showsInfiniteScrolling{
    self.isShowsInfiniteScrolling = showsInfiniteScrolling;
    
    [self.tableView setZy_showsInfiniteScrolling:showsInfiniteScrolling];
}

- (void)infiniteScrollingAction{
    
}

- (void)stopInfiniteAnimation{
    if ([self isInfiniteAnimation]) {
        [self.tableView.zy_infiniteScrollingView stopAnimating];
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
    [_tableView removeObserver:self forKeyPath:@"frame"];
    _tableView = nil;
}

@end
