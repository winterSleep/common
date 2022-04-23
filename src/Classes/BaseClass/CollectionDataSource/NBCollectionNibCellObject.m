//
//  NBCollectionNibCellObject.m
//  Fish
//
//  Created by Li Zhiping on 20/11/2017.
//  Copyright © 2017 Li Zhiping. All rights reserved.
//

#import "NBCollectionNibCellObject.h"

@implementation NBCollectionNibCellObject

- (Class)cellClassForHeight{
    return [NBCollectionNibCell class];
}

+ (NSString *)cellIdentifier{
    return NSStringFromClass([self class]);
}

- (UINib *)cellNib{
    NSAssert(true, @"必须继承重写该方法");
    return nil;
}

@end

@implementation NBCollectionNibCell

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
