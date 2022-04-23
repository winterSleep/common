//
//  NBMutableCollectionViewModel.m
//  Fish
//
//  Created by Li Zhiping on 5/29/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import "NBMutableCollectionViewModel.h"
#import "NBCollectionViewModel+Private.h"
#import "NBMutableCollectionViewModel+Private.h"

@implementation NBMutableCollectionViewModel

//给最后一个 section 添加 object
- (NSArray *)addObject:(id)object {
    NBCollectionViewModelSection* section = self.sections.count == 0 ? [self _appendSection] : self.sections.lastObject;
    [section.mutableRows addObject:object];
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:section.mutableRows.count - 1
                                                       inSection:self.sections.count - 1]];
}

//给最后一个section添加footer
- (void)addFooterObject:(NBCollectionFooterViewObject *)object {
    NBCollectionViewModelSection* section = self.sections.count == 0 ? [self _appendSection] : self.sections.lastObject;
    section.footerViewObject = object;
}

- (NSArray *)addObject:(id)object toSection:(NSUInteger)sectionIndex {
    NBCollectionViewModelSection *section = [self.sections objectAtIndex:sectionIndex];
    [section.mutableRows addObject:object];
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:section.mutableRows.count - 1
                                                       inSection:sectionIndex]];
}

//给最后一个 section 添加 items(只能添加 cellObject, 不能添加 headerObject 和 footerObject)
- (NSArray *)addObjectsFromArray:(NSArray *)array {
    NSMutableArray* indices = [NSMutableArray array];
    for (id object in array) {
        [indices addObject:[[self addObject:object] objectAtIndex:0]];
    }
    return indices;
}

- (NSArray *)insertObject:(id)object atRow:(NSUInteger)row inSection:(NSUInteger)sectionIndex {
    NBCollectionViewModelSection *section = [self.sections objectAtIndex:sectionIndex];
    [section.mutableRows insertObject:object atIndex:row];
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:sectionIndex]];
}

- (NSArray *)insertObjectsFromArray:(NSArray *)array
                              atRow:(NSUInteger)row
                          inSection:(NSUInteger)sectionIndex{
    NBCollectionViewModelSection *section = [self.sections objectAtIndex:sectionIndex];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        NSInteger index = row+i;
        id object = [array objectAtIndex:i];
        [section.mutableRows insertObject:object atIndex:index];
        [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:sectionIndex]];
    }
    return [indexPaths copy];
}

//添加一个section
- (NSIndexSet *)addSectionWithObject:(NBCollectionHeaderViewObject *)headerViewObject {
    NBCollectionViewModelSection *section = [self _appendSection];
    section.headerViewObject = headerViewObject;
    return [NSIndexSet indexSetWithIndex:self.sections.count - 1];
}

- (NSIndexSet *)removeLastSection{
    NBCollectionViewModelSection* section = self.sections.count > 0 ? self.sections.lastObject : nil;
    if (section) {
        [self.sections removeObject:section];
        return [NSIndexSet indexSetWithIndex:self.sections.count - 1];
    }
    return nil;
}

//插入一个 section 到数据源中
- (NSIndexSet *)insertSectionWithObject:(NBCollectionHeaderViewObject *)headerViewObject atIndex:(NSUInteger)index {
    NBCollectionViewModelSection* section = [self _insertSectionAtIndex:index];
    section.headerViewObject = headerViewObject;
    return [NSIndexSet indexSetWithIndex:index];
}

- (NSArray *)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= (NSInteger)self.sections.count) {
        return nil;
    }
    NBCollectionViewModelSection* section = [self.sections objectAtIndex:indexPath.section];
    if (indexPath.row >= (NSInteger)section.mutableRows.count) {
        return nil;
    }
    [section.mutableRows removeObjectAtIndex:indexPath.row];
    return [NSArray arrayWithObject:indexPath];
}

#pragma mark - Private

- (NBCollectionViewModelSection *)_appendSection {
    if (nil == self.sections) {
        self.sections = [NSMutableArray array];
    }
    NBCollectionViewModelSection* section = nil;
    section = [[NBCollectionViewModelSection alloc] init];
    section.rows = [NSMutableArray array];
    [self.sections addObject:section];
    return section;
}

- (NBCollectionViewModelSection *)_insertSectionAtIndex:(NSUInteger)index {
    if (nil == self.sections) {
        self.sections = [NSMutableArray array];
    }
    NBCollectionViewModelSection* section = nil;
    section = [[NBCollectionViewModelSection alloc] init];
    section.rows = [NSMutableArray array];
    [self.sections insertObject:section atIndex:index];
    return section;
}

@end


@implementation NBCollectionViewModelSection (Mutable)

- (NSMutableArray *)mutableRows {
    self.rows = (nil == self.rows ? [NSMutableArray array] : self.rows);
    return (NSMutableArray *)self.rows;
}

@end
