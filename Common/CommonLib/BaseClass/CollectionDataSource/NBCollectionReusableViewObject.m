//
//  NBCollectionReusableViewObject.m
//  CollectionViewTest
//
//  Created by Li Zhiping on 5/30/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import "NBCollectionReusableViewObject.h"

@implementation NBCollectionReusableViewObject

+ (Class)reusableViewClass{
    return [NBCollectionReusableView class];
}

+ (NSString *)viewIdentifier{
    return NSStringFromClass([self class]);
}

@end

@implementation NBCollectionReusableView

- (BOOL)shouldUpdateCellWithObject:(id)object{
    return YES;
}

+ (CGSize)sizeForObject:(id)object
              inSection:(NSInteger)section
         collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout*)collectionViewLayout{
    return CGSizeZero;
}

@end