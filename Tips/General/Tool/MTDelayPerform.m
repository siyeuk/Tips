//
//  MTDelayPerform.m
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import "MTDelayPerform.h"

//延迟执行的回调 静态全局变量
static dispatch_block_t mt_delayBlock;

@implementation MTDelayPerform

/// 开始延迟执行  每次调用就重新开始计时   用完记得 执行mt_cancelDelayPerform
/// @param perform  执行内容
/// @param delay 延迟时间
+ (void)mt_startDelayPerform:(void(^)(void))perform afterDelay:(NSTimeInterval)delay {
    if (mt_delayBlock != nil) {
        dispatch_block_cancel(mt_delayBlock);
        mt_delayBlock = nil;
    }
    if (mt_delayBlock == nil) {
        mt_delayBlock = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            perform();
        });
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(),mt_delayBlock);
}
///取消延迟执行
+ (void)mt_cancelDelayPerform {
    if (mt_delayBlock != nil) {
        dispatch_block_cancel(mt_delayBlock);
        mt_delayBlock = nil;
    }
}

@end
