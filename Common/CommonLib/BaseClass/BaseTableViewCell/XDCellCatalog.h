//
//  XDCellCatalog.h
//  BussinessLink
//
//  Created by Li Zhiping on 14-3-14.
//  Copyright (c) 2014年 djp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDCellLineView.h"
#import <Nimbus/NimbusModels.h>

@interface XDSubtitleCellObject : NISubtitleCellObject<NSCopying>

@property (strong, nonatomic)UIColor *titleColor;
@property (assign, nonatomic)UIEdgeInsets titleInsets;
@property (strong, nonatomic)UIColor *subtitleColor;
@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@end

@interface XDTitleCellObject : NITitleCellObject<NSCopying>

@property (strong, nonatomic)UIColor *titleColor;
@property (assign, nonatomic)UIEdgeInsets titleInsets;
@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)NSTextAlignment textAlignment;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;
@property (assign, nonatomic)CGFloat cellHeight;
@property (assign, nonatomic)UITableViewCellAccessoryType accessoryType;

@end

@interface XDTextCell : NITextCell

@property (strong, nonatomic)id cellObject;
@property (strong, nonatomic)XDCellLineView *lineView;

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@end

@interface XDDrawRectBlockCellObject : NIDrawRectBlockCellObject

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@end

@interface XDDrawRectBlockCell : NIDrawRectBlockCell

@property (strong, nonatomic)id cellObject;
@property (strong, nonatomic)XDCellLineView *lineView;

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@end

//UIResponsder 进行广播时时, 可以通过它获取userInfo中Cell的Model
extern NSString *const kTableViewCellObject;

@interface XDTextCell (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSMutableDictionary *)userInfo;

@end
