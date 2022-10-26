//
//  MTAudioEncoder.h
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface MTAudioConfig : NSObject
/// 码率
@property (nonatomic, assign) NSInteger bitrate;
/// 声道
@property (nonatomic, assign) NSInteger channel;
/// 采样率
@property (nonatomic, assign) NSInteger sampleRate;
/// 采样点量化
@property (nonatomic, assign) NSInteger sampleSize;

+ (instancetype)defaultConfig;

@end

@class MTAudioEncoder;
@protocol MTAudioEncoderDelegate <NSObject>
@optional

// encodeAudioSampleBuffer 返回数据
- (void)audioEncodeCallback:(NSData *)aacData;
- (void)audioEncodeCallback:(NSData *)aacData timeStamp:(uint64_t)timestamp;

// encodeAudioData 返回数据
// 返回加了ADTS数据
- (void)audioEncoder:(MTAudioEncoder *)encoder didOutputADTSData:(NSData *)data timeStamp:(uint64_t)timestamp;
// 返回编码后的原始数据
- (void)audioEncoder:(MTAudioEncoder *)encoder didOutputData:(NSData *)data timeStamp:(uint64_t)timestamp;
//// 返回CMSampleBufferRef
//- (void)audioEncoder:(MTAudioEncoder *)encoder didOutputSampleBufferRef:(CMSampleBufferRef)sampleBufferRef;

@end
/// AAC编码器 （编码和回调均在异步队列执行）
@interface MTAudioEncoder : NSObject

@property (nonatomic, strong, readonly) MTAudioConfig *config;
@property (nonatomic, weak) id<MTAudioEncoderDelegate> delegate;

- (instancetype)initWithConfig:(MTAudioConfig *)config;

- (void)encodeAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)encodeAudioData:(nullable NSData *)audioData pts:(int64_t)pts;

/// 从sampleBuffer直接获取PCM数据
+ (NSData *)convertAudioSamepleBufferToPcmData:(CMSampleBufferRef)sampleBuff;


@end

NS_ASSUME_NONNULL_END
