//
//  NBBaseSegmentViewController.h
//  Fish
//
//  Created by Li Zhiping on 5/5/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import "NBBaseViewController.h"
#import "NBSegmentView.h"

@protocol NBBaseSegmentChildViewController <NSObject>

@required

- (void)setScrollsToTop:(BOOL)scrollToTop;

- (void)setScrollViewScrollEnable:(BOOL)scrollEnable;

- (void)updateDataIfNeed;

@end

@protocol NBBaseSegmentDataSource <NSObject>

@required

- (NSInteger)numberOfSegment;
- (NSString *)titleForSegmentAtIndex:(NSInteger)index;
- (UIViewController <NBBaseSegmentChildViewController> *)viewControllerForSegmentAtIndex:(NSInteger)index;

- (void)willShowViewControllerAtIndex:(NSInteger)index;

@end

@interface NBBaseSegmentViewController : NBBaseViewController <NBBaseSegmentDataSource, NBSegmentViewDelegate>

@property (strong, nonatomic, readonly)UIView <NBSegmentView> *titleSegment;
@property (strong, nonatomic, readonly)UIScrollView *scrollView;

@property (assign, nonatomic)BOOL segmentShowAtTopBar; //在navigationBar显示

@property (strong, nonatomic, readonly)NSArray <UIViewController <NBBaseSegmentChildViewController> *>*segmentViewControllers;

- (UIViewController <NBBaseSegmentChildViewController>*)currentViewController;

- (void)updateChildControllerStatus:(UIScrollView *)scrollView;

- (CGFloat)segmentViewHeight;

- (UIEdgeInsets)scrollViewInsets;

//titleSegment 的class
- (Class)classForTitleSegment;

@end
