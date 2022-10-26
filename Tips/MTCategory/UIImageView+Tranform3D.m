//
//  UIImageView+Tranform3D.m
//  MT_Tips
//
//  Created by lss on 2022/10/25.
//

#import "UIImageView+Tranform3D.h"

@implementation UIImageView (Tranform3D)

- (void)setRotation:(CGFloat)degress{
    CATransform3D tranform = CATransform3DIdentity;
    tranform.m34 = 1.0 / 100;
    CGFloat radiants = degress / 360 * M_PI;
    //旋转
    tranform = CATransform3DRotate(tranform, radiants, 1.0f, 0.0f, 0.0f);
    
    //锚点
    CALayer * layer = self.layer;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.transform = tranform;
}

@end
