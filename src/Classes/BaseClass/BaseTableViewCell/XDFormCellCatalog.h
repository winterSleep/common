//
//  XDFormCellCatalog.h
//  BussinessLink
//
//  Created by Li Zhiping on 14-3-14.
//  Copyright (c) 2014年 djp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nimbus/NimbusModels.h>
#import "XDCellLineView.h"

@interface XDSwitchFormElement : NISwitchFormElement

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@property (strong, nonatomic)id userInfo;
@end

@interface XDSwitchFormElementCell : NISwitchFormElementCell

@property (strong, nonatomic)id cellObject;
@property (strong, nonatomic)XDCellLineView *lineView;

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@end

@interface XDSliderFormElement : NISliderFormElement

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@property (strong, nonatomic)id userInfo;
@end

@interface XDSliderFormElementCell : NISliderFormElementCell

@property (strong, nonatomic)id cellObject;
@property (strong, nonatomic)XDCellLineView *lineView;

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@end

@interface XDSegmentedControlFormElement : NISegmentedControlFormElement

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@property (strong, nonatomic)id userInfo;
@end

@interface XDSegmentedControlFormElementCell : NISegmentedControlFormElementCell

@property (strong, nonatomic)id cellObject;
@property (strong, nonatomic)XDCellLineView *lineView;

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@end

@interface XDDatePickerFormElement : NIDatePickerFormElement

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@property (strong, nonatomic)id userInfo;
@end

@interface XDDatePickerFormElementCell : NIDatePickerFormElementCell

@property (strong, nonatomic)id cellObject;
@property (strong, nonatomic)XDCellLineView *lineView;

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@end

@interface XDTextInputFormElement : NITextInputFormElement

@property (copy, nonatomic)NSString *title;

//default is NO;
@property (assign, nonatomic)BOOL textFieldEnabled;

@property (strong, nonatomic)UIColor *textColor;
@property (strong, nonatomic)UIColor *titleColor;
@property (assign, nonatomic)UIEdgeInsets textFieldInsets;
@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;
@property (strong, nonatomic)id userInfo;
@property (assign, nonatomic)UIKeyboardType keyboardType;
@property (copy, nonatomic)NSAttributedString *attributedPlaceholder;

- (BOOL)hasChanged;

@end

@interface XDTextInputFormElementCell : NITextInputFormElementCell

@property (strong, nonatomic)id cellObject;
@property (strong, nonatomic)XDCellLineView *lineView;

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@end

@interface XDRadioGroup : NIRadioGroup

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@property (strong, nonatomic)id userInfo;
@end

@interface XDRadioGroupCell : NIRadioGroupCell

@property (strong, nonatomic)id cellObject;
@property (strong, nonatomic)XDCellLineView *lineView;

@property (assign, nonatomic)UIEdgeInsets lineEdgeInsets;
@property (assign, nonatomic)UITableViewCellSeparatorStyle lineStyle;

@end
