//
//  UIImage+MTCommon.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MTCommon)

//将图片旋转弧度radians
- (UIImage *)mt_imageRotatedByRadians:(CGFloat)radians;

//提取图片上某位置像素的颜色
- (UIColor *)mt_colorAtPixel:(CGPoint)point;

//图片缩放，针对大图片处理
+ (UIImage *)mt_scaledImageWithData:(NSData *)data withSize:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
