//
//  NBCollectionViewModel.m
//  Fish
//
//  Created by Li Zhiping on 5/29/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import "NBCollectionViewModel.h"
#import "NBCollectionViewModel+Private.h"

@implementation NBCollectionViewModel

- (id)initWithDelegate:(id<NBCollectionViewModelDelegate>)delegate {
    if ((self = [super init])) {
        self.delegate = delegate;
        [self _resetCompiledData];
    }
    return self;
}

- (id)initWithListArray:(NSArray *)listArray delegate:(id<NBCollectionViewModelDelegate>)delegate {
    if ((self = [self initWithDelegate:delegate])) {
        [self _compileDataWithListArray:listArray];
    }
    return self;
}

- (id)initWithSectionedArray:(NSArray *)sectionedArray delegate:(id<NBCollectionViewModelDelegate>)delegate {
    if ((self = [self initWithDelegate:delegate])) {
        [self _compileDataWithSectionedArray:sectionedArray];
    }
    return self;
}

- (id)init {
    return [self initWithDelegate:nil];
}

#pragma mark - Public


- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (nil == indexPath) {
        return nil;
    }
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    id object = nil;
    
    if ((NSUInteger)section < self.sections.count) {
        NSArray* rows = [[self.sections objectAtIndex:section] rows];
        
        if ((NSUInteger)row < rows.count) {
            object = [rows objectAtIndex:row];
        }
    }
    
    return object;
}

- (NSIndexPath *)indexPathForObject:(id)object {
    if (nil == object) {
        return nil;
    }
    
    NSArray *sections = self.sections;
    for (NSUInteger sectionIndex = 0; sectionIndex < [sections count]; sectionIndex++) {
        NSArray* rows = [[sections objectAtIndex:sectionIndex] rows];
        for (NSUInteger rowIndex = 0; rowIndex < [rows count]; rowIndex++) {
            if ([object isEqual:[rows objectAtIndex:rowIndex]]) {
                return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            }
        }
    }
    
    return nil;
}

- (NBCollectionViewModelSection *)modelInSection:(NSInteger)section{
    return [self.sections objectAtIndex:section];
}

#pragma mark - Compiling Data

- (void)_resetCompiledData {
    self.sections = nil;
}

- (void)_compileDataWithListArray:(NSArray *)listArray {
    [self _resetCompiledData];
    
    if (nil != listArray) {
        NBCollectionViewModelSection* section = [NBCollectionViewModelSection section];
        section.rows = listArray;
        self.sections = [NSArray arrayWithObject:section];
    }
}

- (void)_compileDataWithSectionedArray:(NSArray *)sectionedArray {
    [self _resetCompiledData];
    
    NSMutableArray* sections = [NSMutableArray array];
    
    NBCollectionHeaderViewObject* currentSectionHeaderObject = nil;
    NBCollectionFooterViewObject* currentSectionFooterObject = nil;
    NSMutableArray* currentSectionRows = nil;
    
    for (id object in sectionedArray) {
        BOOL isSection = [object isKindOfClass:[NBCollectionHeaderViewObject class]];
        BOOL isSectionFooter = [object isKindOfClass:[NBCollectionFooterViewObject class]];
        
        NBCollectionHeaderViewObject* nextSectionHeaderObject = nil;
        
        if (isSection) {
            nextSectionHeaderObject = object;
            
        } else if (isSectionFooter) {
            NBCollectionFooterViewObject* footer = object;
            currentSectionFooterObject = footer;
            
        } else {
            if (nil == currentSectionRows) {
                currentSectionRows = [[NSMutableArray alloc] init];
            }
            [currentSectionRows addObject:object];
        }
        
        // A section footer or title has been encountered,
        if (nil != nextSectionHeaderObject || nil != currentSectionFooterObject) {
            if (nil != currentSectionHeaderObject
                || nil != currentSectionFooterObject
                || nil != currentSectionRows) {
                NBCollectionViewModelSection* section = [NBCollectionViewModelSection section];
                section.headerViewObject = currentSectionHeaderObject;
                section.footerViewObject = currentSectionFooterObject;
                section.rows = currentSectionRows;
                [sections addObject:section];
            }
            
            currentSectionRows = nil;
            currentSectionHeaderObject = nextSectionHeaderObject;
            currentSectionFooterObject = nil;
        }
    }
    
    // Commit any unfinished sections.
    if ([currentSectionRows count] > 0 || nil != currentSectionHeaderObject) {
        NBCollectionViewModelSection* section = [NBCollectionViewModelSection section];
        section.headerViewObject = currentSectionHeaderObject;
        section.footerViewObject = currentSectionFooterObject;
        section.rows = currentSectionRows;
        [sections addObject:section];
    }
    currentSectionRows = nil;
    
    // Update the compiled information for this data source.
    self.sections = sections;
}

#pragma mark - 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NBCollectionViewModelSection *viewModel = [self.sections objectAtIndex:section];
    return [[viewModel rows] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id object = [self objectAtIndexPath:indexPath];
    UICollectionViewCell *cell = [self.delegate collectionViewModel:self cellForCollectionView:collectionView atIndexPath:indexPath withObject:object];
    return cell;
}

//头部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NBCollectionViewModelSection *section = [self.sections objectAtIndex:indexPath.section];
    id object = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        object = [section headerViewObject];
    }else{
        object = [section footerViewObject];
    }
    
    UICollectionReusableView *reusableView = [self.delegate collectionViewModel:self collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath withObject:object];
    return reusableView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.sections count];
}

@end


@implementation NBCollectionViewModelSection

+ (id)section {
    return [[self alloc] init];
}

@end