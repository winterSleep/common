//
//  NBNimbusSearchDisplayController.m
//  Fish
//
//  Created by Li Zhiping on 12/18/15.
//  Copyright © 2015 Li Zhiping. All rights reserved.
//

#import "NBNimbusSearchDisplayController.h"

@interface NBNimbusSearchDisplayController ()

@property (strong, nonatomic) NITableViewActions *actions;

@end

@implementation NBNimbusSearchDisplayController

- (instancetype)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController{
    self = [super initWithSearchBar:searchBar contentsController:viewController];
    if (self) {
        [self resetActions];
    }
    return self;
}

- (void)resetActions{
    self.actions = [[NITableViewActions alloc] initWithTarget:self];
    self.searchResultsTableView.delegate = [self.actions forwardingTo:self];
}

//设置数据源, 将数据源设置到TableView的dataSource
- (void)setDataSource:(NIMutableTableViewModel *)dataSource{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        self.searchResultsTableView.dataSource = _dataSource;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NICellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.dataSource];
}

- (UITableViewCell *)tableViewModel: (NITableViewModel *)tableViewModel
                   cellForTableView: (UITableView *)tableView
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id)object
{
    return [[NICellFactory class] tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
}

- (BOOL)tableViewModel:(NIMutableTableViewModel *)tableViewModel
         canEditObject:(id)object
           atIndexPath:(NSIndexPath *)indexPath
           inTableView:(UITableView *)tableView
{
    return NO;
}

- (UITableViewRowAnimation)tableViewModel:(NIMutableTableViewModel *)tableViewModel
              deleteRowAnimationForObject:(NICellObject *)object
                              atIndexPath:(NSIndexPath *)indexPath
                              inTableView:(UITableView *)tableView
{
    return UITableViewRowAnimationNone;
}

- (void)dealloc{
    self.dataSource = nil;
    self.actions = nil;
    self.searchResultsTableView.dataSource = nil;
}

@end
