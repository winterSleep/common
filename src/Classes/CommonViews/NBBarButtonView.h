//
//  NBBarButtonView.h
//  Fish
//
//  Created by Li Zhiping on 22/09/2017.
//  Copyright © 2017 Li Zhiping. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BarButtonViewPosition) {
    BarButtonViewPositionLeft,
    BarButtonViewPositionRight
};

@interface NBBarButtonView : UIView

@property (nonatomic, assign) BarButtonViewPosition position;

@end
