//
//  MTMethod.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//四个圆角半径
struct MTCornerRadii {
    CGFloat topLeft; //左上
    CGFloat topRight; //右上
    CGFloat bottomLeft; //左下
    CGFloat bottomRight; //右下
};
typedef struct CG_BOXABLE MTCornerRadii MTCornerRadii;
//MTCornerRadii初始化函数
CG_INLINE MTCornerRadii MTCornerRadiiMake(CGFloat topLeft,CGFloat topRight,CGFloat bottomLeft,CGFloat bottomRight){
    return (MTCornerRadii){
        topLeft,
        topRight,
        bottomLeft,
        bottomRight,
    };
}
static NSString * const MTUserDefaultsKey = @"MTUserDefaultsKey";
/// 其他通用方法
@interface MTMethod : NSObject

/// 以MTUserDefaultsKey为根key，统一管理userDefaults存储的数据
+ (void)userDefaultsSetObject:(nullable id)value forKey:(NSString *)key;
+ (id)userDefaultsObjectForKey:(NSString *)key;

/// 动态计算文字宽高
/// - Parameters:
///   - text: 文字
///   - font: 文字的font
///   - maxSize: 最大size
///   - 返回text的size
+ (CGSize)sizeFromText:(NSString *)text textFont:(UIFont *)font maxSize:(CGSize)maxSize;

/// 动态计算属性字符串的宽高
/// - Parameters:
///   - attributedText: 属性字符串
///   - maxSize: 最大size
///   - 返回text的size
+ (CGSize)sizeFromAttributedText:(NSAttributedString *)attributedText maxSize:(CGSize)maxSize;

/// 切四个不同半径圆角的函数
/// - Parameters:
///   - bounds: bounds 区域
///   - cornerRadii: 四个圆角的半径
+ (CGPathRef)cornerPathCreateWithRoundedRect:(CGRect)bounds cornerRadii:(MTCornerRadii)cornerRadii;


@end

NS_ASSUME_NONNULL_END
