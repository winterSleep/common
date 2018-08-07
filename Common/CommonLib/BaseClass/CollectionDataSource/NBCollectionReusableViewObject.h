//
//  NBCollectionReusableViewObject.h
//  CollectionViewTest
//
//  Created by Li Zhiping on 5/30/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NBCollectionReusableViewObject <NSObject>

@required

+ (Class)reusableViewClass;

+ (NSString *)viewIdentifier;

@end

@protocol NBCollectionReusableView <NSObject>

@required
- (BOOL)shouldUpdateCellWithObject:(id)object;

@optional

+ (CGSize)sizeForObject:(id)object
              inSection:(NSInteger)section
         collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout*)collectionViewLayout;

@end

@interface NBCollectionReusableViewObject : NSObject<NBCollectionReusableViewObject>

@end

@interface NBCollectionReusableView : UICollectionReusableView<NBCollectionReusableView>

@end
