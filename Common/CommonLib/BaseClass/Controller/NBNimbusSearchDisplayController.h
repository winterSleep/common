//
//  NBNimbusSearchDisplayController.h
//  Fish
//
//  Created by Li Zhiping on 12/18/15.
//  Copyright © 2015 Li Zhiping. All rights reserved.
//

#import "NBSearchDisplayController.h"
#import <Nimbus/NimbusModels.h>

@interface NBNimbusSearchDisplayController : NBSearchDisplayController<NIMutableTableViewModelDelegate, UITableViewDelegate>{
    NIMutableTableViewModel *_dataSource;
}

//tableView的数据源
@property (strong, nonatomic) NIMutableTableViewModel *dataSource;

//用于cell点击, tableView的delegate事件传递等操作
@property (strong, nonatomic, readonly) NITableViewActions *actions;

- (void)resetActions;

@end
