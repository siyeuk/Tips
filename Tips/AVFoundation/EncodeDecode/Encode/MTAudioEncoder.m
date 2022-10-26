//
//  MTAudioEncoder.m
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import "MTAudioEncoder.h"

@implementation MTAudioConfig

+ (instancetype)defaultConfig{
    MTAudioConfig *config = [[MTAudioConfig alloc] init];
    config.bitrate = 96000;
    config.channel = 1;
    config.sampleRate = 44100;
    config.sampleSize = 16;
    return config;
}

@end

@interface MTAudioEncoder (){
    char *leftBuf;
    char *aacBuf;
    NSInteger leftLength;
}



@property (nonatomic, strong) MTAudioConfig *config;

@property (nonatomic, assign) NSInteger bufferLength;

@property (nonatomic, strong) dispatch_queue_t encoderQueue;
@property (nonatomic, strong) dispatch_queue_t callbackQueue;

//对音频转换器对象 unsafe_unretained类似于weak，不过对象释放会变成野指针
@property (nonatomic, unsafe_unretained) AudioConverterRef audioConverter;

// PCM缓存区
@property (nonatomic) char *pcmBuffer;
// PCM缓存区大小
@property (nonatomic) size_t pcmBufferSize;

@end

@implementation MTAudioEncoder

uint32_t g_av_bases_time = 0;

- (instancetype)initWithConfig:(MTAudioConfig *)config{
    if (self = [super init]) {
        //音频编码队列
        _encoderQueue = dispatch_queue_create("aac hard encoder queue", DISPATCH_QUEUE_SERIAL);
        //音频回调队列
        _callbackQueue = dispatch_queue_create("aac hard encoder callback queue", DISPATCH_QUEUE_SERIAL);
        // 音频转换器
        _audioConverter = NULL;
        _pcmBuffer = NULL;
        _pcmBufferSize = 0;
        _config = config;
        if (_config == nil) {
            _config = [MTAudioConfig defaultConfig];
        }
    }
    return self;
}
#pragma mark - 编码CMSampleBufferRef -
// 音频编码
- (void)encodeAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    CFRetain(sampleBuffer);
    if (!_audioConverter) {
        [self setupEncoderWithSampleBuffer:sampleBuffer];
    }
    
    dispatch_async(_encoderQueue, ^{
        // 获取CMBlockBuffer, 这里面保存了PCM数据
        CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
        CFRetain(blockBuffer);
        
        // 获取BlockBuffer中音频数据大小以及音频数据地址
        OSStatus status = CMBlockBufferGetDataPointer(blockBuffer, 0, NULL, &self->_pcmBufferSize, &self->_pcmBuffer);
        NSError *error = nil;
        if (status != noErr) {
            error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
            NSLog(@"AAC编码 获取数据错误：%@",error);
            return;
        }
        
        // 开辟_pcmBuffsize大小的内存空间
        uint8_t *pcmBuffer = malloc(self->_pcmBufferSize);
        // 将_pcmBufferSize数据set到pcmBuffer中.
        memset(pcmBuffer, 0, self->_pcmBufferSize);
        
        // 输出buffer
        /*
         typedef struct AudioBufferList {
         UInt32 mNumberBuffers;
         AudioBuffer mBuffers[1];
         } AudioBufferList;
         
         struct AudioBuffer
         {
         UInt32              mNumberChannels;
         UInt32              mDataByteSize;
         void* __nullable    mData;
         };
         typedef struct AudioBuffer  AudioBuffer;
         */
        //将pcmBuffer数据填充到outAudioBufferList 对象中
        AudioBufferList outAudioBufferList = {0};
        outAudioBufferList.mNumberBuffers = 1;
        outAudioBufferList.mBuffers[0].mNumberChannels = (uint32_t)self->_config.channel;
        outAudioBufferList.mBuffers[0].mDataByteSize = (UInt32)self->_pcmBufferSize;
        outAudioBufferList.mBuffers[0].mData = pcmBuffer;
        
        //输出包大小为1
        UInt32 outputDataPacketSize = 1;
        
        //配置填充函数，获取输出数据
        //转换由输入回调函数提供的数据
        /*
         参数1: inAudioConverter 音频转换器
         参数2: inInputDataProc 回调函数.提供要转换的音频数据的回调函数。当转换器准备好接受新的输入数据时，会重复调用此回调.
         参数3: inInputDataProcUserData
         参数4: inInputDataProcUserData,self
         参数5: ioOutputDataPacketSize,输出缓冲区的大小
         参数6: outOutputData,需要转换的音频数据
         参数7: outPacketDescription,输出包信息
         */
        status = AudioConverterFillComplexBuffer(self->_audioConverter, aacEncodeInputDataProc, (__bridge void * _Nullable)(self), &outputDataPacketSize, &outAudioBufferList, NULL);
        
        CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
//        CMTime dts = CMSampleBufferGetDecodeTimeStamp(sampleBuffer);
        if (g_av_bases_time == 0) {
            g_av_bases_time = CMTimeGetSeconds(pts);
        }
        uint64_t ptsAfter = (uint64_t)((CMTimeGetSeconds(pts) - g_av_bases_time) * 1000);
        
        if (status == noErr) {
            // 获取数据
            NSData *rawAAC = [NSData dataWithBytes:outAudioBufferList.mBuffers[0].mData length:outAudioBufferList.mBuffers[0].mDataByteSize];
            // 释放pcmBuffer
            free(pcmBuffer);
            //添加ADTS头，想要获取裸流时，请忽略添加ADTS头，写入文件时，必须添加
            //            NSData *adtsHeader = [self adtsDataForPacketLength:rawAAC.length];
            //            NSMutableData *fullData = [NSMutableData dataWithCapacity:adtsHeader.length + rawAAC.length];;
            //            [fullData appendData:adtsHeader];
            //            [fullData appendData:rawAAC];
            // 将数据传递到回调队列中
            dispatch_async(self->_callbackQueue, ^{
                if ([self.delegate respondsToSelector:@selector(audioEncodeCallback:)]) {
                    [self.delegate audioEncodeCallback:rawAAC timeStamp:ptsAfter];
                }
            });
        }else{
            error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
        }
        CFRelease(blockBuffer);
        CFRelease(sampleBuffer);
        if (error) {
            NSLog(@"AAC 编码失败");
        }
    });
}
// 配置音频编码参数
- (void)setupEncoderWithSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    // 获取输入参数
    AudioStreamBasicDescription inputAudioDes = *CMAudioFormatDescriptionGetStreamBasicDescription(CMSampleBufferGetFormatDescription(sampleBuffer));
    
    // 设置输出参数
    AudioStreamBasicDescription outputAudioDes = {0};
    outputAudioDes.mSampleRate = inputAudioDes.mSampleRate;// (Float64)_config.sampleRate;       //采样率
    outputAudioDes.mFormatID = kAudioFormatMPEG4AAC;                //输出格式
    outputAudioDes.mFormatFlags = kMPEG4Object_AAC_Main;            // 如果设为0 代表无损编码
    outputAudioDes.mBytesPerPacket = 0;                             //自己确定每个packet 大小
    outputAudioDes.mFramesPerPacket = 1024;                         //每一个packet帧数 AAC-1024；
    outputAudioDes.mBytesPerFrame = 0;                              //每一帧大小 每帧的大小。压缩格式设置为 0。
    outputAudioDes.mChannelsPerFrame = inputAudioDes.mChannelsPerFrame;// (uint32_t)_config.channel; //输出声道数
    outputAudioDes.mBitsPerChannel = 0;                             //数据帧中每个通道的采样位数。 压缩格式设置为 0。
    outputAudioDes.mReserved =  0;                                  //对其方式 0(8字节对齐)
    
    // 填充输出相关信息
    UInt32 outDesSize = sizeof(outputAudioDes);
    OSStatus status = AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &outDesSize, &outputAudioDes);
    if (status != noErr) {
        NSLog(@"填充输出相关信息失败");
    }
    
    
    //获取编码器的描述信息(只能传入software)
    AudioClassDescription *audioClassDesc = [self getAudioCalssDescriptionWithType:outputAudioDes.mFormatID fromManufacture:kAppleHardwareAudioCodecManufacturer];
    
//    // 获取编码器的描述信息
//    OSType subtype = kAudioFormatMPEG4AAC;
//    AudioClassDescription requestedCodecs[2] = {
//        {
//            kAudioEncoderComponentType,
//            subtype,
//            kAppleSoftwareAudioCodecManufacturer
//        },
//        {
//            kAudioEncoderComponentType,
//            subtype,
//            kAppleHardwareAudioCodecManufacturer
//        }
//    };
    status = AudioConverterNewSpecific(&inputAudioDes, &outputAudioDes, 1, audioClassDesc, &_audioConverter);
    if (status != noErr) {
        NSLog(@"获取AAC编码器失败 ，status = %@",[NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil]);
    }
    
    // 设置编解码质量
    /*
     kAudioConverterQuality_Max                              = 0x7F,
     kAudioConverterQuality_High                             = 0x60,
     kAudioConverterQuality_Medium                           = 0x40,
     kAudioConverterQuality_Low                              = 0x20,
     kAudioConverterQuality_Min                              = 0
     */
    UInt32 temp = kAudioConverterQuality_High;
    //编解码器的呈现质量
    status = AudioConverterSetProperty(_audioConverter, kAudioConverterCodecQuality, sizeof(temp), &temp);
    if (status != noErr) {
        NSLog(@"设置编解码器的呈现质量失败 ，status = %d",(int)status);
    }
    
    //设置比特率
    uint32_t audioBitrate = (uint32_t)self.config.bitrate;
    uint32_t audioBitrateSize = sizeof(audioBitrate);
    status = AudioConverterSetProperty(_audioConverter, kAudioConverterEncodeBitRate, audioBitrateSize, &audioBitrate);
    if (status != noErr) {
        NSLog(@"设置编解码器的比特率失败");
    }
}

//编码器回调函数
static OSStatus aacEncodeInputDataProc(AudioConverterRef inAudioConverter, UInt32 *ioNumberDataPackets, AudioBufferList *ioData, AudioStreamPacketDescription **outDataPacketDescription, void *inUserData) {
    
    //获取self
    MTAudioEncoder *aacEncoder = (__bridge MTAudioEncoder *)(inUserData);
//    UInt32 requestedPackets = *ioNumberDataPackets;
//    NSLog(@"Number of packets requested: %d", (unsigned int)requestedPackets);
//    size_t copiedSamples = [aacEncoder copyPCMSamplesIntoBuffer:ioData];
//    if (copiedSamples < requestedPackets) {
//        NSLog(@"PCM buffer isn't full enough!");
//        *ioNumberDataPackets = 0;
//        return -1;
//    }
//    *ioNumberDataPackets = 1;
//    //NSLog(@"Copied %zu samples into ioData", copiedSamples);
//    return noErr;
//
//    //判断pcmBuffsize大小
//    if (!aacEncoder.pcmBufferSize) {
//        *ioNumberDataPackets = 0;
//        return  - 1;
//    }
    
    //填充
    ioData->mBuffers[0].mData = aacEncoder.pcmBuffer;
    ioData->mBuffers[0].mDataByteSize = (uint32_t)aacEncoder.pcmBufferSize;
    ioData->mBuffers[0].mNumberChannels = (uint32_t)aacEncoder.config.channel;
    
    //填充完毕,则清空数据
    aacEncoder.pcmBufferSize = 0;
    *ioNumberDataPackets = 1;
    return noErr;
}

/**
 *  填充PCM到缓冲区
 */
- (size_t) copyPCMSamplesIntoBuffer:(AudioBufferList*)ioData {
    size_t originalBufferSize = _pcmBufferSize;
    if (!originalBufferSize) {
        return 0;
    }
    ioData->mBuffers[0].mData = _pcmBuffer;
    ioData->mBuffers[0].mDataByteSize = (int)_pcmBufferSize;
    _pcmBuffer = NULL;
    _pcmBufferSize = 0;
    return originalBufferSize;
}

/// 获取编码器
/// - Parameters:
///   - type: <#type description#>
///   - manufacture: <#manufacture description#>
- (AudioClassDescription *)getAudioCalssDescriptionWithType:(AudioFormatID)type fromManufacture:(uint32_t)manufacture {
    
    static AudioClassDescription desc;
    UInt32 encoderSpecific = type;
    
    //获取满足AAC编码器的总大小
    UInt32 size;
    
    /**
     参数1：编码器类型
     参数2：类型描述大小
     参数3：类型描述
     参数4：大小
     */
    OSStatus status = AudioFormatGetPropertyInfo(kAudioFormatProperty_Encoders, sizeof(encoderSpecific), &encoderSpecific, &size);
    if (status != noErr) {
        NSLog(@"Error！：硬编码AAC get info 失败, status= %d", (int)status);
        return nil;
    }
    //计算aac编码器的个数
    unsigned int count = size / sizeof(AudioClassDescription);
    //创建一个包含count个编码器的数组
    AudioClassDescription description[count];
    //将满足aac编码的编码器的信息写入数组
    status = AudioFormatGetProperty(kAudioFormatProperty_Encoders, sizeof(encoderSpecific), &encoderSpecific, &size, &description);
    if (status != noErr) {
        NSLog(@"Error！：硬编码AAC get propery 失败, status= %d", (int)status);
        return nil;
    }
    for (unsigned int i = 0; i < count; i++) {
        if (type == description[i].mSubType && manufacture == description[i].mManufacturer) {
            desc = description[i];
            return &desc;
        }
    }
    return nil;
}

#pragma mark - 编码NSData -
- (void)encodeAudioData:(nullable NSData *)audioData pts:(int64_t)pts{
    if (!_audioConverter) {
        [self setupAudioConverter];
    }
    if (leftLength + audioData.length >= self.bufferLength) {
        // 编码
        NSInteger totalSize = leftLength + audioData.length;
        NSInteger encodeCount = totalSize/self.bufferLength;
        char *totalBuf = malloc(totalSize);
        char *p = totalBuf;
        
        memset(totalBuf, (int)totalSize, 0);
        memcpy(totalBuf, leftBuf, leftLength);
        memcpy(totalBuf + leftLength, audioData.bytes, audioData.length);
        for (NSInteger index = 0; index < encodeCount; index++) {
            [self encodeBuffer:p pts:pts];
            p += self.config.channel*1024*2;
        }
        leftLength = totalSize%self.bufferLength;
        memset(leftBuf, 0, self.bufferLength);
        memcpy(leftBuf, totalBuf + (totalSize - leftLength), leftLength);
        free(totalBuf);
    }else{
        // 累计数据
        memcpy(leftBuf+leftLength, audioData.bytes, audioData.length);
        leftLength = leftLength + audioData.length;
    }
}
- (void)encodeBuffer:(char *)buf pts:(uint64_t)pts{
    AudioBuffer inBuffer;
    inBuffer.mNumberChannels = 1;
    inBuffer.mData = buf;
    inBuffer.mDataByteSize = (UInt32)self.bufferLength;
    
    AudioBufferList buffers;
    buffers.mNumberBuffers = 1;
    buffers.mBuffers[0] = inBuffer;
    
    // 初始化一个输出缓冲列表
    AudioBufferList outBufferList;
    outBufferList.mNumberBuffers = 1;
    outBufferList.mBuffers[0].mNumberChannels = inBuffer.mNumberChannels;
    outBufferList.mBuffers[0].mDataByteSize = inBuffer.mDataByteSize;   // 设置缓冲区大小
    outBufferList.mBuffers[0].mData = aacBuf;           // 设置AAC缓冲区
    UInt32 outputDataPacketSize = 1;
    if (AudioConverterFillComplexBuffer(self.audioConverter, inputDataPro, &buffers, &outputDataPacketSize, &outBufferList, NULL) != noErr) {
        NSLog(@"音频编码报错了报错了");
        return;
    }
    NSData *audioData = [NSData dataWithBytes:aacBuf length:outBufferList.mBuffers[0].mDataByteSize];
    NSData *adts = [self adtsData:self.config.channel rawDataLength:audioData.length];
    if ([self.delegate respondsToSelector:@selector(audioEncoder:didOutputData:timeStamp:)]) {
        [self.delegate audioEncoder:self didOutputData:audioData timeStamp:pts];
    }
    if ([self.delegate respondsToSelector:@selector(audioEncoder:didOutputADTSData:timeStamp:)]) {
        NSMutableData *data = [NSMutableData dataWithData:adts];
        [data appendData:audioData];
        [self.delegate audioEncoder:self didOutputADTSData:data timeStamp:pts];
    }
//    if ([self.delegate respondsToSelector:@selector(audioEncoder:didOutputSampleBufferRef:)]) {
//        [self.delegate audioEncoder:self didOutputSampleBufferRef:[self sampleBufferFromAudioBufferList:buffers inTimeStamp:pts inNumberFrames:inNumberFrames description:self.outputFormat]];
//    }
}
- (void)setupAudioConverter{
    // 输入音频格式
    AudioStreamBasicDescription inputFormat = {0};
    inputFormat.mSampleRate = self.config.sampleRate;
    inputFormat.mFormatID = kAudioFormatLinearPCM;
    inputFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked;
    inputFormat.mChannelsPerFrame = (UInt32)self.config.channel;
    inputFormat.mFramesPerPacket = 1;
    inputFormat.mBitsPerChannel = 16;
    inputFormat.mBytesPerFrame = inputFormat.mBitsPerChannel / 8 * inputFormat.mChannelsPerFrame;
    inputFormat.mBytesPerPacket = inputFormat.mBytesPerFrame * inputFormat.mFramesPerPacket;
    
    AudioStreamBasicDescription outputFormat; // 这里开始是输出音频格式
    memset(&outputFormat, 0, sizeof(outputFormat));
    outputFormat.mSampleRate = inputFormat.mSampleRate;       // 采样率保持一致
    outputFormat.mFormatID = kAudioFormatMPEG4AAC;            // AAC编码
    outputFormat.mChannelsPerFrame = inputFormat.mChannelsPerFrame;
    outputFormat.mFormatFlags = kMPEG4Object_AAC_LC;              // 如果设为0 代表无损编码
    outputFormat.mBytesPerPacket = 0;                             //自己确定每个packet 大小
    outputFormat.mFramesPerPacket = 1024;                         //每一个packet帧数 AAC-1024；
    outputFormat.mBytesPerFrame = 0;                              //每一帧大小
    outputFormat.mBitsPerChannel = 0;                             //数据帧中每个通道的采样位数。
    outputFormat.mReserved =  0;                                  //对其方式 0(8字节对齐)
    
    OSType subtype = kAudioFormatMPEG4AAC;
    AudioClassDescription requestedCodecs[2] = {
        {
            kAudioEncoderComponentType,
            subtype,
            kAppleSoftwareAudioCodecManufacturer
        },
        {
            kAudioEncoderComponentType,
            subtype,
            kAppleHardwareAudioCodecManufacturer
        }
    };
    OSStatus result = AudioConverterNewSpecific(&inputFormat, &outputFormat, 2, requestedCodecs, &_audioConverter);;
    UInt32 outputBitrate = (UInt32)_config.bitrate;
    UInt32 propSize = sizeof(outputBitrate);
    
    if(result == noErr) {
        result = AudioConverterSetProperty(_audioConverter, kAudioConverterEncodeBitRate, propSize, &outputBitrate);
    }
    self.bufferLength = 1024*2*self.config.channel;
    if (!leftBuf) {
        leftBuf = malloc(self.bufferLength);
    }
    if (!aacBuf) {
        aacBuf = malloc(self.bufferLength);
    }
}
OSStatus inputDataPro(AudioConverterRef inConverter, UInt32 *ioNumberDataPackets, AudioBufferList *ioData, AudioStreamPacketDescription * *outDataPacketDescription, void *inUserData) {
    //AudioConverterFillComplexBuffer 编码过程中，会要求这个函数来填充输入数据，也就是原始PCM数据
    AudioBufferList bufferList = *(AudioBufferList *)inUserData;
    ioData->mBuffers[0].mNumberChannels = 1;
    ioData->mBuffers[0].mData = bufferList.mBuffers[0].mData;
    ioData->mBuffers[0].mDataByteSize = bufferList.mBuffers[0].mDataByteSize;
    return noErr;
}


/**
 *  Add ADTS header at the beginning of each and every AAC packet.
 *  This is needed as MediaCodec encoder generates a packet of raw
 *  AAC data.
 *
 *  AAC ADtS头
 *  Note the packetLen must count in the ADTS header itself.
 *  See: http://wiki.multimedia.cx/index.php?title=ADTS
 *  Also: http://wiki.multimedia.cx/index.php?title=MPEG-4_Audio#Channel_Configurations
 **/
- (NSData*)adtsDataForPacketLength:(NSUInteger)packetLength {
    int adtsLength = 7;
    char *packet = malloc(sizeof(char) * adtsLength);
    // Variables Recycled by addADTStoPacket
    int profile = 2;  //AAC LC
    //39=MediaCodecInfo.CodecProfileLevel.AACObjectELD;
    int freqIdx = 4;  //3： 48000 Hz、4：44.1KHz、8: 16000 Hz、11: 8000 Hz
    int chanCfg = 1;  //MPEG-4 Audio Channel Configuration. 1 Channel front-center
    NSUInteger fullLength = adtsLength + packetLength;
    // fill in ADTS data
    packet[0] = (char)0xFF;    // 11111111      = syncword
    packet[1] = (char)0xF9;    // 1111 1 00 1  = syncword MPEG-2 Layer CRC
    packet[2] = (char)(((profile-1)<<6) + (freqIdx<<2) +(chanCfg>>2));
    packet[3] = (char)(((chanCfg&3)<<6) + (fullLength>>11));
    packet[4] = (char)((fullLength&0x7FF) >> 3);
    packet[5] = (char)(((fullLength&7)<<5) + 0x1F);
    packet[6] = (char)0xFC;
    NSData *data = [NSData dataWithBytesNoCopy:packet length:adtsLength freeWhenDone:YES];
    return data;
}


/**
 .AAC文件处理流程
 (1)　判断文件格式，确定为ADIF或ADTS
 (2)　若为ADIF，解ADIF头信息，跳至第6步。
 (3)　若为ADTS，寻找同步头。
 (4)解ADTS帧头信息。
 (5)若有错误检测，进行错误检测。
 (6)解块信息。
 (7)解元素信息。
 */



// 封装成CMSampleBufferRef
- (CMSampleBufferRef)sampleBufferFromAudioBufferList:(AudioBufferList)buffers inTimeStamp:(uint64_t)inTimeStamp inNumberFrames:(UInt32)inNumberFrames description:(AudioStreamBasicDescription)description {
    CMSampleBufferRef sampleBuffer = NULL; // 待生成的 CMSampleBuffer 实例的引用。
    
    // 1、创建音频流的格式描述信息。
    CMFormatDescriptionRef format = NULL;
    OSStatus status = CMAudioFormatDescriptionCreate(kCFAllocatorDefault, &description, 0, NULL, 0, NULL, NULL, &format);
    if (status != noErr) {
        CFRelease(format);
        return nil;
    }
    
    // PTS。
    CMTime presentationTime = CMTimeMake(inTimeStamp, 1000000000.0f);
    // 对于音频，PTS 和 DTS 是一样的。
    CMSampleTimingInfo timing = {CMTimeMake(1, description.mSampleRate), presentationTime, presentationTime};
    
    // 3、创建 CMSampleBuffer 实例。
    status = CMSampleBufferCreate(kCFAllocatorDefault, NULL, false, NULL, NULL, format, (CMItemCount) inNumberFrames, 1, &timing, 0, NULL, &sampleBuffer);
    if (status != noErr) {
        CFRelease(format);
        return nil;
    }
    
    // 4、创建 CMBlockBuffer 实例。其中数据拷贝自 AudioBufferList，并将 CMBlockBuffer 实例关联到 CMSampleBuffer 实例。
    status = CMSampleBufferSetDataBufferFromAudioBufferList(sampleBuffer, kCFAllocatorDefault, kCFAllocatorDefault, 0, &buffers);
    if (status != noErr) {
        CFRelease(format);
        return nil;
    }
    
    CFRelease(format);
    return sampleBuffer;
}
// 添加ADTS头
- (NSData *)adtsData:(NSInteger)channel rawDataLength:(NSInteger)rawDataLength {
    int adtsLength = 7;
    char *packet = malloc(sizeof(char) * adtsLength);
    // Variables Recycled by addADTStoPacket
    int profile = 2;  //AAC LC
    //39=MediaCodecInfo.CodecProfileLevel.AACObjectELD;
    NSInteger freqIdx = [self sampleRateIndex:self.config.sampleRate];  //44.1KHz
    int chanCfg = (int)channel;  //MPEG-4 Audio Channel Configuration. 1 Channel front-center
    NSUInteger fullLength = adtsLength + rawDataLength;
    // fill in ADTS data
    packet[0] = (char)0xFF;     // 11111111     = syncword
    packet[1] = (char)0xF9;     // 1111 1 00 1  = syncword MPEG-2 Layer CRC
    packet[2] = (char)(((profile-1)<<6) + (freqIdx<<2) +(chanCfg>>2));
    packet[3] = (char)(((chanCfg&3)<<6) + (fullLength>>11));
    packet[4] = (char)((fullLength&0x7FF) >> 3);
    packet[5] = (char)(((fullLength&7)<<5) + 0x1F);
    packet[6] = (char)0xFC;
    NSData *data = [NSData dataWithBytesNoCopy:packet length:adtsLength freeWhenDone:YES];
    return data;
}
- (NSInteger)sampleRateIndex:(NSInteger)frequencyInHz {
    NSInteger sampleRateIndex = 0;
    switch (frequencyInHz) {
        case 96000:
            sampleRateIndex = 0;
            break;
        case 88200:
            sampleRateIndex = 1;
            break;
        case 64000:
            sampleRateIndex = 2;
            break;
        case 48000:
            sampleRateIndex = 3;
            break;
        case 44100:
            sampleRateIndex = 4;
            break;
        case 32000:
            sampleRateIndex = 5;
            break;
        case 24000:
            sampleRateIndex = 6;
            break;
        case 22050:
            sampleRateIndex = 7;
            break;
        case 16000:
            sampleRateIndex = 8;
            break;
        case 12000:
            sampleRateIndex = 9;
            break;
        case 11025:
            sampleRateIndex = 10;
            break;
        case 8000:
            sampleRateIndex = 11;
            break;
        case 7350:
            sampleRateIndex = 12;
            break;
        default:
            sampleRateIndex = 15;
    }
    return sampleRateIndex;
}

- (void)dealloc{
    if (_audioConverter) {
        AudioConverterDispose(_audioConverter);
        _audioConverter = NULL;
    }
}
/// 从sampleBuffer直接获取PCM数据
- (NSData *)convertAudioSamepleBufferToPcmData:(CMSampleBufferRef)sampleBuffer{
    //获取pcm数据大小
    size_t size = CMSampleBufferGetTotalSampleSize(sampleBuffer);
    //分配空间
    int8_t *audio_data = (int8_t *)malloc(size);
    memset(audio_data, 0, size);
    
    //获取CMBlockBuffer, 这里面保存了PCM数据
    CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    //将数据copy到我们分配的空间中
    CMBlockBufferCopyDataBytes(blockBuffer, 0, size, audio_data);
    //PCM data->NSData
    NSData *data = [NSData dataWithBytes:audio_data length:size];
    free(audio_data);
    return data;
}
@end
