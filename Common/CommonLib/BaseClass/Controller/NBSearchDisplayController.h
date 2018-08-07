//
//  NBSearchDisplayController.h
//  NBChat
//
//  Created by Li Zhiping on 12/4/14.
//  Copyright (c) 2014 Li Zhiping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NBSearchDisplayController;

@protocol NBSearchDisplayDelegate <NSObject>

@optional

// when we start/end showing the search UI
- (void) searchDisplayControllerWillBeginSearch:(NBSearchDisplayController *)controller;
- (void) searchDisplayControllerDidBeginSearch:(NBSearchDisplayController *)controller;
- (void) searchDisplayControllerWillEndSearch:(NBSearchDisplayController *)controller;
- (void) searchDisplayControllerDidEndSearch:(NBSearchDisplayController *)controller;

@end

@interface NBSearchDisplayController : NSObject <UISearchBarDelegate>

- (instancetype)initWithSearchBar:(UISearchBar *)searchBar
               contentsController:(UIViewController *)viewController;

@property(nonatomic,assign) id<NBSearchDisplayDelegate> delegate;

@property(nonatomic, getter = isActive) BOOL active;

//animated 暂时无效果
- (void)setActive:(BOOL)visible animated:(BOOL)animated;

@property(nonatomic, readonly) UISearchBar *searchBar;
@property(nonatomic, weak, readonly) UIViewController *searchContentsController;
@property(nonatomic, readonly, strong) UITableView *searchResultsTableView;
@property(nonatomic, strong) id<UITableViewDataSource> searchResultsDataSource;
@property(nonatomic, strong) id<UITableViewDelegate> searchResultsDelegate;


@end
