//
//  MTDelayPerform.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 延迟执行
@interface MTDelayPerform : NSObject

/// 开始延迟执行  每次调用就重新开始计时   用完记得 执行mt_cancelDelayPerform
/// @param perform  执行内容
/// @param delay 延迟时间
+ (void)mt_startDelayPerform:(void(^)(void))perform afterDelay:(NSTimeInterval)delay;
///取消延迟执行
+ (void)mt_cancelDelayPerform;

@end

NS_ASSUME_NONNULL_END
