//
//  XDNibCellObject.h
//  ERP
//
//  Created by Li Zhiping on 7/14/16.
//  Copyright © 2016 Ghost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDCellLineView.h"
#import <Nimbus/NimbusModels.h>

extern NSString *const kTableViewCellObject;

@interface XDNibCellObject : NSObject<NINibCellObject>

+ (instancetype)cellObjectWithLineInsets:(UIEdgeInsets)insets;

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@property (strong, nonatomic)id userInfo;

- (Class)cellClassForHeight;

- (NSString *)cellIdentify;

@end

@interface XDNibCell : NITextCell<NICell>

@property (strong, nonatomic, readonly)id cellObject;
@property (strong, nonatomic)XDCellLineView *lineView;

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSMutableDictionary *)userInfo;

@end
