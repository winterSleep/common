//
//  NBSearchDisplayController.m
//  NBChat
//
//  Created by Li Zhiping on 12/4/14.
//  Copyright (c) 2014 Li Zhiping. All rights reserved.
//

#import "NBSearchDisplayController.h"
#import <objc/runtime.h>
#import "Colours.h"
#import "UIView+FrameCategory.h"

@interface NBSearchDisplayController ()

@property(nonatomic) UISearchBar *searchBar;
@property(nonatomic, weak) UIViewController *searchContentsController;
@property(nonatomic, strong) UITableView *searchResultsTableView;

@property(nonatomic) CGRect oldFrame;

@property(strong, nonatomic) NSLayoutConstraint *topConstraint;
@property(assign, nonatomic) CGFloat oldTopConstraintConstant;

@property(nonatomic, weak) id<UISearchBarDelegate> forwardDelegate;

@property(nonatomic, weak) UIButton *maskView;

@end

@implementation NBSearchDisplayController

- (instancetype)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController{
    self = [super init];
    if (self) {
        self.searchBar = searchBar;
        self.searchContentsController = viewController;
        self.forwardDelegate = searchBar.delegate;
        searchBar.delegate = self;
        [_searchBar.layer setMasksToBounds:NO];
    }
    return self;
}

- (void)setActive:(BOOL)active{
    [self setActive:active animated:NO];
}

- (UITableView *)searchResultsTableView{
    if (!_searchResultsTableView) {
        _searchResultsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _searchResultsTableView;
}

- (void)setActive:(BOOL)visible animated:(BOOL)animated{
    if (_active != visible) {
        _active = visible;
        if (visible) {
            self.oldFrame = self.searchBar.frame;
            self.topConstraint = nil;
            NSArray *constraints = [[self.searchBar superview] constraints];
            for (NSLayoutConstraint *constraint in constraints) {
                if (constraint.firstItem == _searchBar && constraint.firstAttribute == NSLayoutAttributeTop) {
                    self.topConstraint =  constraint;
                    break;
                }
            }
            self.oldTopConstraintConstant = self.topConstraint.constant;
            
            [self moveSearchBarToTop];
            [_searchContentsController.navigationController setNavigationBarHidden:YES animated:YES];
        }else{
            [self resetSearchBarFrame];
            [_searchContentsController.navigationController setNavigationBarHidden:NO animated:YES];
            [self.searchResultsTableView removeFromSuperview];
            self.searchResultsDataSource = nil;
            self.searchResultsDelegate = nil;
            [self.searchContentsController.view endEditing:YES];
        }
    }
}

- (void)setSearchResultsDataSource:(id<UITableViewDataSource>)searchResultsDataSource{
    if (_searchResultsDataSource != searchResultsDataSource) {
        _searchResultsDataSource = searchResultsDataSource;
        [self.searchResultsTableView setDataSource:searchResultsDataSource];
    }
}

- (void)setSearchResultsDelegate:(id<UITableViewDelegate>)searchResultsDelegate{
    if (_searchResultsDelegate != searchResultsDelegate) {
        _searchResultsDelegate = searchResultsDelegate;
        [self.searchResultsTableView setDelegate:searchResultsDelegate];
    }
}

- (void)dismissKeyboard:(id)sender{
    [_searchContentsController.view endEditing:YES];
    [self setActive:NO animated:YES];
}

- (void)moveSearchBarToTop{
    if ([_delegate respondsToSelector:@selector(searchDisplayControllerWillBeginSearch:)]) {
        [_delegate searchDisplayControllerWillBeginSearch:self];
    }
    
    CGRect frame = CGRectMake(0, 0, _searchContentsController.view.width, _searchContentsController.navigationController.view.height);
    UIButton *maskView = [UIButton buttonWithType:UIButtonTypeCustom];
    [maskView setFrame:frame];
    [maskView setBackgroundColor:[UIColor black25PercentColor]];
    [maskView addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [_searchContentsController.view insertSubview:maskView belowSubview:_searchBar];
    self.maskView = maskView;
    [self.maskView setAlpha:0.0f];
    [self.topConstraint setConstant:20];
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        if (self.topConstraint) {
            [self.searchBar layoutIfNeeded];
        }else{
            CGRect oldFrame = self.searchBar.bounds;
            oldFrame.origin.y = 20;
            [self.searchBar setFrame:oldFrame];
        }
        
        [_searchBar setShowsCancelButton:YES animated:YES];
        UIView *backgroundView = [self backgroundViewForSearchBar:_searchBar];
        [[[backgroundView superview] layer] setMasksToBounds:NO];
        [backgroundView setFrame:CGRectMake(0, -20, _searchBar.width, _searchBar.height+20)];
        [self.maskView setAlpha:0.4f];
        
    } completion:^(BOOL finished) {
        CGFloat top = _searchBar.bottom;
        CGFloat width = _searchContentsController.view.width;
        CGFloat height = _searchContentsController.view.height - top;
        [self.searchResultsTableView setFrame:CGRectMake(0, top, width, height)];
        
        if ([_delegate respondsToSelector:@selector(searchDisplayControllerDidBeginSearch:)]) {
            [_delegate searchDisplayControllerDidBeginSearch:self];
        }
    }];
}

- (void)resetSearchBarFrame{
    
    if ([_delegate respondsToSelector:@selector(searchDisplayControllerWillEndSearch:)]) {
        [_delegate searchDisplayControllerWillEndSearch:self];
    }
    [self.topConstraint setConstant:self.oldTopConstraintConstant];
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        if (self.topConstraint) {
            [self.searchBar layoutIfNeeded];
        }else{
            [self.searchBar setFrame:self.oldFrame];
        }
        [_searchBar setShowsCancelButton:NO animated:YES];
        UIView *backgroundView = [self backgroundViewForSearchBar:_searchBar];
        [backgroundView setFrame:CGRectMake(0, 0, _searchBar.width, _searchBar.height)];
        [self.maskView setAlpha:0.0f];
    }completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        self.maskView = nil;
        if ([_delegate respondsToSelector:@selector(searchDisplayControllerDidEndSearch:)]) {
            [_delegate searchDisplayControllerDidEndSearch:self];
        }
    }];
}

- (UIView *)backgroundViewForSearchBar:(UIView *)view{
    UIView *result = nil;
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            result = subView;
            return result;
        }else{
            result = [self backgroundViewForSearchBar:subView];
            if (result) {
                return result;
            }
        }
    }
    return result;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    id delegate = self.forwardDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        return [delegate searchBarShouldBeginEditing:searchBar];
    }else{
        return YES;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    id delegate = self.forwardDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate searchBar:searchBar textDidChange:searchText];
    }
    if (searchText.length == 0) {
        [[self searchResultsTableView] removeFromSuperview];
    }else{
        [self.searchContentsController.view addSubview:self.searchResultsTableView];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    id delegate = self.forwardDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate searchBarCancelButtonClicked:searchBar];
    }else{
        [_searchContentsController.view endEditing:YES];
        [self setActive:NO animated:YES];
    }
}

#pragma mark - Forward Invocations

- (BOOL)shouldForwardSelector:(SEL)selector {
    struct objc_method_description description;
    description = protocol_getMethodDescription(@protocol(UISearchBarDelegate), selector, NO, YES);
    return (description.name != NULL && description.types != NULL);
}

- (BOOL)respondsToSelector:(SEL)selector {
    if ([super respondsToSelector:selector]) {
        return YES;
        
    } else if ([self shouldForwardSelector:selector]) {
        if ([self.forwardDelegate respondsToSelector:selector]) {
            return YES;
        }
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (signature == nil) {
        if ([self.forwardDelegate respondsToSelector:selector]) {
            id delegate = self.forwardDelegate;
            signature = [delegate methodSignatureForSelector:selector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    BOOL didForward = NO;
    
    if ([self shouldForwardSelector:invocation.selector]) {
        id delegate = self.forwardDelegate;
        if ([delegate respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:delegate];
            didForward = YES;
        }
    }
    
    if (!didForward) {
        [super forwardInvocation:invocation];
    }
}

@end
