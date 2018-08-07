//
//  NSData+AES.h
//  Fish
//
//  Created by Li Zhiping on 6/15/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

//加密
- (NSData *)aes256_encrypt:(NSString *)key;

//解密
- (NSData *)aes256_decrypt:(NSString *)key;

@end
