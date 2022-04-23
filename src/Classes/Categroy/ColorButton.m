//
//  ColorButton.m
//  btn
//
//  Created by LYZ on 14-1-10.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import "ColorButton.h"

@interface ColorButton ()

@property (assign, nonatomic) CGFloat percent;
@property (strong, nonatomic) NSArray *colorArray;
@property (copy  , nonatomic) NSString *title;
@property (strong, nonatomic) CAGradientLayer *gradient;

@end

@implementation ColorButton

- (void)updateWithColos:(NSArray *)colors percent:(CGFloat)percent title:(NSString *)title{
    self.percent = percent;
    self.title = title;
    self.colorArray = colors;
    [self setTitle:self.title forState:UIControlStateNormal];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

-(CAGradientLayer *)gradient{
    if (!_gradient) {
        _gradient = [CAGradientLayer layer];
    }
    return _gradient;
}

- (CGFloat)percentOperation:(CGFloat)percent{
    if (percent == 0) {
        percent = 0.1;
    }
    return percent;
}

@end

