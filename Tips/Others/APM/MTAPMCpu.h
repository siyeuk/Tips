//
//  MTAPMCpu.h
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// CPU占有率监听
@interface MTAPMCpu : NSObject

///返回GPU使用情况 占有率
+ (double)getCpuUsage;

/// 返回CPU使用情况 占有率
/// - Parameters:
///   - max: 设定CPU使用率最大边界值
///   - callback: 超出边界后的回调方法  返回此时的堆栈信息
+ (double)getCpuUsageWithMax:(float)max outOfBoundsCallback:(void(^)(NSString *string))callback;

@end

NS_ASSUME_NONNULL_END
