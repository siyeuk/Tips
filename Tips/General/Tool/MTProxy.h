//
//  MTProxy.h
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///消息转发中介 主要解决NSTimer、CADisplayLink等循环引用问题
@interface MTProxy : NSProxy

///初始化方法
+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
