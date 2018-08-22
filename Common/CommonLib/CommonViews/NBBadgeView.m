//
//  NBBadgeView.m
//  NBChat
//
//  Created by Li Zhiping on 12/19/14.
//  Copyright (c) 2014 Li Zhiping. All rights reserved.
//

#import "NBBadgeView.h"

@implementation NBBadgeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib{
    [self commonInit];
    [super awakeFromNib];
}

- (void)commonInit{
    _badgeBackgroundColor = [UIColor redColor];
    _badgeTextColor = [UIColor whiteColor];
    _badgeTextFont = [UIFont systemFontOfSize:12];
    _badgePositionAdjustment = UIOffsetZero;
    [self setUserInteractionEnabled:NO];
}

- (void)setBadgeValue:(NSString *)badgeValue{
    if (![badgeValue isEqualToString:_badgeValue]) {
        _badgeValue = badgeValue;
        [self invalidateIntrinsicContentSize];
        [self setNeedsDisplay];
    }
}

- (CGSize)intrinsicContentSize{
    if (self.badgeValue) {
        CGSize badgeSize = CGSizeZero;
        badgeSize = [_badgeValue boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [self badgeTextFont]}
                                              context:nil].size;
        CGFloat textOffset = 2.0f;
        if (badgeSize.width < badgeSize.height) {
            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
        }
        CGRect badgeBackgroundFrame = CGRectMake(0,0,
                                                  badgeSize.width + 2 * textOffset, badgeSize.height + 2 * textOffset);
        
        return badgeBackgroundFrame.size;
    }
    return CGSizeZero;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // Draw badges
    if ([[self badgeValue] length] && ![[self badgeValue] isEqualToString:@"0"]) {
        CGSize badgeSize = CGSizeZero;
        
        badgeSize = [_badgeValue boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [self badgeTextFont]}
                                              context:nil].size;
        CGFloat textOffset = 0.0f;
        if (badgeSize.width < badgeSize.height) {
            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
        }
        
        CGRect badgeBackgroundFrame = self.bounds;
        
        if ([self badgeBackgroundColor]) {
            CGContextSetFillColorWithColor(context, [[self badgeBackgroundColor] CGColor]);
            CGContextFillEllipseInRect(context, badgeBackgroundFrame);
        } else if ([self badgeBackgroundImage]) {
            [[self badgeBackgroundImage] drawInRect:badgeBackgroundFrame];
        }
        
        CGContextSetFillColorWithColor(context, [[self badgeTextColor] CGColor]);
        NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [badgeTextStyle setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *badgeTextAttributes = @{
                                              NSFontAttributeName: [self badgeTextFont],
                                              NSForegroundColorAttributeName: [self badgeTextColor],
                                              NSParagraphStyleAttributeName: badgeTextStyle,
                                              };
        
        [[self badgeValue] drawInRect:CGRectMake((CGRectGetWidth(badgeBackgroundFrame)-badgeSize.width)/2.0f + textOffset,
                                                 (CGRectGetHeight(badgeBackgroundFrame)-badgeSize.height)/2.0f + textOffset,
                                                 badgeSize.width, badgeSize.height)
                       withAttributes:badgeTextAttributes];
    }
    
    CGContextRestoreGState(context);
}

@end
