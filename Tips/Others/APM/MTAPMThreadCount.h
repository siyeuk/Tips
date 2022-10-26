//
//  MTAPMThreadCount.h
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///监控线程数量
@interface MTAPMThreadCount : NSObject

///开始监听
+ (void)startMonitorThreadCount;
///结束监听
+ (void)stopMonitorThreadCount;

@end

NS_ASSUME_NONNULL_END
