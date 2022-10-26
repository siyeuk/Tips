//
//  MTAVWriteInput.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/// 写入的音视频文件类型
typedef NS_ENUM(NSUInteger, MTAVWriterFileType) {
    /// 音视频  默认
    MTAVWriterFileTypeVideo = 0,
    /// 无声视频
    MTAVWriterFileTypeSilentVideo,
    /// 音频
    MTAVWriterFileTypeAudio
};
@class MTAVWriteInput;
// 音视频写入完成
@protocol MTAVWriteInputDelegate <NSObject>
@optional

/// 写入音视频完成，返回文件地址
/// - Parameters:
///   - outputFileURL: 文件地址
///   - error: 错误信息
- (void)writerInput:(MTAVWriteInput *_Nonnull)writerInput didFinishRecordingToOutputFileAtURL:(NSURL *_Nullable)outputFileURL error:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_BEGIN

//写入音视频样本 生成文件
@interface MTAVWriteInput : NSObject

// 视频宽高 默认设备宽高 ，以home键朝下为准
@property (nonatomic, assign) CGSize videoSize;
// 写入代理
@property (nonatomic, weak) id<MTAVWriteInputDelegate> delegate;

// 开始写入 设置写入的输出文件地址和格式、设备方向
- (void)startWritingToOutputFileAtPath:(NSString *)path fileType:(MTAVWriterFileType)fileType deviceOrientation:(UIDeviceOrientation)deviceOrientation;
/// 实时写入视频样本   如果filterImage == nil，就表示不需要加滤镜
- (void)writingVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection filterImage:(CIImage * _Nullable)filterImage;
// 实时写入音频样本
- (void)writingAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;
// 完成写入
- (void)finishWriting;

@end

NS_ASSUME_NONNULL_END
