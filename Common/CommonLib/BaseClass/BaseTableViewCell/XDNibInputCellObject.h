//
//  XDNibInputCellObject.h
//  Fish
//
//  Created by Li Zhiping on 8/4/16.
//  Copyright © 2016 Li Zhiping. All rights reserved.
//

#import "XDNibCellObject.h"

@interface XDNibInputCellObject : XDNibCellObject

@property (copy, nonatomic)NSString *text;
@property (copy, nonatomic)NSString *placeholder;

@end

@interface XDNibInputCell : XDNibCell

@property (strong, nonatomic)IBOutlet UITextField *textField;
@property (strong, nonatomic)IBOutlet UITextView *textView;

@end