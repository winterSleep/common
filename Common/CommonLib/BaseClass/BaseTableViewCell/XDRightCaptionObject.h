//
//  XDRightCaptionObject.h
//  leCar
//
//  Created by Li Zhiping on 14-1-3.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "XDCellCatalog.h"
#import <CoreLocation/CLLocation.h>

//左侧标题, 右侧Caption的Cell显示样式
@interface XDRightCaptionObject : XDTitleCellObject

+ (id)objectWithTitle:(NSString *)title caption:(NSString *)caption;

@property (copy, nonatomic)NSString *caption;

@property (copy, nonatomic)NSString *city;
@property (assign, nonatomic)CLLocationDegrees latitude;
@property (assign, nonatomic)CLLocationDegrees longitude;

@end

@interface XDRightCaptionCell : XDTextCell

@property (strong, nonatomic, readonly)UILabel *leftTextLabel;
@property (strong, nonatomic, readonly)UILabel *rightTextLabel;

- (void)updateTitleText;

- (void)configConstraints;

@end
