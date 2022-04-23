//
//  XDSeparatorLineObject.h
//  leCar
//
//  Created by Li Zhiping on 14-2-25.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "XDCellCatalog.h"

@interface XDSeparatorLineObject : NICellObject

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;

+ (instancetype)object;

+ (instancetype)objectWithInset:(UIEdgeInsets)inset;

@end

@interface XDSeparatorLineCell : UITableViewCell <NICell>

@end
