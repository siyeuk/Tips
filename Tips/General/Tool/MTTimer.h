//
//  MTTimer.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///计时器  比NSTimer和CADisplayLink计时准确
@interface MTTimer : NSObject

/// 执行任务  返回任务名称
/// - Parameters:
///   - task: 任务Block
///   - start: 开始时间
///   - interval: 时间间隔
///   - repeats: 是否重复
///   - async: 是否异步
+ (NSString *)execTask:(void(^)(void))task
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async;

/// 执行任务 返回任务名称
/// - Parameters:
///   - target: 选择器执行者
///   - selector: 选择器
///   - start: 开始时间
///   - interval: 时间间隔
///   - repeats: 是否重复
///   - async: 是否异步
+ (NSString *)execTask:(id)target
              selector:(SEL)selector
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async;

/// 取消任务
/// - Parameter taskName: 任务名称
+ (void)cancelTask:(NSString *)taskName;

@end

NS_ASSUME_NONNULL_END
