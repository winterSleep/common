#import <Foundation/Foundation.h>

@interface NSString (RemoveEmoji)

- (BOOL)isIncludingEmoji;

- (instancetype)stringByRemovingEmoji;

- (instancetype)removedEmojiString __attribute__((deprecated));

- (BOOL)isEmoji;

//删除最后一个字符
- (instancetype)deleteLastCharacter;

@end
