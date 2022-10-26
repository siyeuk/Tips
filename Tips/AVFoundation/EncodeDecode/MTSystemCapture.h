//
//  MTSystemCapture.h
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

//// 捕获的数据类型
//typedef NS_ENUM(NSInteger, MTSystemCaptureType) {
//    MTSystemCaptureTypeVideo = 0,
//    MTSystemCaptureTypeAudio,
//    MTSystemCaptureTypeAll
//};
// 摄像头
typedef NS_ENUM(NSInteger, MTCaptureDeviceInput) {
    MTCaptureDeviceInputFront = 0,
    MTCaptureDeviceInputBack
};

@protocol MTSystemCaptureDelegate <NSObject>
@optional
- (void)captureSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

/// 捕获音视频
@interface MTSystemCapture : NSObject
// 预览层
@property (nonatomic, strong, nullable) UIView *preview;

@property (nonatomic, weak) id<MTSystemCaptureDelegate> delegate;
// 视频宽高
@property (nonatomic, assign, readonly) NSUInteger width;
@property (nonatomic, assign, readonly) NSUInteger height;

/// 摄像头是否正在运行
@property (nonatomic, assign, readonly) BOOL                    isRunning;
/// 摄像头方向 默认后置摄像头
@property (nonatomic, assign, readonly) AVCaptureDevicePosition devicePosition;
/// 闪光灯状态  默认是关闭的，即黑暗情况下拍照不打开闪光灯   （打开/关闭/自动）
@property (nonatomic, assign)           AVCaptureFlashMode      flashMode;
/// 当前焦距    默认最小值1  最大值6
@property (nonatomic, assign)           CGFloat                 videoZoomFactor;

//- (instancetype)initWithType:(MTSystemCaptureType)type;
- (instancetype)init;// UNAVAILABLE_ATTRIBUTE;


- (void)startCapture;
- (void)stopCapture;
// 切换摄像头
- (void)reverseCamera;

// 授权检测
+ (int)checkMicrophoneAuthor;
+ (int)checkCameraAuthor;


@end

NS_ASSUME_NONNULL_END
