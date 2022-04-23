//
//  NBCollectionViewModel.h
//  Fish
//
//  Created by Li Zhiping on 5/29/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NBCollectionHeaderViewObject.h"
#import "NBCollectionFooterViewObject.h"

@protocol NBCollectionViewModelDelegate;
@class NBCollectionViewModelSection;

@interface NBCollectionViewModel : NSObject <UICollectionViewDataSource>

// Designated initializer.
- (id)initWithDelegate:(id<NBCollectionViewModelDelegate>)delegate;
- (id)initWithListArray:(NSArray *)sectionedArray delegate:(id<NBCollectionViewModelDelegate>)delegate;
- (id)initWithSectionedArray:(NSArray *)sectionedArray delegate:(id<NBCollectionViewModelDelegate>)delegate;

#pragma mark Accessing Objects

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

// This method is not appropriate for performance critical codepaths.
- (NSIndexPath *)indexPathForObject:(id)object;

- (NBCollectionViewModelSection *)modelInSection:(NSInteger)section;

#pragma mark Creating Collection View Cells

@property (nonatomic, weak) id<NBCollectionViewModelDelegate> delegate;

@end

@interface NBCollectionViewModelSection : NSObject

+ (id)section;

@property (nonatomic, strong) NBCollectionHeaderViewObject *headerViewObject;
@property (nonatomic, strong) NSArray* rows;
@property (nonatomic, strong) NBCollectionFooterViewObject *footerViewObject;

@end

@protocol NBCollectionViewModelDelegate <NSObject>

@required

- (UICollectionViewCell *)collectionViewModel:(NBCollectionViewModel *)collectionViewModel
                        cellForCollectionView:(UICollectionView *)collectionView
                                  atIndexPath:(NSIndexPath *)indexPath
                                   withObject:(id)object;

- (UICollectionReusableView *)collectionViewModel:(NBCollectionViewModel *)collectionViewModel
                                   collectionView:(UICollectionView *)collectionView
                viewForSupplementaryElementOfKind:(NSString *)kind
                                      atIndexPath:(NSIndexPath *)indexPath
                                       withObject:(id)object;

@end