//
//  MTDynamicLaunchImage.h
//  Tips
//
//  Created by lss on 2022/12/7.
//

#import <Foundation/Foundation.h>


// 引自 DynamicLaunchImage，pod不下来，为避免以后重名，故更改前缀
NS_ASSUME_NONNULL_BEGIN

/// 自定义校验规则，originImage为原始系统缓存启动图，yourImage为替代的启动图，返回YES代表本次替换，否则本次不会进行替换
typedef BOOL(^MTCustomValicationBlock)(UIImage *originImage, UIImage *yourImage);

/**
 动态启动图（请确保替换的图片尺寸与屏幕分辨率一致，否则替换不成功）
*/
@interface MTDynamicLaunchImage : NSObject

/// 替换系统缓存启动图，图片压缩质量默认0.8，覆盖原有系统启动图文件
/// @param replacementImage 替代图片
/// @return 替换是否成功
+ (BOOL)replaceLaunchImage:(UIImage *)replacementImage;

/// 替换系统缓存启动图，将替换图片以指定的压缩质量写入系统启动图缓存目录，覆盖原有系统启动图文件
/// @param replacementImage 替代图片
/// @param quality 压缩质量
/// @return 替换是否成功
+ (BOOL)replaceLaunchImage:(UIImage *)replacementImage compressionQuality:(CGFloat)quality;

/// 替换系统缓存启动图，按自定义的校验规则将替代图片以指定的压缩质量写入系统启动图缓存目录，覆盖原有系统启动图文件
/// @param replacementImage 替代图片
/// @param quality 压缩质量
/// @param validationBlock 自定义校验回调，校验通过表示本次替换，否则不替换
/// @return 替换是否成功
+ (BOOL)replaceLaunchImage:(UIImage *)replacementImage
        compressionQuality:(CGFloat)quality
          customValidation:(MTCustomValicationBlock)validationBlock;

@end

NS_ASSUME_NONNULL_END
