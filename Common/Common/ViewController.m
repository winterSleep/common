//
//  ViewController.m
//  Common
//
//  Created by Li Zhiping on 2018/8/6.
//  Copyright © 2018 Lizhiping. All rights reserved.
//

#import "ViewController.h"
#import "XDCellCatalog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *cellObjects = [NSMutableArray array];
    XDTitleCellObject *object = [XDTitleCellObject objectWithTitle:@"123"];
    [cellObjects addObject:object];
    object = [XDTitleCellObject objectWithTitle:@"123"];
    [cellObjects addObject:object];
    object = [XDTitleCellObject objectWithTitle:@"123"];
    [cellObjects addObject:object];
    self.dataSource = [[NIMutableTableViewModel alloc] initWithListArray:cellObjects delegate:self];
    [self.tableView reloadData];
    [self setShowsPullToRefresh:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
