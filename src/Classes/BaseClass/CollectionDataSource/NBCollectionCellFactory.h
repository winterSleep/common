//
//  NBCollectionCellFactory.h
//  Fish
//
//  Created by Li Zhiping on 5/29/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NBCollectionViewModel.h"

@interface NBCollectionCellFactory : NSObject

+ (UICollectionViewCell *)collectionViewModel:(NBCollectionViewModel *)collectionViewModel
                        cellForCollectionView:(UICollectionView *)collectionView
                                  atIndexPath:(NSIndexPath *)indexPath
                                   withObject:(id)object;

+ (UICollectionReusableView *)collectionViewModel:(NBCollectionViewModel *)collectionViewModel
                                   collectionView:(UICollectionView *)collectionView
                viewForSupplementaryElementOfKind:(NSString *)kind
                                      atIndexPath:(NSIndexPath *)indexPath
                                       withObject:(id)object;

+ (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath model:(NBCollectionViewModel *)model;

+ (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
                   model:(NBCollectionViewModel *)model;

+ (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
                   model:(NBCollectionViewModel *)model;

@end
