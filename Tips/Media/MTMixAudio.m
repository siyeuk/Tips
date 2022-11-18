//
//  MTMixAudio.m
//  Tips
//
//  Created by 四叶帅 on 2022/11/4.
//

#import "MTMixAudio.h"

@implementation MTMixAudio

- (instancetype)init{
    if (self = [super init]) {
        AudioComponentDescription acdesc = {0};
        acdesc.componentType = kAudioUnitType_Output;
        acdesc.componentSubType = kAudioUnitSubType_RemoteIO;
        acdesc.componentManufacturer = kAudioUnitManufacturer_Apple;
        acdesc.componentFlags = 0;
        acdesc.componentFlagsMask = 0;
        
        AudioComponent component = AudioComponentFindNext(NULL, &acdesc);
        
        // 实例化audio unit对象
        AudioComponentInstance audioUnit;
        AudioComponentInstanceNew(component, &audioUnit);
        
        // 设置实例属性：可读写。  0 不可读写 ， 1 可读写
        // 开启audio unit 的输入总线1
        UInt32 enable = 1;
       OSStatus status = AudioUnitSetProperty(audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, enable, &enable, sizeof(enable));
        if (status != noErr) {
            
        }

//        // 设置实例的属性：音频参数，如：数据格式、声道数、采样位深、采样率等。
//        AudioStreamBasicDescription asbd = {0};
//        asbd.mFormatID = kAudioFormatLinearPCM; // 原始数据为 PCM，采用声道交错格式。
//        asbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked;
//        asbd.mChannelsPerFrame = (UInt32) self.configuration.numberOfChannels; // 每帧的声道数
//        asbd.mFramesPerPacket = 1; // 每个数据包帧数
//        asbd.mBitsPerChannel = 16; // 采样位深
//        asbd.mBytesPerFrame = asbd.mChannelsPerFrame * asbd.mBitsPerChannel / 8; // 每帧字节数 (byte = bit / 8)
//        asbd.mBytesPerPacket = asbd.mFramesPerPacket * asbd.mBytesPerFrame; // 每个包的字节数
//        asbd.mSampleRate = self.configuration.audioSampleRate; // 采样率
    }
    return self;
}

@end
