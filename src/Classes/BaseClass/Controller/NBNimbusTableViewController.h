//
//  NBNimbusTableViewController.h
//  NBChat
//
//  Created by Li Zhiping on 11/26/14.
//  Copyright (c) 2014 Li Zhiping. All rights reserved.
//

#import "NBTableViewController.h"
#import <Nimbus/NimbusModels.h>

@interface NBNimbusTableViewController : NBTableViewController< NIMutableTableViewModelDelegate>{
    NIMutableTableViewModel *_dataSource;
}

//tableView的数据源
@property (strong, nonatomic) NIMutableTableViewModel *dataSource;

//用于cell点击, tableView的delegate事件传递等操作
@property (strong, nonatomic, readonly) NITableViewActions *actions;

- (void)resetActions;

@end
