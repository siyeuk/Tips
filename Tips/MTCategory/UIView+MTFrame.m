//
//  UIView+MTFrame.m
//  MT_Tips
//
//  Created by lss on 2022/10/10.
//

#import "UIView+MTFrame.h"

@implementation UIView (MTFrame)

- (void)setMt_x:(CGFloat)mt_x {
    CGRect frame = self.frame;
    frame.origin.x = mt_x;
    self.frame = frame;
}
- (CGFloat)mt_x {
    return self.frame.origin.x;
}

- (void)setMt_y:(CGFloat)mt_y {
    CGRect frame = self.frame;
    frame.origin.y = mt_y;
    self.frame = frame;
}
- (CGFloat)mt_y {
    return self.frame.origin.y;
}

- (void)setMt_width:(CGFloat)mt_w {
    CGRect frame = self.frame;
    frame.size.width = mt_w;
    self.frame = frame;
}
- (CGFloat)mt_width {
    return self.frame.size.width;
}

- (void)setMt_height:(CGFloat)mt_h {
    CGRect frame = self.frame;
    frame.size.height = mt_h;
    self.frame = frame;
}
- (CGFloat)mt_height {
    return self.frame.size.height;
}

- (void)setMt_size:(CGSize)mt_size {
    CGRect frame = self.frame;
    frame.size = mt_size;
    self.frame = frame;
}
- (CGSize)mt_size {
    return self.frame.size;
}

- (void)setMt_centerX:(CGFloat)mt_centerX {
    CGPoint center = self.center;
    center.x = mt_centerX;
    self.center = center;
}
- (CGFloat)mt_centerX {
    return self.center.x;
}

- (void)setMt_centerY:(CGFloat)mt_centerY {
    CGPoint center = self.center;
    center.y = mt_centerY;
    self.center = center;
}
- (CGFloat)mt_centerY {
    return self.center.y;
}

- (void)setMt_origin:(CGPoint)mt_origin {
    CGRect frame = self.frame;
    frame.origin = mt_origin;
    self.frame = frame;
}
- (CGPoint)mt_origin {
    return self.frame.origin;
}

- (CGFloat)mt_left{
    return self.frame.origin.x;
}
- (void)setMt_left:(CGFloat)left{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)mt_right{
    return CGRectGetMaxX(self.frame);
}

-(void)setMt_right:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)mt_top{
    return self.frame.origin.y;
}

- (void)setMt_top:(CGFloat)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)mt_bottom{
    return CGRectGetMaxY(self.frame);
}
- (void)setMt_bottom:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}



@end
