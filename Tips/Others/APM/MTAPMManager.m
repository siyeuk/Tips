//
//  MTAPMManager.m
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import "MTAPMManager.h"
#import "MTTimer.h"

#import "MTAPMCpu.h"
#import "MTAPMMemoryDisk.h"
#import "MTAPMFluency.h"
#import "MTAPMThreadCount.h"
#import "MTAPMURLProtocol.h"

@interface MTAPMManager ()<MTAPMFluencyDelegate/*, MTCrashHandlerDelegate*/>
///任务名称
@property (nonatomic, copy) NSString *taskName;

@end

@implementation MTAPMManager

#pragma mark - Override
/// 重写allocWithZone方法，保证alloc或者init创建的实例不会产生新实例，因为该类覆盖了allocWithZone方法，所以只能通过其父类分配内存，即[super allocWithZone]
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self manager];
}
/// 重写copyWithZone方法，保证复制返回的是同一份实例
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [MTAPMManager manager];
}

#pragma mark - Public
+ (instancetype)manager {
    static MTAPMManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
        manager.type = MTAPMTypeAll;
    });
    return manager;
}
///开始监控
- (void)startMonitoring {
    if (_isMonitoring) return;
    _isMonitoring = YES;
    
    if ((self.type & MTAPMTypeCpu) == MTAPMTypeCpu || (self.type & MTAPMTypeMemory) == MTAPMTypeMemory || self.type == MTAPMTypeAll) {
        _taskName = [MTTimer execTask:self selector:@selector(monitoring) start:0.5 interval:1.0/60 repeats:YES async:YES];
    }
    
    if ((self.type & MTAPMTypeCpu) == MTAPMTypeCrash || self.type == MTAPMTypeAll) {
//        [MTCrashHandler defaultCrashHandler].delegate = self;
    }
    
    if ((self.type & MTAPMTypeFluency) == MTAPMTypeFluency || self.type == MTAPMTypeAll) {
        [MTAPMFluency sharedInstance].delegate = self;
        [[MTAPMFluency sharedInstance] startMonitorFluency];
    }
    
    if ((self.type & MTAPMTypeThreadCount) == MTAPMTypeThreadCount || self.type == MTAPMTypeAll) {
        [MTAPMThreadCount startMonitorThreadCount];
    }
    
    if ((self.type & MTAPMTypeNetwork) == MTAPMTypeNetwork || self.type == MTAPMTypeAll) {
        [MTAPMURLProtocol startMonitorNetwork];
    }
    
}
///结束监控
- (void)stopMonitoring {
    if (!_isMonitoring) return;
    _isMonitoring = NO;
    
    [MTTimer cancelTask:_taskName];
    [MTAPMFluency sharedInstance].delegate = nil;
    [[MTAPMFluency sharedInstance] stopMonitorFluency];
    [MTAPMThreadCount stopMonitorThreadCount];
    [MTAPMURLProtocol stopMonitorNetwork];
}

#pragma mark - Monitoring
///监控中
- (void)monitoring {
    
    if ((self.type & MTAPMTypeCpu) == MTAPMTypeCpu || self.type == MTAPMTypeAll) {
        float CPU = [MTAPMCpu getCpuUsage];
        NSLog(@"  CPU使用率：%.2f%%",CPU);
    }
    
    if ((self.type & MTAPMTypeMemory) == MTAPMTypeMemory || self.type == MTAPMTypeAll) {
        double useMemory = [MTAPMMemoryDisk getAppUsageMemory];
        double freeMemory = [MTAPMMemoryDisk getFreeMemory];
        double totalMemory = [MTAPMMemoryDisk getTotalMemory];
        NSLog(@"  Memory占用：%.1fM  空闲：%.1fM 总共：%.1fM",useMemory, freeMemory, totalMemory);
    }
    
}

#pragma mark - Fluency/卡顿监测
///卡顿监控回调 当callStack不为nil时，表示发生卡顿并捕捉到卡顿时的调用栈
- (void)APMFluency:(MTAPMFluency *)fluency didChangedFps:(float)fps callStackOfStuck:(nullable NSString *)callStack {
    NSLog(@"  卡顿监测  fps：%f \n %@", fps, callStack == nil ? @"流畅":[NSString stringWithFormat:@"卡住了 %@",callStack]);
}

#pragma mark - MTCrashHandlerDelegate
/////异常捕获回调 提供给外界实现自定义处理 ，日志上报等
//- (void)crashHandlerDidOutputCrashError:(MTCrashError *)crashError {
//   NSString *errorInfo = [NSString stringWithFormat:@" 错误描述：%@ \n 调用栈：%@" ,crashError.errorDesc, crashError.callStackSymbol];
//   NSLog(@"%@",errorInfo);
//}


@end
