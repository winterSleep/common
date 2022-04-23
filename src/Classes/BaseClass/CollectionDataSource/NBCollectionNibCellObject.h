//
//  NBCollectionNibCellObject.h
//  Fish
//
//  Created by Li Zhiping on 20/11/2017.
//  Copyright © 2017 Li Zhiping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NBCollectionNibCellObject <NSObject>

@required

- (Class)cellClassForHeight;

+ (NSString *)cellIdentifier;

- (UINib *)cellNib;

@end

@protocol NBCollectionNibCell <NSObject>

@required
- (BOOL)shouldUpdateCellWithObject:(id)object;

@optional

+ (CGSize)sizeForObject:(id)object
            atIndexPath:(NSIndexPath *)indexPath
         collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout*)collectionViewLayout;

@end

@interface NBCollectionNibCellObject : NSObject<NBCollectionNibCellObject>

@property (strong, nonatomic)id userInfo;

@end

@interface NBCollectionNibCell : UICollectionViewCell<NBCollectionNibCell>

@property (strong, nonatomic)id <NBCollectionNibCellObject>cellObject;

@end
