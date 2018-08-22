//
//  NBCollectionCellObject.m
//  Fish
//
//  Created by Li Zhiping on 5/29/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import "NBCollectionCellObject.h"

@implementation NBCollectionCellObject

- (Class)cellClass{
    return [NBCollectionCell class];
}

+ (NSString *)cellIdentifier{
    return NSStringFromClass([self class]);
}

@end

@implementation NBCollectionCell

- (BOOL)shouldUpdateCellWithObject:(id)object{
    if (self.cellObject != object) {
        self.cellObject = object;
    }
    return YES;
}

+ (CGSize)sizeForObject:(id)object
            atIndexPath:(NSIndexPath *)indexPath
         collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout*)collectionViewLayout{
    return CGSizeZero;
}

@end
