//
//  MTLaunchImageHelper.m
//  Tips
//
//  Created by lss on 2022/12/7.
//

#import "MTLaunchImageHelper.h"
#import "MTDynamicLaunchImage.h"

@implementation MTLaunchImageHelper

+ (UIImage *)snapshotStoryboard:(NSString *)sbName isPortrait:(BOOL)isPortrait {
    if (!sbName) {
        return nil;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:nil];
    UIViewController *vc = storyboard.instantiateInitialViewController;
    vc.view.frame = [UIScreen mainScreen].bounds;
    if (isPortrait) {
        if (vc.view.frame.size.width > vc.view.frame.size.height) {
            vc.view.frame = CGRectMake(0, 0, vc.view.frame.size.height, vc.view.frame.size.width);
        }
    } else {
        if (vc.view.frame.size.width < vc.view.frame.size.height) {
            vc.view.frame = CGRectMake(0, 0, vc.view.frame.size.height, vc.view.frame.size.width);
        }
    }
    
    [vc.view setNeedsLayout];
    [vc.view layoutIfNeeded];
    
    UIGraphicsBeginImageContextWithOptions(vc.view.frame.size, NO, [UIScreen mainScreen].scale);
    [vc.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)snapshotStoryboardForPortrait:(NSString *)sbName {
    return [self snapshotStoryboard:sbName isPortrait:YES];
}

+ (UIImage *)snapshotStoryboardForLandscape:(NSString *)sbName {
    return [self snapshotStoryboard:sbName isPortrait:NO];
}

+ (void)changeAllLaunchImageToPortrait:(UIImage *)image {
    if (!image) {
        return;
    }
    // 全部替换为竖屏启动图
    image = [self resizeImage:image toPortraitScreenSize:YES];
    [MTDynamicLaunchImage replaceLaunchImage:image];
}

+ (void)changeAllLaunchImageToLandscape:(UIImage *)image {
    if (!image) {
        return;
    }
    // 全部替换为横屏启动图
    image = [self resizeImage:image toPortraitScreenSize:NO];
    [MTDynamicLaunchImage replaceLaunchImage:image];
}

+ (void)changePortraitLaunchImage:(UIImage *)portraitImage
             landscapeLaunchImage:(UIImage *)landscapeImage {
    if (!portraitImage || !landscapeImage) {
        return;
    }
    
    // 替换竖屏启动图
    portraitImage = [self resizeImage:portraitImage toPortraitScreenSize:YES];
    [MTDynamicLaunchImage replaceLaunchImage:portraitImage compressionQuality:0.8 customValidation:^BOOL(UIImage *systemImage, UIImage *yourImage) {
        return [self checkImage:systemImage sizeEqualToImage:yourImage];
    }];
    
    // 替换横屏启动图
    landscapeImage = [self resizeImage:landscapeImage toPortraitScreenSize:NO];
    [MTDynamicLaunchImage replaceLaunchImage:landscapeImage compressionQuality:0.8 customValidation:^BOOL(UIImage *systemImage, UIImage *yourImage) {
        return [self checkImage:systemImage sizeEqualToImage:yourImage];
    }];
}

// 通过图片尺寸匹配，竖屏方向图只替换竖屏，横屏方向图只替换横屏
+ (BOOL)checkImage:(UIImage *)aImage sizeEqualToImage:(UIImage *)bImage {
    return CGSizeEqualToSize([self obtainImageSize:aImage], [self obtainImageSize:bImage]);
}

+ (CGSize)obtainImageSize:(UIImage *)image {
    return CGSizeMake(CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
}

+ (CGSize)contextSizeForPortrait:(BOOL)isPortrait {
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat width = MIN(screenSize.width, screenSize.height);;
    CGFloat height = MAX(screenSize.width, screenSize.height);
    if (!isPortrait) {
        width = MAX(screenSize.width, screenSize.height);
        height = MIN(screenSize.width, screenSize.height);
    }
    CGSize contextSize = CGSizeMake(width * screenScale, height * screenScale);
    return contextSize;
}

+ (UIImage *)resizeImage:(UIImage *)image toPortraitScreenSize:(BOOL)isPortrait {
    CGSize imageSize = CGSizeApplyAffineTransform(image.size,
                                                  CGAffineTransformMakeScale(image.scale, image.scale));
    CGSize contextSize = [self contextSizeForPortrait:isPortrait];
    
    if (!CGSizeEqualToSize(imageSize, contextSize)) {
        UIGraphicsBeginImageContext(contextSize);
        CGFloat ratio = MAX((contextSize.width / image.size.width),
                            (contextSize.height / image.size.height));
        CGRect rect = CGRectMake(0, 0, image.size.width * ratio, image.size.height * ratio);
        [image drawInRect:rect];
        UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resizedImage;
    }
    
    return image;
}

@end
