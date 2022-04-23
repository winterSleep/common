//
//  NBWaterFallCollectionViewController.m
//  Fish
//
//  Created by Li Zhiping on 20/11/2017.
//  Copyright © 2017 Li Zhiping. All rights reserved.
//

#import "NBWaterFallCollectionViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "NBCollectionCellFactory.h"
#import "NBMutableCollectionViewModel+Private.h"

@interface NBWaterFallCollectionViewController ()<CHTCollectionViewDelegateWaterfallLayout>

@end

@implementation NBWaterFallCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UICollectionViewLayout *)flowLayoutForCollectionView{
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
//    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//    layout.headerHeight = 15;
//    layout.footerHeight = 10;
    layout.minimumColumnSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    return layout;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section{
    return [NBCollectionCellFactory collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section model:self.dataSource].height;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    return [NBCollectionCellFactory collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section model:self.dataSource].height;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
                     layout:(UICollectionViewLayout *)collectionViewLayout
      columnCountForSection:(NSInteger)section{
    NBCollectionViewModelSection *sectionInfo = [[self.dataSource sections] objectAtIndex:section];
    if (sectionInfo.headerViewObject && sectionInfo.headerViewObject.waterFallColumnCount > 0) {
        return sectionInfo.headerViewObject.waterFallColumnCount;
    }
    return 2;
}

- (CHTCollectionViewWaterfallLayout *)waterFallLayout{
    return (CHTCollectionViewWaterfallLayout *)self.collectionViewLayout;
}

@end
