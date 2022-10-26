//
//  MTAPMFluency.h
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MTAPMFluency;
@protocol MTAPMFluencyDelegate <NSObject>
///卡顿监控回调 当callStack不为nil时，表示发生卡顿并捕捉到卡顿时的调用栈；type == MTAPMFluencyTypeRunloop时，fps为0
- (void)APMFluency:(MTAPMFluency *)fluency didChangedFps:(float)fps callStackOfStuck:(nullable NSString *)callStack;
@end
/// 卡顿监测策略/类型
typedef NS_ENUM(NSInteger, MTAPMFluencyType) {
    /* 建议 Runloop，不消耗额外的CPU资源，可以获取卡顿时的调用堆栈 */
    MTAPMFluencyTypeRunloop  = 0,
    /*FPS 无法获取卡顿时的调用堆栈，消耗CPU资源，不利于CPU使用率的监控，但可以作为衡量卡顿程度的指数*/
    MTAPMFluencyTypeFps      = 1,
    /*所有策略*/
    MTAPMFluencyTypeAll      = 2
};

///流畅度监听 是否卡顿
@interface MTAPMFluency : NSObject

@property (nonatomic, weak) id<MTAPMFluencyDelegate> delegate;
///卡顿监测策略/类型  默认建议 MTAPMFluencyTypeRunloop
@property (nonatomic, assign) MTAPMFluencyType type;

+ (instancetype)sharedInstance;
///开始监听
- (void)startMonitorFluency;
///结束监听
- (void)stopMonitorFluency;

@end

NS_ASSUME_NONNULL_END
