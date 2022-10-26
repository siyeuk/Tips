//
//  MTAudioCapture.h
//  MT_Tips
//
//  Created by lss on 2022/10/13.
//

#import <Foundation/Foundation.h>
#import "MTLiveAudioConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

//extern NSString *_Nullable const LFAudioComponentFailedToCreateNotification;

@class MTAudioCapture;
@protocol MTAudioCaptureDelegate <NSObject>
@optional;
- (void)captureOutput:(nullable MTAudioCapture *)capture audioData:(nullable NSData*)audioData;

@end

@interface MTAudioCapture : NSObject

@property (nullable, nonatomic, weak) id<MTAudioCaptureDelegate> delegate;
/// 是否静音
@property (nonatomic, assign) BOOL muted;
/// 运行控制开始捕获或停止捕获
@property (nonatomic, assign) BOOL running;

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithAudioConfiguration:(nullable MTLiveAudioConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
