//
//  XDNibInputCellObject.m
//  Fish
//
//  Created by Li Zhiping on 8/4/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import "XDNibInputCellObject.h"

@implementation XDNibInputCellObject

- (UINib *)cellNib{
    NSAssert(true, @"必须继承重写该方法");
    return nil;
}

- (Class)cellClassForHeight{
    return [XDNibInputCell class];
}

@end

@interface XDNibInputCell ()

@end

@implementation XDNibInputCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self _initialization1];
}

- (void)_initialization1{
    if (self.textField) {
        [self.textField addTarget:self action:@selector(textFieldDidChangeValue) forControlEvents:UIControlEventAllEditingEvents];
    }
    
    if (self.textView) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidChangeNotification object:self.textView];
    }
}

- (void)textViewChanged:(NSNotification *)noti{
    XDNibInputCellObject *cellObject = self.cellObject;
    cellObject.text = self.textView.text;
}

- (void)textFieldDidChangeValue{
    XDNibInputCellObject *cellObject = self.cellObject;
    cellObject.text = self.textField.text;
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    [super shouldUpdateCellWithObject:object];
    XDNibInputCellObject *cellObject = object;
    self.textField.text = cellObject.text;
    self.textField.placeholder = cellObject.placeholder;
    self.textView.text = cellObject.text;
    
    return YES;
}

- (void)dealloc{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

@end
