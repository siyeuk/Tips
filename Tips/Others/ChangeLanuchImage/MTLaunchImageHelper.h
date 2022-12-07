//
//  MTLaunchImageHelper.h
//  Tips
//
//  Created by lss on 2022/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLaunchImageHelper : NSObject

+ (UIImage *)snapshotStoryboardForPortrait:(NSString *)sbName;
+ (UIImage *)snapshotStoryboardForLandscape:(NSString *)sbName;

/// 替换所有的启动图为竖屏
+ (void)changeAllLaunchImageToPortrait:(UIImage *)image;
/// 替换所有的启动图为横屏
+ (void)changeAllLaunchImageToLandscape:(UIImage *)image;
/// 使用单独的图片分别替换竖、横屏启动图
+ (void)changePortraitLaunchImage:(UIImage *)portraitImage
             landscapeLaunchImage:(UIImage *)landScapeImage;



@end

NS_ASSUME_NONNULL_END
