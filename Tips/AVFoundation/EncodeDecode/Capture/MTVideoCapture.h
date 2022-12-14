//
//  MTVideoCapture.h
//  MT_Tips
//
//  Created by lss on 2022/10/13.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MTLiveVideoConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@class MTVideoCapture;
@protocol MTVideoCaptureDelegate <NSObject>
@optional
- (void)captureOutput:(nullable MTVideoCapture *)capture pixelBuffer:(nullable CMSampleBufferRef)pixelBuffer;

- (void)captureOutput:(nullable MTVideoCapture *)capture newbuffer:(uint8_t *)newbuffer dataSize:(size_t)dataSize;

@end

@interface MTVideoCapture : NSObject

/// 运行控制开始捕获或停止捕获
@property (nonatomic, assign) BOOL running;

@property (nonatomic, nullable, weak) id<MTVideoCaptureDelegate> delegate;
/// 展示的View
@property (nonatomic, strong, nullable) UIView *preview;
/// 摄像头方向 默认前置摄像头
@property (nonatomic, assign, readonly) AVCaptureDevicePosition devicePosition;

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithVideoConfiguration:(nullable MTLiveVideoConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

// 切换摄像头
- (void)reverseCamera;
/*
 设置分辨率
 目前支持最大的是3840*2160,如果不要求相机帧率大于30帧,此方法可以适用于你
 */
- (void)setCameraResolutionByPreset:(AVCaptureSessionPreset)sessionPreset;

// 调整帧率 仅适用于frame rate <=30
- (void)changeFrameRate:(int)frameRate;
// 设置高帧率 fps > 30

// 打开闪光灯
- (void)openFlash;
// 关闭闪光灯
- (void)closeFlash;
// 调节焦距
- (void)changeFocus:(CGFloat)focus;
// 数码变焦
- (void)changeZoom:(CGFloat)zoom;
// 调节ISO,光感度
- (void)changeISO:(CGFloat)iso;
// 点击屏幕自动对焦
- (void)tap:(CGPoint)point;
// 开启慢动作拍摄
- (void)openSlow;
// 关闭慢动作拍摄
- (void)closeSlow;
// 打开防抖
- (void)openAntiShake;
// 关闭防抖
- (void)closeAntiShake;

@end

NS_ASSUME_NONNULL_END
