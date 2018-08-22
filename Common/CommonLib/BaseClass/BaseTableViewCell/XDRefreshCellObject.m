//
//  XDRefreshCellObject.m
//  Fish
//
//  Created by Li Zhiping on 10/10/15.
//  Copyright © 2015 Li Zhiping. All rights reserved.
//

#import "XDRefreshCellObject.h"

NSString *const kRefreshActionEvent = @"refreshActionEvent";

@implementation XDRefreshCellObject

- (Class)cellClass{
    return [XDRefreshCell class];
}

@end

@interface XDRefreshCell ()

@property (strong, nonatomic)UIButton *refreshButton;

@end

@implementation XDRefreshCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textLabel setFrame:self.contentView.bounds];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}

@end