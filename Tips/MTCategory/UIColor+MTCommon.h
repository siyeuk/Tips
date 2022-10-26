//
//  UIColor+MTCommon.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (MTCommon)

/// 根据16进制颜色值返回UIColor
/// @param hexValue 16进制值
/// @param alpha 透明度
+ (UIColor *)mt_colorWithHex:(int)hexValue alpha:(CGFloat)alpha;

/// 根据UIColor实例获得RGBA的值
/// @param color UIColor实例
+ (NSArray *)mt_rgbaValueWithColor:(UIColor *)color;

/// 根据UIColor实例返回16进制颜色值
/// @param color UIColor实例
+ (int)mt_hexValueWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
