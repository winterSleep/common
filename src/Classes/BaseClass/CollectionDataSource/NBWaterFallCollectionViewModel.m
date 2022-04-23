//
//  NBWaterFallCollectionViewModel.m
//  Fish
//
//  Created by Li Zhiping on 30/11/2017.
//  Copyright © 2017 Li Zhiping. All rights reserved.
//

#import "NBWaterFallCollectionViewModel.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "NBMutableCollectionViewModel+Private.h"

@implementation NBWaterFallCollectionViewModel

//头部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NBCollectionViewModelSection *section = [self.sections objectAtIndex:indexPath.section];
    id object = nil;
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        object = [section headerViewObject];
    }else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        object = [section footerViewObject];
    }
    
    UICollectionReusableView *reusableView = [self.delegate collectionViewModel:self collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath withObject:object];
    return reusableView;
}

@end
