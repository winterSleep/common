//
//  NBActionSheet.m
//  Fish
//
//  Created by Li Zhiping on 4/12/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import "NBActionSheet.h"

@interface NBActionSheet () <UIActionSheetDelegate>

@end

@implementation NBActionSheet

- (instancetype)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    
    self = [super initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.dismissBlock) {
        BOOL isCancel = (buttonIndex == self.cancelButtonIndex);
        self.dismissBlock(buttonIndex, isCancel);
    }
}

@end
