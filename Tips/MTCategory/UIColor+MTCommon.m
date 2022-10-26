//
//  UIColor+MTCommon.m
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import "UIColor+MTCommon.h"

@implementation UIColor (MTCommon)


/// 根据16进制颜色值返回UIColor
/// @param hexValue 16进制值
/// @param alpha 透明度
+ (UIColor *)mt_colorWithHex:(int)hexValue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alpha];
}

/// 根据UIColor实例获得RGBA的值
/// @param color UIColor实例
+ (NSArray *)mt_rgbaValueWithColor:(UIColor *)color {
    NSInteger numComponents = CGColorGetNumberOfComponents(color.CGColor);
    NSArray *array = nil;
    if (numComponents == 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        array = @[@((int)(components[0] * 255)),
                  @((int)(components[1] * 255)),
                  @((int)(components[2] * 255)),
                  @(components[3])];
    }
    return array;
}

/// 根据UIColor实例返回16进制颜色值
/// @param color UIColor实例
+ (int)mt_hexValueWithColor:(UIColor *)color {
    NSArray *rgba = [UIColor mt_rgbaValueWithColor:color];
    if (rgba.count == 4) {
        return (([rgba[0] intValue] << 16) | ([rgba[1] intValue] << 8) | [rgba[2] intValue]);
    }
    return 0x000000;
}


@end
