//
//  NSBundle+AssociatedBundle.h
//  Common
//
//  Created by Li Zhiping on 2018/11/26.
//  Copyright © 2018 Lizhiping. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (AssociatedBundle)

+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName;

@end

NS_ASSUME_NONNULL_END
