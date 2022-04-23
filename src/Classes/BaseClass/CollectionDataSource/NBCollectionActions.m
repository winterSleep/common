//
//  NBCollectionActions.m
//  Fish
//
//  Created by Li Zhiping on 30/11/2017.
//  Copyright © 2017 Li Zhiping. All rights reserved.
//

#import "NBCollectionActions.h"

#import "NBCollectionCellFactory.h"
#import "NBCollectionViewModel.h"
#import <Nimbus/NimbusCore.h>
#import <Nimbus/NIActions+Subclassing.h>
#import <objc/runtime.h>

@interface NBCollectionActions()

@end

@implementation NBCollectionActions

- (id)initWithTarget:(id)target {
    if ((self = [super initWithTarget:target])) {
        
    }
    return self;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([collectionView.dataSource isKindOfClass:[NBCollectionViewModel class]]) {
        NBCollectionViewModel* model = (NBCollectionViewModel *)collectionView.dataSource;
        id object = [model objectAtIndexPath:indexPath];
        
        if ([self isObjectActionable:object]) {
            NIObjectActions* action = [self actionForObjectOrClassOfObject:object];
            
            BOOL shouldDeselect = NO;
            if (action.tapAction) {
                // Tap actions can deselect the row if they return YES.
                shouldDeselect = action.tapAction(object, self.target, indexPath);
            }
            if (action.tapSelector && [self.target respondsToSelector:action.tapSelector]) {
                NSMethodSignature *methodSignature = [self.target methodSignatureForSelector:action.tapSelector];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
                invocation.selector = action.tapSelector;
                if (methodSignature.numberOfArguments >= 3) {
                    [invocation setArgument:&object atIndex:2];
                }
                if (methodSignature.numberOfArguments >= 4) {
                    [invocation setArgument:&indexPath atIndex:3];
                }
                [invocation invokeWithTarget:self.target];
                
                NSUInteger length = invocation.methodSignature.methodReturnLength;
                if (length > 0) {
                    char *buffer = (void *)malloc(length);
                    memset(buffer, 0, sizeof(char) * length);
                    [invocation getReturnValue:buffer];
                    for (NSUInteger index = 0; index < length; ++index) {
                        if (buffer[index]) {
                            shouldDeselect = YES;
                            break;
                        }
                    }
                    free(buffer);
                }
            }
            if (shouldDeselect) {
                [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            }
            
            if (action.navigateAction) {
                action.navigateAction(object, self.target, indexPath);
            }
            if (action.navigateSelector && [self.target respondsToSelector:action.navigateSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.target performSelector:action.navigateSelector withObject:object withObject:indexPath];
#pragma clang diagnostic pop
            }
        }
    }
}

@end

