//
//  UIView+Category.h
//  Fish
//
//  Created by Li Zhiping on 10/8/15.
//  Copyright © 2015 Li Zhiping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

@property (assign, nonatomic)BOOL isViewShow;

- (void)viewWillAppear:(BOOL)animated;    // Called when the view is about to made visible. Default does nothing
- (void)viewDidAppear:(BOOL)animated;     // Called when the view has been fully transitioned onto the screen. Default does nothing
- (void)viewWillDisappear:(BOOL)animated; // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
- (void)viewDidDisappear:(BOOL)animated;  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing

@end
