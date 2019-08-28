//
//  BLTableViewController.m
//  BussinessLink
//
//  Created by Li Zhiping on 14-3-6.
//  Copyright (c) 2014年 djp. All rights reserved.
//

#import "NBTableViewController.h"
#import <Masonry/Masonry.h>

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    _tableView = nil;
}

#pragma mark - deprecated

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh{
    
}

- (void)triggerPullToRefresh{
    
}

- (void)pullToRefreshAction{
    
}

/*!
 *  trigger
 */
- (void)triggerPullRefreshAction{
    
}

- (void)stopPullAnnimation{
    
}

- (BOOL)isPullAnimation{
    return false;
}

- (BOOL)isInfiniteAnimation{
    return false;
}

#pragma mark -

- (void)setShowsInfiniteScrolling:(BOOL)showsInfiniteScrolling{
    
}

- (void)infiniteScrollingAction{
    
}

- (void)stopInfiniteAnimation{
    
}

@end
