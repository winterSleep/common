//
//  XDFormCellCatalog.m
//  BussinessLink
//
//  Created by Li Zhiping on 14-3-14.
//  Copyright (c) 2014年 djp. All rights reserved.
//

#import "XDFormCellCatalog.h"
#import "UIView+FrameCategory.h"

const CGFloat formCellLineHeight = 0.5;

@implementation XDSwitchFormElement

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass {
    return [XDSwitchFormElementCell class];
}



@end

@implementation XDSwitchFormElementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lineView = [[XDCellLineView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    [self.textLabel setLeft:20];
    
    if (self.lineStyle == UITableViewCellSeparatorStyleSingleLine) {
        CGFloat width = self.width - self.lineEdgeInsets.left - self.lineEdgeInsets.right;
        CGFloat left = self.lineEdgeInsets.left;
        CGRect frame = CGRectMake(left, self.frame.size.height - formCellLineHeight, width, formCellLineHeight);
        [_lineView setFrame:frame];
        [self bringSubviewToFront:_lineView];
    }else{
        [_lineView setFrame:CGRectZero];
    }
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    [super shouldUpdateCellWithObject:object];
    self.cellObject = object;
    
    XDSwitchFormElementCell *cellObject = object;
    self.lineEdgeInsets = cellObject.lineEdgeInsets;
    self.lineStyle = cellObject.lineStyle;
    
    return YES;
}

@end

@implementation XDSliderFormElement

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass {
    return [XDSliderFormElementCell class];
}

@end

@implementation XDSliderFormElementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lineView = [[XDCellLineView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    
    //将sliderControl 与 switch 右对齐处理
    CGRect frame = self.sliderControl.frame;
    frame.origin.x = self.contentView.frame.size.width - frame.size.width - frame.origin.y;
    self.sliderControl.frame = frame;
    [self.textLabel setLeft:NICellContentPadding().left];
    if (self.lineStyle == UITableViewCellSeparatorStyleSingleLine) {
        CGFloat width = self.width - self.lineEdgeInsets.left - self.lineEdgeInsets.right;
        CGFloat left = self.lineEdgeInsets.left;
        CGRect frame = CGRectMake(left, self.frame.size.height - formCellLineHeight, width, formCellLineHeight);
        [_lineView setFrame:frame];
        [self bringSubviewToFront:_lineView];
    }else{
        [_lineView setFrame:CGRectZero];
    }
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    [super shouldUpdateCellWithObject:object];
    self.cellObject = object;
    XDSliderFormElement *cellObject = object;
    self.lineEdgeInsets = cellObject.lineEdgeInsets;
    self.lineStyle = cellObject.lineStyle;
    
    return YES;
}

@end

@implementation XDSegmentedControlFormElement

- (Class)cellClass{
    return [XDSegmentedControlFormElementCell class];
}

@end

@implementation XDSegmentedControlFormElementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lineView = [[XDCellLineView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.lineView];
    }
    return self;
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    [super shouldUpdateCellWithObject:object];
    self.cellObject = object;
    XDSegmentedControlFormElement *cellObject = object;
    self.lineEdgeInsets = cellObject.lineEdgeInsets;
    self.lineStyle = cellObject.lineStyle;
    
    return YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.lineStyle == UITableViewCellSeparatorStyleSingleLine) {
        CGFloat width = self.width - self.lineEdgeInsets.left - self.lineEdgeInsets.right;
        CGFloat left = self.lineEdgeInsets.left;
        CGRect frame = CGRectMake(left, self.frame.size.height - formCellLineHeight, width, formCellLineHeight);
        [_lineView setFrame:frame];
        [self bringSubviewToFront:_lineView];
    }else{
        [_lineView setFrame:CGRectZero];
    }
}

@end

@implementation XDDatePickerFormElement

- (Class)cellClass{
    return [XDDatePickerFormElementCell class];
}

@end

@implementation XDDatePickerFormElementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lineView = [[XDCellLineView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.lineView];
    }
    return self;
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    [super shouldUpdateCellWithObject:object];
    self.cellObject = object;
    XDDatePickerFormElement *cellObject = object;
    self.lineEdgeInsets = cellObject.lineEdgeInsets;
    self.lineStyle = cellObject.lineStyle;
    
    return YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    if (self.lineStyle == UITableViewCellSeparatorStyleSingleLine) {
        CGFloat width = self.width - self.lineEdgeInsets.left - self.lineEdgeInsets.right;
        CGFloat left = self.lineEdgeInsets.left;
        CGRect frame = CGRectMake(left, self.frame.size.height - formCellLineHeight, width, formCellLineHeight);
        [_lineView setFrame:frame];
        [self bringSubviewToFront:_lineView];
    }else{
        [_lineView setFrame:CGRectZero];
    }
}

@end

@implementation XDRadioGroup

- (Class)cellClass {
    return [XDRadioGroupCell class];
}

@end

@implementation XDRadioGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lineView = [[XDCellLineView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.detailTextLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    [self.textLabel setLeft:NICellContentPadding().left];
    
    if (self.lineStyle == UITableViewCellSeparatorStyleSingleLine) {
        CGFloat width = self.width - self.lineEdgeInsets.left - self.lineEdgeInsets.right;
        CGFloat left = self.lineEdgeInsets.left;
        CGRect frame = CGRectMake(left, self.frame.size.height - formCellLineHeight, width, formCellLineHeight);
        [_lineView setFrame:frame];
        [self bringSubviewToFront:_lineView];
    }else{
        [_lineView setFrame:CGRectZero];
    }
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    [super shouldUpdateCellWithObject:object];
    self.cellObject = object;
    XDRadioGroup *cellObject = object;
    self.lineEdgeInsets = cellObject.lineEdgeInsets;
    self.lineStyle = cellObject.lineStyle;
    
    return YES;
}

@end

@interface XDTextInputFormElement ()

//保存最开始的原始数据, 用于判断用户是否修改了textField的值.
@property (copy, nonatomic)NSString *originValue;
@property (assign, nonatomic)BOOL hasSetOriginValue;

@end

@implementation XDTextInputFormElement

- (void)setValue:(NSString *)value{
    //如果originValue没有
    if (!self.hasSetOriginValue) {
        self.hasSetOriginValue = YES;
        self.originValue = value;
    }
    [super setValue:value];
}

- (BOOL)hasChanged{
    return ![self.originValue isEqualToString:self.value];
}

- (Class)cellClass {
    return [XDTextInputFormElementCell class];
}

@end

@implementation XDTextInputFormElementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lineView = [[XDCellLineView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.lineView];
        
        [self.contentView addSubview:self.textLabel];
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textField.textColor = [UIColor grayColor];
        self.textField.adjustsFontSizeToFitWidth = NO;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.textLabel.text) {
        [self.textLabel sizeToFit];
        CGFloat width = 85;
        [self.textLabel setFrame:CGRectMake(10, 0, width, self.contentView.height)];
    }else{
        [self.textLabel setFrame:CGRectZero];
    }
    
    XDTextInputFormElement *element = self.cellObject;
    UIEdgeInsets textFieldInsets = element.textFieldInsets;
    CGFloat textFieldWidth = self.contentView.width - self.textLabel.right - textFieldInsets.left - textFieldInsets.right;
    [self.textField setLeft:self.textLabel.right + textFieldInsets.left];
    [self.textField setWidth:textFieldWidth];
    [self.textField setEnabled:element.textFieldEnabled];
    
    if (self.lineStyle == UITableViewCellSeparatorStyleSingleLine) {
        CGFloat width = self.width - self.lineEdgeInsets.left - self.lineEdgeInsets.right;
        CGFloat left = self.lineEdgeInsets.left;
        CGRect frame = CGRectMake(left, self.frame.size.height - formCellLineHeight, width, formCellLineHeight);
        [_lineView setFrame:frame];
        [self bringSubviewToFront:_lineView];
    }else{
        [_lineView setFrame:CGRectZero];
    }
    if (element.textColor) {
        [self.textField setTextColor:element.textColor];
    }else{
        [self.textField setTextColor:[UIColor grayColor]];
    }
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    [super shouldUpdateCellWithObject:object];
    XDTextInputFormElement *element = object;
    self.cellObject = object;
    [self.textLabel setText:element.title];
    [self.textLabel setTextColor:element.titleColor];
    self.textField.keyboardType = element.keyboardType;
    self.lineEdgeInsets = element.lineEdgeInsets;
    self.lineStyle = element.lineStyle;
    if (element.attributedPlaceholder) {
        [self.textField setAttributedPlaceholder:element.attributedPlaceholder];
    }else if(element.placeholderText){
        [self.textField setPlaceholder:element.placeholderText];
    }else{
        [self.textField setPlaceholder:nil];
        [self.textField setAttributedPlaceholder:nil];
    }
    return YES;
}

@end

