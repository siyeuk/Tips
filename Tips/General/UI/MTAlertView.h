//
//  MTAlertView.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTAlertView : NSObject

/// 展示几秒后自动隐藏
/// - Parameters:
///   - text: 文本
///   - delay: 展示时长
+ (void)showAlertViewWithText:(NSString *)text delayHid:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
