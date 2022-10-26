//
//  MTPaddingLabel.m
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import "MTPaddingLabel.h"

@implementation MTPaddingLabel

- (void)drawTextInRect:(CGRect)rect {
  [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textPadding)];
}
- (void)setTextPadding:(UIEdgeInsets)textPadding {
    _textPadding = textPadding;
    [self setNeedsLayout];
}

@end
