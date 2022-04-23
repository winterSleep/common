//
//  NBMutableCollectionViewModel.h
//  Fish
//
//  Created by Li Zhiping on 5/29/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import "NBCollectionViewModel.h"

@interface NBMutableCollectionViewModel : NBCollectionViewModel

- (NSArray *)addObject:(id)object;
- (NSArray *)addObject:(id)object toSection:(NSUInteger)section;
- (NSArray *)addObjectsFromArray:(NSArray *)array;
- (NSArray *)insertObject:(id)object atRow:(NSUInteger)row inSection:(NSUInteger)sectionIndex;

- (NSArray *)insertObjectsFromArray:(NSArray *)array atRow:(NSUInteger)row inSection:(NSUInteger)sectionIndex;
- (NSArray *)removeObjectAtIndexPath:(NSIndexPath *)indexPath;

//给最后一个section添加footer
- (void)addFooterObject:(NBCollectionFooterViewObject *)object;

//在最后的位置添加一个section
- (NSIndexSet *)addSectionWithObject:(NBCollectionHeaderViewObject *)headerViewObject;

//删除最后一个section
- (NSIndexSet *)removeLastSection;

//插入一个 section 到数据源中
- (NSIndexSet *)insertSectionWithObject:(NBCollectionHeaderViewObject *)headerViewObject
                                atIndex:(NSUInteger)index;

@end
