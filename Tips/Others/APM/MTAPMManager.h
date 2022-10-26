//
//  MTAPMManager.h
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// app性能监控策略/类型
typedef NS_ENUM(NSInteger, MTAPMType) {
    /*无*/
    MTAPMTypeNone    = 0,
    /*CPU占用率*/
    MTAPMTypeCpu     = 1 << 0,
    /*内存使用情况*/
    MTAPMTypeMemory  = 1 << 1,
    /*流畅度、卡顿*/
    MTAPMTypeFluency = 1 << 2,
    /*iOS Crash防护模块*/
    MTAPMTypeCrash   = 1 << 3,
    /*线程数量监控，防止线程爆炸*/
    MTAPMTypeThreadCount   = 1 << 4,
    /*网络监控*/
    MTAPMTypeNetwork   = 1 << 5,
    /*VC启动耗时监测*/
    MTAPMTypeVCTime   = 1 << 6,
    /*所有策略*/
    MTAPMTypeAll     = 1 << 7
};


/// APM 管理者
@interface MTAPMManager : NSObject

///是否正在监控
@property (nonatomic, assign) BOOL isMonitoring;
///app性能监控策略/类型  默认MTAPMTypeAll
@property (nonatomic, assign) MTAPMType type;

+ (instancetype)manager;

///开始监控
- (void)startMonitoring;
///结束监控
- (void)stopMonitoring;

@end

NS_ASSUME_NONNULL_END
