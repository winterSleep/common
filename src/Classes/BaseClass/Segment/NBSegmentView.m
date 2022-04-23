//
//  NBSegmentView.m
//  Fish
//
//  Created by Li Zhiping on 1/8/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import "NBSegmentView.h"
#import "UIImage+Color.h"
#import "Colours.h"
#import "UIView+FrameCategory.h"

@implementation NBSquareSegmentItem

@end

@interface NBSegmentView ()

@property (strong, nonatomic)NSMutableArray *items;

@property (strong, nonatomic)NSMutableArray *buttons;

//右上角的小红点提示
@property (strong, nonatomic)NSMutableArray *hintViews;

@property (strong, nonatomic)UIImageView *bottomLine;

//底部的小蓝点
@property (strong, nonatomic)UIView *bottomHintLine;

@property (strong, nonatomic)UIColor *defaultColor;
@property (strong, nonatomic)UIColor *selectedColor;

@property (assign, nonatomic)CGFloat previousOffset;

@property (assign, nonatomic)NSInteger selectedIndex;

@end

@implementation NBSegmentView

@synthesize delegate;

- (instancetype)initWithItems:(NSArray *)items{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _selectedIndex = -1;
        
        [self initialization];
        
        [self addSegmentItems:items];
        
        [self setSelectedIndex:0];
        
        self.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithItems:nil];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initialization];
}

- (void)initialization{
    
    self.items = [NSMutableArray array];
    self.buttons = [NSMutableArray array];
    self.hintViews = [NSMutableArray array];
    
    //最底部一条线
    [self addSubview:self.bottomLine];
    [self bringSubviewToFront:self.bottomLine];
    self.defaultColor = [UIColor colorFromHexString:@"#999999"];
    self.selectedColor = [UIColor colorFromHexString:@"#039bfb"];
    
    self.bottomHintLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 2)];
    [self.bottomHintLine setBackgroundColor:[UIColor colorFromHexString:@"#039bfb"]];
    [self addSubview:self.bottomHintLine];
}

- (UIImageView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = [UIColor blackColor];
        _bottomLine.alpha = 0.1;
    }
    return _bottomLine;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.items.count > 0) {
        //设置按钮的frame
        CGFloat buttonWidth = [self itemButtonWidth];
        CGFloat buttonLeft = 0;
        CGFloat buttonHeight = self.height;
        
        UIFont *font = [UIFont systemFontOfSize:[self selectedFontSize]];
        for (int i=0; i<self.buttons.count; i++) {
            UIButton *button = [self.buttons objectAtIndex:i];
            [button setFrame:CGRectMake(buttonLeft, 0, buttonWidth, buttonHeight)];
            
            NSString *title = [button titleForState:UIControlStateNormal];
            CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:font}];
            CGFloat hintViewHeight = 8.0f;
            UIView *hintView = [self.hintViews objectAtIndex:i];
            [hintView setFrame:CGRectMake(button.centerX+titleSize.width/2.0f+2, button.centerY - titleSize.height/2.0f - 2, hintViewHeight, hintViewHeight)];
            [hintView.layer setCornerRadius:hintViewHeight/2];
            [hintView.layer setMasksToBounds:YES];
            hintView.clipsToBounds = YES;
            
            buttonLeft += buttonWidth;
        }
        [self.bottomLine setFrame:CGRectMake(0, self.bottom-0.5, self.width, 0.5)];
        NSInteger selectedIndex = 0;
        if (self.selectedIndex >= 0) {
            selectedIndex = self.selectedIndex;
        }
        UIButton *btn = [self.buttons objectAtIndex:selectedIndex];
        CGFloat width = self.bottomHintLine.width;
        CGFloat height = self.bottomHintLine.height;
        CGFloat left = btn.centerX - width/2.0f;
        CGFloat top = self.height - height;
        [self.bottomHintLine setFrame:CGRectMake(left, top, width, height)];
    }
}

- (CGFloat)itemButtonWidth{
    return self.width/self.items.count;
}

- (void)addSegmentItem:(NBSquareSegmentItem *)item{
    if (item) {
        [self addSegmentItems:@[item]];
    }
}

- (void)addSegmentItems:(NSArray *)segmentItems{
    for (NBSquareSegmentItem *item in segmentItems) {
        [self.items addObject:item];
        UIButton *button = [self buttonWithItem:item];
        [self addSubview:button];
        [self.buttons addObject:button];
        
        UIImage *image = [UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(30, 30)];
        UIView *hintView = [[UIImageView alloc] initWithImage:image];
        [hintView.layer setMasksToBounds:YES];
        [hintView setHidden:YES];
        [self.hintViews addObject:hintView];
        [self addSubview:hintView];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)insertSegmentItem:(NBSquareSegmentItem *)item
                  atIndex:(NSInteger)index{
    if (item && index >= 0 && index <self.items.count) {
        [self.items insertObject:item atIndex:index];
        
        UIButton *button = [self buttonWithItem:item];
        [self addSubview:button];
        [self.buttons insertObject:button atIndex:index];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (UIButton *)buttonWithItem:(NBSquareSegmentItem *)item{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:item.title forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:[self defaultFontSize]]];
    
    [button setTitleColor:self.defaultColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
    [button setTitleColor:self.selectedColor forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(segmentTapAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)segmentTapAction:(UIButton *)btn{
    NSInteger index = [self.buttons indexOfObject:btn];
    BOOL canSelect = true;
    if (self.delegate && [self.delegate respondsToSelector:@selector(squareSegmentView:canSelectedAtIndex:)]) {
        canSelect = [self.delegate squareSegmentView:self canSelectedAtIndex:index];
    }
    if (canSelect) {
        [self setSelectedIndex:index animated:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(squareSegmentView:didSelectedAtIndex:)]) {
            [self.delegate squareSegmentView:self didSelectedAtIndex:index];
        }
    }
}

- (void)setOffsetWithScrollViewWidth:(CGFloat)width
                    scrollViewOffset:(CGFloat)offset{
    
    NSInteger currentIndex = offset/width;
    NSInteger nextIndex = 0;
    //如果是在向右滑动(即显示右侧的内容)
    if (self.previousOffset < offset) {
        nextIndex = currentIndex + 1;
    }else{
        currentIndex += 1;
        nextIndex = currentIndex - 1;
    }
    
    if (nextIndex >= 0 &&
        nextIndex < self.items.count &&
        currentIndex < self.items.count) {
        
        int movedDistance = (int)offset%(int)width;
        if (nextIndex < currentIndex) {
            movedDistance = fabs(width - movedDistance);
        }
        if (movedDistance != 0) {
            CGFloat totalDistance = width;
            CGFloat rate = movedDistance/totalDistance;

            //修改当前显示按钮的字体
            CGFloat fontSize = [self selectedFontSize] - ([self selectedFontSize] - [self defaultFontSize]) * (rate);
            UIButton *currentButton = [self.buttons objectAtIndex:currentIndex];
            [currentButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
            
            //修改将要显示的按钮的字体
            CGFloat nextButtonFontSize = [self defaultFontSize] + ([self selectedFontSize] - [self defaultFontSize]) * rate;
            UIButton *nextButton = [self.buttons objectAtIndex:nextIndex];
            [nextButton.titleLabel setFont:[UIFont systemFontOfSize:nextButtonFontSize]];
            
            CGFloat green = 0;
            CGFloat blue = 0;
            CGFloat red = 0;
            [self.defaultColor getRed:&red green:&green blue:&blue alpha:nil];
            
            CGFloat nextBlue = 0;
            CGFloat nextGreen = 0;
            CGFloat nextRed = 0;
            [self.selectedColor getRed:&nextRed green:&nextGreen blue:&nextBlue alpha:nil];
            
            CGFloat green1 = green + (nextGreen - green)*rate;
            CGFloat blue1 = blue + (nextBlue - blue)*rate;
            CGFloat red1 = red + (nextRed - red)*rate;
            UIColor *color = [[UIColor alloc] initWithRed:red1 green:green1 blue:blue1 alpha:1];
            [nextButton setTitleColor:color forState:UIControlStateNormal];
            
            nextGreen = nextGreen + (green - nextGreen)*rate;
            nextBlue = nextBlue + (blue - nextBlue)*rate;
            nextRed = nextRed + (red - nextRed)*rate;
            color = [[UIColor alloc] initWithRed:nextRed green:nextGreen blue:nextBlue alpha:1];
            [currentButton setTitleColor:color forState:UIControlStateNormal];
            
            CGFloat width = self.bottomHintLine.width;
            CGFloat height = self.bottomHintLine.height;
            CGFloat left = currentButton.centerX - width/2.0f + (nextButton.left - currentButton.left)*rate;
            CGFloat top = self.height - height;
            [self.bottomHintLine setFrame:CGRectMake(left, top, width, height)];
        }
    }
    self.previousOffset = offset;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (CGFloat)selectedFontSize{
    return 17;
}

- (CGFloat)defaultFontSize{
    return 17;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
                animated:(BOOL)animated{
    if (selectedIndex != self.selectedIndex &&
        selectedIndex >= 0 &&
        selectedIndex < self.items.count) {
        
        UIButton *preBtn = nil;
        if (self.selectedIndex >= 0 && self.selectedIndex < self.items.count) {
            preBtn = [self.buttons objectAtIndex:self.selectedIndex];
            [preBtn setTitleColor:self.defaultColor forState:UIControlStateNormal];
        }
        
        _selectedIndex = selectedIndex;
        
        UIButton *btn = [self.buttons objectAtIndex:selectedIndex];
        [btn setTitleColor:self.selectedColor forState:UIControlStateNormal];
        
        CGFloat selectedFontSize = [self selectedFontSize];
        CGFloat defaultFontSize = [self defaultFontSize];
        
        CGFloat width = self.bottomHintLine.width;
        CGFloat height = self.bottomHintLine.height;
        CGFloat left = btn.centerX - width/2.0f;
        CGFloat top = self.height - height;
        
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                [btn.titleLabel setFont:[UIFont systemFontOfSize:selectedFontSize]];
                [preBtn.titleLabel setFont:[UIFont systemFontOfSize:defaultFontSize]];
                [self.bottomHintLine setFrame:CGRectMake(left, top, width, height)];
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [btn.titleLabel setFont:[UIFont systemFontOfSize:selectedFontSize]];
            [preBtn.titleLabel setFont:[UIFont systemFontOfSize:defaultFontSize]];
            [self.bottomHintLine setFrame:CGRectMake(left, top, width, height)];
        }
    }
}

- (void)setShouldShowHint:(BOOL)shouldHint atIndex:(NSInteger)index{
    if (index < [self.hintViews count]) {
        UIView *hintView = [self.hintViews objectAtIndex:index];
        [hintView setHidden:!shouldHint];
    }
}

@end
