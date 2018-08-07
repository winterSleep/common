//
//  XDCellLineView.h
//  leCar
//
//  Created by Li Zhiping on 14-3-11.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XDCellLineHorizontal,
    XDCellLineVertical
} XDCellLineDirection;

@interface XDCellLineView : UIView

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)XDCellLineDirection direction;

@end
