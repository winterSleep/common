//
//  XDCellLineView.m
//  leCar
//
//  Created by Li Zhiping on 14-3-11.
//  Copyright (c) 2014年 XDIOS. All rights reserved.
//

#import "XDCellLineView.h"
#import "UIImage+Color.h"
#import "UIView+FrameCategory.h"
#import <Nimbus/NIPreprocessorMacros.h>

@interface XDCellLineView (){
    UIImageView *_separateLine1;
    UIImageView *_separateLine2;
}

@end

@implementation XDCellLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _separateLine1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageWithColor:RGBACOLOR(0, 0, 0, 0.1)];
        [_separateLine1 setImage:image];
        [self addSubview:_separateLine1];
        [self setBackgroundColor:[UIColor clearColor]];
        
//        _separateLine2 = [[UIImageView alloc] initWithFrame:CGRectZero];
//        image = [UIImage imageWithColor:RGBACOLOR(255, 255, 255, 0.7)];
//        [_separateLine2 setImage:image];
//        [self addSubview:_separateLine2];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    _separateLine1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *image = [UIImage imageWithColor:RGBACOLOR(0, 0, 0, 0.1)];
    [_separateLine1 setImage:image];
    [self addSubview:_separateLine1];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets inset = self.lineEdgeInsets;
    
    if (self.direction == XDCellLineHorizontal) {
        CGFloat width = self.width - inset.left - inset.right;
        CGRect frame = CGRectMake(inset.left, 0, width, 0.5);
        [_separateLine1 setFrame:frame];
    }else{
        CGFloat height = self.height - inset.top - inset.bottom;
        CGRect frame = CGRectMake(0, inset.top, 0.5, height);
        [_separateLine1 setFrame:frame];
    }
    
//    frame.origin.y = height;
//    [_separateLine2 setFrame:frame];
}

@end
