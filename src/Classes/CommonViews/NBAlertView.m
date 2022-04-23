//
//  NBAlertView.m
//  Fish
//
//  Created by Li Zhiping on 4/12/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import "NBAlertView.h"

@interface NBAlertView ()<UIAlertViewDelegate>

@end

@implementation NBAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if (self) {
        va_list arguments;
        id eachObject;
        if (otherButtonTitles) {
            va_start(arguments, otherButtonTitles);
            [self addButtonWithTitle:otherButtonTitles];
            while ((eachObject = va_arg(arguments, id))) {
                [self addButtonWithTitle:eachObject];
            }
            va_end(arguments);
        }
        
        self.delegate = self;
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.dismissBlock) {
        BOOL isCancel = (buttonIndex == self.cancelButtonIndex);
        self.dismissBlock(buttonIndex, isCancel);
    }
}

@end
