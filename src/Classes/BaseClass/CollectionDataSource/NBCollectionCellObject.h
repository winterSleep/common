//
//  NBCollectionCellObject.h
//  Fish
//
//  Created by Li Zhiping on 5/29/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NBCollectionCellObject <NSObject>

@required

- (Class)cellClass;

+ (NSString *)cellIdentifier;

@end

@protocol NBCollectionCell <NSObject>

@required
- (BOOL)shouldUpdateCellWithObject:(id)object;

@optional

+ (CGSize)sizeForObject:(id)object
            atIndexPath:(NSIndexPath *)indexPath
         collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout*)collectionViewLayout;

@end

@interface NBCollectionCellObject : NSObject<NBCollectionCellObject>

@property (strong, nonatomic)id userInfo;

@end

@interface NBCollectionCell : UICollectionViewCell<NBCollectionCell>

@property (strong, nonatomic)id <NBCollectionCellObject>cellObject;

@end
