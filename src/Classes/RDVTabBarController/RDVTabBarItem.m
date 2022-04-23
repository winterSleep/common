// RDVTabBarItem.h
// RDVTabBarController
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RDVTabBarItem.h"
#import "NBBadgeView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface RDVTabBarItem () {
    NSString *_title;
    UIOffset _imagePositionAdjustment;
    NSDictionary *_unselectedTitleAttributes;
    NSDictionary *_selectedTitleAttributes;
}

@property (strong, nonatomic)UIImage *unselectedBackgroundImage;
@property (strong, nonatomic)UIImage *selectedBackgroundImage;
@property (strong, nonatomic)UIImage *unselectedImage;
@property (strong, nonatomic)UIImage *selectedImage;

@property (strong, nonatomic)UIImageView *backgroundImageView;
@property (strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic)UILabel *titleLabel;

@property (strong, nonatomic)NSURL *unselectedURL;
@property (strong, nonatomic)NSURL *selectedURL;
@property (strong, nonatomic)NBBadgeView *badgeView;

@end

@implementation RDVTabBarItem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateTitleAndImage];
}

- (void)commonInitialization {
    // Setup defaults
    
    [self setBackgroundColor:[UIColor clearColor]];
//    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _title = @"";
    _titlePositionAdjustment = UIOffsetZero;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        _unselectedTitleAttributes = @{
                                       NSFontAttributeName: [UIFont systemFontOfSize:12],
                                       NSForegroundColorAttributeName: [UIColor blackColor],
                                       };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        _unselectedTitleAttributes = @{
                                       UITextAttributeFont: [UIFont systemFontOfSize:12],
                                       UITextAttributeTextColor: [UIColor blackColor],
                                       };
#endif
    }
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:nil];
    [self addSubview:self.backgroundImageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:nil];
    [self addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:self.titleLabel];
    
    self.badgeView = [[NBBadgeView alloc] init];
    [self.badgeView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.badgeView];
    
    [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4.0f);
        make.bottom.equalTo(self.titleLabel.mas_top).offset(-4);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.imageView.mas_height);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(-3.0f);
    }];
    [self.badgeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(-2);
        make.top.mas_equalTo(3.0f);
    }];
    
    _selectedTitleAttributes = [_unselectedTitleAttributes copy];
    self.badgeView.badgeBackgroundColor = [UIColor redColor];
    self.badgeView.badgeTextColor = [UIColor whiteColor];
    self.badgeView.badgeTextFont = [UIFont systemFontOfSize:12];
    self.badgeView.badgePositionAdjustment = UIOffsetZero;
    
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisVertical];
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisVertical];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self updateTitleAndImage];
}

- (void)updateTitleAndImage{
    if (self.selected) {
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:self.title attributes:self.selectedTitleAttributes];
        [self.titleLabel setAttributedText:string];
        if (self.selectedURL) {
            [self.imageView sd_setImageWithURL:self.selectedURL placeholderImage:[self selectedImage]];
        }else{
            [self.imageView setImage:[self selectedImage]];
        }
    }else{
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:self.title attributes:self.unselectedTitleAttributes];
        [self.titleLabel setAttributedText:string];
        if (self.unselectedURL) {
            [self.imageView sd_setImageWithURL:self.unselectedURL placeholderImage:[self unselectedImage]];
        }else{
            [self.imageView setImage:[self unselectedImage]];
        }
    }
}

- (void)drawRect:(CGRect)rect {
    CGSize frameSize = self.frame.size;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (self.showRedHint) {
        CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
        CGContextFillEllipseInRect(context, CGRectMake(roundf(frameSize.width/2.0+6), 5, 8, 8));
    }
    CGContextRestoreGState(context);
}

#pragma mark - Image configuration

- (UIImage *)finishedSelectedImage {
    return [self selectedImage];
}

- (UIImage *)finishedUnselectedImage {
    return [self unselectedImage];
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && (selectedImage != [self selectedImage])) {
        [self setSelectedImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedImage])) {
        [self setUnselectedImage:unselectedImage];
    }
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    [self.badgeView setBadgeValue:badgeValue];
    [self.badgeView invalidateIntrinsicContentSize];
}

- (void)setShowRedHint:(BOOL)showRedHint{
    _showRedHint = showRedHint;
    [self setNeedsDisplay];
}

#pragma mark - Background configuration

- (UIImage *)backgroundSelectedImage {
    return [self selectedBackgroundImage];
}

- (UIImage *)backgroundUnselectedImage {
    return [self unselectedBackgroundImage];
}

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && (selectedImage != [self selectedBackgroundImage])) {
        [self setSelectedBackgroundImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedBackgroundImage])) {
        [self setUnselectedBackgroundImage:unselectedImage];
    }
}

- (void)updateWithRemote:(NSURL *)selectedImageURL unselectedURL:(NSURL *)unselectedURL{
    self.selectedURL = selectedImageURL;
    self.unselectedURL = unselectedURL;
    [self updateTitleAndImage];
}

@end
