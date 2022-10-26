//
//  UIView+MTImage.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// View转换为Image
@interface UIView (MTImage)

/// 截取视图转Image
/// - Parameter range: 截图区域
- (UIImage *)mt_imageByViewInRect:(CGRect)range;

@end

NS_ASSUME_NONNULL_END
