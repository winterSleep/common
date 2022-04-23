//
//  NBSegmentView.h
//  Fish
//
//  Created by Li Zhiping on 1/8/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NBSegmentView;

@protocol NBSegmentViewDelegate <NSObject>

@optional

- (void)squareSegmentView:(id<NBSegmentView>)segmentView
       didSelectedAtIndex:(NSInteger)index;
- (BOOL)squareSegmentView:(id<NBSegmentView>)segmentView
       canSelectedAtIndex:(NSInteger)index;

@end

@interface NBSquareSegmentItem : NSObject

@property (strong, nonatomic)NSString *title;

@end

@protocol NBSegmentView <NSObject>

//items 由 NBSquareSegmentItem 对象组成
- (instancetype)initWithItems:(NSArray *)items;

@property (weak, nonatomic)id <NBSegmentViewDelegate>delegate;

@property (assign, nonatomic, readonly)NSInteger selectedIndex;

- (void)addSegmentItem:(NBSquareSegmentItem *)item;

- (void)insertSegmentItem:(NBSquareSegmentItem *)item
                  atIndex:(NSInteger)index;

- (void)setSelectedIndex:(NSInteger)selectedIndex
                animated:(BOOL)animated;

- (void)setOffsetWithScrollViewWidth:(CGFloat)width
                    scrollViewOffset:(CGFloat)offset;

- (void)setShouldShowHint:(BOOL)shouldHint atIndex:(NSInteger)index;

@end

@interface NBSegmentView : UIView <NBSegmentView>

@end
