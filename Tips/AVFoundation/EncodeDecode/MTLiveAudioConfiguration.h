//
//  MTLiveAudioConfiguration.h
//  MT_Tips
//
//  Created by lss on 2022/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 音频码率 (默认96Kbps)
typedef NS_ENUM (NSUInteger, MTLiveAudioBitRate) {
    /// 32Kbps 音频码率
    MTLiveAudioBitRate_32Kbps = 32000,
    /// 64Kbps 音频码率
    MTLiveAudioBitRate_64Kbps = 64000,
    /// 96Kbps 音频码率
    MTLiveAudioBitRate_96Kbps = 96000,
    /// 128Kbps 音频码率
    MTLiveAudioBitRate_128Kbps = 128000,
    /// 默认音频码率，默认为 96Kbps
    MTLiveAudioBitRate_Default = MTLiveAudioBitRate_96Kbps
};
/// 音频采样率 (默认44.1KHz)
typedef NS_ENUM (NSUInteger, MTLiveAudioSampleRate){
    /// 16KHz 采样率
    MTLiveAudioSampleRate_16000Hz = 16000,
    /// 44.1KHz 采样率
    MTLiveAudioSampleRate_44100Hz = 44100,
    /// 48KHz 采样率
    MTLiveAudioSampleRate_48000Hz = 48000,
    /// 默认音频采样率，默认为 44.1KHz
    MTLiveAudioSampleRate_Default = MTLiveAudioSampleRate_44100Hz
};
///  Audio Live quality（音频质量）
typedef NS_ENUM (NSUInteger, MTLiveAudioQuality){
    /// 低音频质量 音频采样率: 16KHz 音频码率: 声道 1 : 32Kbps  2 : 64Kbps
    MTLiveAudioQuality_Low = 0,
    /// 中音频质量 音频采样率: 44.1KHz 音频码率: 96Kbps
    MTLiveAudioQuality_Medium = 1,
    /// 高音频质量 音频采样率: 44.1MHz 音频码率: 128Kbps
    MTLiveAudioQuality_High = 2,
    /// 超高音频质量 音频采样率: 48KHz, 音频码率: 128Kbps
    MTLiveAudioQuality_VeryHigh = 3,
    /// 默认音频质量 音频采样率: 44.1KHz, 音频码率: 96Kbps
    MTLiveAudioQuality_Default = MTLiveAudioQuality_Medium
};

@interface MTLiveAudioConfiguration : NSObject<NSCoding, NSCopying>

+ (instancetype)defaultConfiguration;
+ (instancetype)defaultConfigurationQuality:(MTLiveAudioQuality)audioQuality;

/// 声道数目(default 2)
@property (nonatomic, assign) NSUInteger numberOfChannels;
/// 采样率
@property (nonatomic, assign) MTLiveAudioSampleRate audioSampleRate;
/// 码率
@property (nonatomic, assign) MTLiveAudioBitRate audioBitrate;
/// flv编码音频头 44100 为0x12 0x10
@property (nonatomic, assign, readonly) char *asc;
/// 缓存区长度
@property (nonatomic, assign, readonly) NSUInteger bufferLength;

@end

NS_ASSUME_NONNULL_END
