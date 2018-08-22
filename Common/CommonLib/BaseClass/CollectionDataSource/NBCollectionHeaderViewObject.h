//
//  NBCollectionHeaderViewObject.h
//  CollectionViewTest
//
//  Created by Li Zhiping on 5/30/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBCollectionReusableViewObject.h"

@interface NBCollectionHeaderViewObject : NBCollectionReusableViewObject

@property (assign, nonatomic)NSInteger waterFallColumnCount; //瀑布流布局时, 每个section 的列数

@end

@interface NBCollectionHeaderView : NBCollectionReusableView

@end
