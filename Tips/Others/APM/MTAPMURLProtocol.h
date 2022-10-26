//
//  MTAPMURLProtocol.h
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///网络监控   TCP 建立连接时间 、DNS 时间、 SSL时间、首包时间、响应时间 、流量
@interface MTAPMURLProtocol : NSURLProtocol

///开始监听网络
+ (void)startMonitorNetwork;
///结束监听网络
+ (void)stopMonitorNetwork;

@end

NS_ASSUME_NONNULL_END
