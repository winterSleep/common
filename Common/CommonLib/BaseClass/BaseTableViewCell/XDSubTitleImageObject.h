//
//  XDSubTitleImageObject.h
//  leCar
//
//  Created by Li Zhiping on 14-1-6.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "XDCellCatalog.h"

extern const CGFloat subTitleImageHeight;
extern const CGFloat sutTitleWithTitlePadding;


/**
 *  此类用于显示标题, 子标题, 以及左侧图片, 和右上角的Caption
 */
@interface XDSubTitleImageObject : XDSubtitleCellObject

//图上加载时的默认图片
@property (strong, nonatomic)UIImage *placeHolderImage;

//图片的URL地址, 可以是本地图片, 也可以是网络图片.
@property (strong, nonatomic)NSURL *imageUrl;

//子标题能显示的行数(用于计算Cell高度, 同时也用于设置显示SubTitle的行数)
@property (assign, nonatomic)NSInteger subTitleLines;

//Cell的右侧箭头等类型
@property (assign, nonatomic)UITableViewCellAccessoryType accessoryType;

//右上角label标题, 如果不需要, 直接赋值nil或者忽略即可
@property (copy, nonatomic)NSString *rightTopCaption;

@end

@interface XDSubTitleImageCell : XDTextCell

@property (strong, nonatomic)UILabel *rightTopCaptionLabel;
@property (strong, nonatomic)id <NICellObject> object;

- (CGFloat)contentViewWidth;

//计算ContentView的宽度
+ (CGFloat)contentViewWidthForObject:(id)object
                         atIndexPath:(NSIndexPath *)indexPath
                           tableView:(UITableView *)tableView;

//计算标题的高度
+ (CGFloat)titleHeightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

//计算subTitle的高度
+ (CGFloat)subTitleHeightForObject:(id)object
                       atIndexPath:(NSIndexPath *)indexPath
                         tableView:(UITableView *)tableView;

//标题信息label的字体, 子类可以继承并进行修改
+ (UIFont *)textLabelFont;

//详细信息label的字体, 子类可以继承并进行修改
+ (UIFont *)detailLabelFont;

//右上角caption label的字体
+ (UIFont *)captionLabelFont;

@end
