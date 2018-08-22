//
//  NBBadgeView.h
//  NBChat
//
//  Created by Li Zhiping on 12/19/14.
//  Copyright (c) 2014 Li Zhiping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBBadgeView : UIView

#pragma mark - Badge configuration

/**
 * Text that is displayed in the upper-right corner of the item with a surrounding background.
 */
@property (copy, nonatomic) NSString *badgeValue;

/**
 * Image used for background of badge.
 */
@property (strong) UIImage *badgeBackgroundImage;

/**
 * Color used for badge's background.
 */
@property (strong) UIColor *badgeBackgroundColor;

/**
 * Color used for badge's text.
 */
@property (strong) UIColor *badgeTextColor;

/**
 * The offset for the rectangle around the tab bar item's badge.
 */
@property (nonatomic) UIOffset badgePositionAdjustment;

/**
 * Font used for badge's text.
 */
@property (nonatomic) UIFont *badgeTextFont;

@end
