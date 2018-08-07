//
//  NBActionSheet.h
//  Fish
//
//  Created by Li Zhiping on 4/12/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  actionSheet的扩展类, 支持block直接回调, 更方便代码归整
 */
@interface NBActionSheet : UIActionSheet

@property (strong, nonatomic)void (^dismissBlock)(NSInteger clickedIndex, BOOL isCancel);

@end
