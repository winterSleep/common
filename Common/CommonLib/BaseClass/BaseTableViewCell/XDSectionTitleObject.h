//
//  XDSectionTitleObject.h
//  leCar
//
//  Created by Li Zhiping on 14-2-25.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "XDCellCatalog.h"

@interface XDSectionTitleObject : XDTitleCellObject

@property (assign, nonatomic)CGFloat sectionHeight;
@property (strong, nonatomic)UIColor *sectionColor;
@property (strong, nonatomic)UIFont  *titleFont;

+ (instancetype)objectWithTitle:(NSString *)title sectionHeight:(CGFloat)height;

+ (instancetype)objectWithHeight:(CGFloat)height;

@end

@interface XDSectionTitleCell : XDTextCell

@end