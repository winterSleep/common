//
//  NBCollectionCellFactory.m
//  Fish
//
//  Created by Li Zhiping on 5/29/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import "NBCollectionCellFactory.h"
#import "NBCollectionCellObject.h"
#import "NBCollectionReusableViewObject.h"
#import <Nimbus/NimbusModels.h>
#import "NBCollectionCellObject.h"
#import "NBCollectionNibCellObject.h"
#import "NBCollectionReusableViewObject.h"

@implementation NBCollectionCellFactory

+ (UICollectionViewCell *)cellWithClass:(Class)cellClass
                         collectionView:(UICollectionView *)collectionView
                              indexPath:(NSIndexPath *)indexPath
                                 object:(id)object{
    NSString* identifier = NSStringFromClass(cellClass);
    if ([cellClass respondsToSelector:@selector(shouldAppendObjectClassToReuseIdentifier)]
        && [cellClass shouldAppendObjectClassToReuseIdentifier]) {
        identifier = [identifier stringByAppendingFormat:@".%@", NSStringFromClass([object class])];
    }
    [collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(NBCollectionCell)]) {
        id <NBCollectionCell> collectionCell = (id <NBCollectionCell>)cell;
        [collectionCell shouldUpdateCellWithObject:object];
    }
    
    return cell;
}

+ (UICollectionViewCell *)cellWithNib:(UINib *)cellNib
                       collectionView:(UICollectionView *)collectionView
                            indexPath:(NSIndexPath *)indexPath
                               object:(id)object{
    UICollectionViewCell* cell = nil;
    
    NSString *identifier = NSStringFromClass([object class]);
    [collectionView registerNib:cellNib forCellWithReuseIdentifier:identifier];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    // Allow the cell to configure itself with the object's information.
    if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:)]) {
        [(id<NICell>)cell shouldUpdateCellWithObject:object];
    }
    
    return cell;
}

+ (UICollectionViewCell *)collectionViewModel:(NBCollectionViewModel *)collectionViewModel
                        cellForCollectionView:(UICollectionView *)collectionView
                                  atIndexPath:(NSIndexPath *)indexPath
                                   withObject:(id)object{
    UICollectionViewCell* cell = nil;
    // Only NICellObject-conformant objects may pass.
    if ([object respondsToSelector:@selector(cellClass)]) {
        Class cellClass = [object cellClass];
        cell = [self cellWithClass:cellClass collectionView:collectionView indexPath:indexPath object:object];
        
    } else if ([object respondsToSelector:@selector(cellNib)]) {
        UINib* nib = [object cellNib];
        cell = [self cellWithNib:nib collectionView:collectionView indexPath:indexPath object:object];
    }
    return cell;
}

+ (UICollectionReusableView *)collectionViewModel:(NBCollectionViewModel *)collectionViewModel
                                   collectionView:(UICollectionView *)collectionView
                viewForSupplementaryElementOfKind:(NSString *)kind
                                      atIndexPath:(NSIndexPath *)indexPath
                                       withObject:(id)object{
    NSString *identifier = [[object class] viewIdentifier];
    Class cellClass = [[object class] reusableViewClass];
    [collectionView registerClass:cellClass forSupplementaryViewOfKind:kind withReuseIdentifier:[[object class] viewIdentifier]];
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    if ([reusableView conformsToProtocol:@protocol(NBCollectionReusableView)]) {
        id <NBCollectionReusableView> collectionView = (id<NBCollectionReusableView>)reusableView;
        [collectionView shouldUpdateCellWithObject:object];
    }
    return reusableView;
}

+ (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath model:(NBCollectionViewModel *)model{

    CGSize size = CGSizeZero;
    id object = [model objectAtIndexPath:indexPath];
    Class cellClass = nil;
    if ([object respondsToSelector:@selector(cellClass)]) {
        cellClass = [object cellClass];
    }
    
    if ([object respondsToSelector:@selector(cellClassForHeight)]) {
        cellClass = [object cellClassForHeight];
    }
    
    if ([cellClass respondsToSelector:@selector(sizeForObject:atIndexPath:collectionView:layout:)]) {
        size = [cellClass sizeForObject:(id)object
                            atIndexPath:indexPath
                         collectionView:collectionView
                                 layout:collectionViewLayout];
        
    }
    return size;
}

+ (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
                   model:(NBCollectionViewModel *)model{
    NBCollectionViewModelSection *sectionModel = [model modelInSection:section];
    NBCollectionHeaderViewObject *object = [sectionModel headerViewObject];
    if (object) {
        Class reusableViewClass = [[object class] reusableViewClass];
        return [reusableViewClass sizeForObject:(id)object
                                      inSection:section
                                 collectionView:collectionView
                                         layout:collectionViewLayout];
    }
    return CGSizeZero;
}

+ (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
                   model:(NBCollectionViewModel *)model{
    NBCollectionViewModelSection *sectionModel = [model modelInSection:section];
    NBCollectionFooterViewObject *object = [sectionModel footerViewObject];
    if (object) {
        Class reusableViewClass = [[object class] reusableViewClass];
        return [reusableViewClass sizeForObject:(id)object
                                      inSection:section
                                 collectionView:collectionView
                                         layout:collectionViewLayout];
    }
    return CGSizeZero;
}

@end
