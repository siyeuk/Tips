//
//  MTAudioCapture.m
//  MT_Tips
//
//  Created by lss on 2022/10/13.
//

#import "MTAudioCapture.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <mach/mach_time.h>

@interface MTAudioCapture ()

@property (nonatomic, assign) AudioComponentInstance componetInstance;
@property (nonatomic, assign) AudioComponent component;
@property (nonatomic, strong) dispatch_queue_t taskQueue;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, strong, nullable) MTLiveAudioConfiguration *configuration;

@end

@implementation MTAudioCapture

- (instancetype)init{
    return nil;
}
+ (instancetype)new{
    return nil;
}
- (instancetype)initWithAudioConfiguration:(MTLiveAudioConfiguration *)configuration{
    if (self = [super init]) {
        self.configuration = configuration;
        self.taskQueue = dispatch_queue_create("com.audioCapture.mt", DISPATCH_QUEUE_SERIAL);
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(handleRouteChange:)
                                                     name: AVAudioSessionRouteChangeNotification
                                                   object: session];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(handleInterruption:)
                                                     name: AVAudioSessionInterruptionNotification
                                                   object: session];
        
        // 设置采集组件描述
        AudioComponentDescription acd = {
            .componentType = kAudioUnitType_Output,
            //        .componentSubType = kAudioUnitSubType_VoiceProcessingIO,// 回声消除模式
            .componentSubType = kAudioUnitSubType_RemoteIO,
            .componentManufacturer = kAudioUnitManufacturer_Apple,
            .componentFlags = 0,
            .componentFlagsMask = 0,
        };
        // 查找符合指定描述的音频组件
        self.component = AudioComponentFindNext(NULL, &acd);
        
        OSStatus status = noErr;
        // 创建音频组件实例
        status = AudioComponentInstanceNew(self.component, &_componetInstance);
        if (status != noErr) {
            [self handleAudioComponentCreationFailure];
        }
        
        // 设置实例属性：可读写。  0 不可读写 ， 1 可读写
        UInt32 flagOne = 1;
        status = AudioUnitSetProperty(_componetInstance, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, flagOne, &flagOne, sizeof(flagOne));
        if (status != noErr) {
            [self handleAudioComponentCreationFailure];
        }
        
        // 设置实例的属性：音频参数，如：数据格式、声道数、采样位深、采样率等。
        AudioStreamBasicDescription asbd = {0};
        asbd.mFormatID = kAudioFormatLinearPCM; // 原始数据为 PCM，采用声道交错格式。
        asbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked;
        asbd.mChannelsPerFrame = (UInt32) self.configuration.numberOfChannels; // 每帧的声道数
        asbd.mFramesPerPacket = 1; // 每个数据包帧数
        asbd.mBitsPerChannel = 16; // 采样位深
        asbd.mBytesPerFrame = asbd.mChannelsPerFrame * asbd.mBitsPerChannel / 8; // 每帧字节数 (byte = bit / 8)
        asbd.mBytesPerPacket = asbd.mFramesPerPacket * asbd.mBytesPerFrame; // 每个包的字节数
        asbd.mSampleRate = self.configuration.audioSampleRate; // 采样率
        
        // 设置实例属性： 数据回调函数
        AURenderCallbackStruct cb;
        cb.inputProcRefCon = (__bridge  void *)self;
        cb.inputProc = audioBufferCallBack;
        
        status = AudioUnitSetProperty(_componetInstance, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, &asbd, sizeof(asbd));
        status = AudioUnitSetProperty(_componetInstance, kAudioOutputUnitProperty_SetInputCallback, kAudioUnitScope_Global, 1, &cb, sizeof(cb));
        
        
        // 初始化实例
        status = AudioUnitInitialize(_componetInstance);
        if (status != noErr) {
            [self handleAudioComponentCreationFailure];
        }
        
        
        [session setPreferredSampleRate:configuration.audioSampleRate error:nil];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers error:nil];
        [session setActive:YES withOptions:kAudioSessionSetActiveFlag_NotifyOthersOnDeactivation error:nil];
        [session setActive:YES error:nil];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.componetInstance) {
        self.isRunning = NO;
        AudioOutputUnitStop(_componetInstance);
        AudioComponentInstanceDispose(_componetInstance);
        self.component = nil;
        self.componetInstance = nil;
    }
    NSLog(@"声音采集 dealloc");
}
- (void)handleAudioComponentCreationFailure {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"报错了");
    });
}

- (void)setRunning:(BOOL)running {
    if (_running == running) return;
    _running = running;
    if (_running) {
        dispatch_async(self.taskQueue, ^{
            self.isRunning = YES;
            NSLog(@"startRunning");
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers error:nil];
            AudioOutputUnitStart(self.componetInstance);
        });
    } else {
        dispatch_sync(self.taskQueue, ^{
            self.isRunning = NO;
            NSLog(@"stopRunning");
            AudioOutputUnitStop(self.componetInstance);
        });
    }
}


static OSStatus audioBufferCallBack(void *inRefCon,
                                    AudioUnitRenderActionFlags *ioActionFlags,
                                    const AudioTimeStamp *inTimeStamp,
                                    UInt32 inBusNumber,
                                    UInt32 inNumberFrames,
                                    AudioBufferList *ioData){
    @autoreleasepool {
        MTAudioCapture *capture = (__bridge  MTAudioCapture *)inRefCon;
        if (!capture) {
            return -1;
        }
        // 创建 AudioBufferList 空间，用来接收采集回来的数据。
        AudioBuffer buffer;
        buffer.mData = NULL;
        buffer.mDataByteSize = 0;
        // 采集的时候设置了数据格式是 kAudioFormatLinearPCM，即声道交错格式，所以即使是双声道这里也设置 mNumberChannels 为 1。
        // 对于双声道的数据，会按照采样位深 16 bit 每组，一组接一组地进行两个声道数据的交错拼装。
        buffer.mNumberChannels = 1;
        
        AudioBufferList buffers;
        buffers.mNumberBuffers = 1;
        buffers.mBuffers[0] = buffer;
        // 获取音频 PCM 数据，存储到 AudioBufferList 中。
        // 这里有几个问题要说明清楚：
        // 1）每次回调会过来多少数据？
        // 按照上面采集音频参数的设置：PCM 为声道交错格式、每帧的声道数为 2、采样位深为 16 bit。这样每帧的字节数是 4 字节（左右声道各 2 字节）。
        // 返回数据的帧数是 inNumberFrames。这样一次回调回来的数据字节数是多少就是：mBytesPerFrame(4) * inNumberFrames。
        // 2）这个数据回调的频率跟音频采样率有关系吗？
        // 这个数据回调的频率与音频采样率（上面设置的 mSampleRate 44100）是没关系的。声道数、采样位深、采样率共同决定了设备单位时间里采样数据的大小，这些数据是会缓冲起来，然后一块一块的通过这个数据回调给我们，这个回调的频率是底层一块一块给我们数据的速度，跟采样率无关。
        // 3）这个数据回调的频率是多少？
        // 这个数据回调的间隔是 [AVAudioSession sharedInstance].preferredIOBufferDuration，频率即该值的倒数。我们可以通过 [[AVAudioSession sharedInstance] setPreferredIOBufferDuration:1 error:nil] 设置这个值来控制回调频率。
        OSStatus status = AudioUnitRender(capture.componetInstance,
                                          ioActionFlags,
                                          inTimeStamp,
                                          inBusNumber,
                                          inNumberFrames,
                                          &buffers);
        
        // 数据封装及回调。
        if (status == noErr) {
            if (capture.muted) {
                for (int i = 0; i < buffers.mNumberBuffers; i++) {
                    AudioBuffer ab = buffers.mBuffers[i];
                    memset(ab.mData, 0, ab.mDataByteSize);
                }
            }
            if ([capture.delegate respondsToSelector:@selector(captureOutput:audioData:)]) {
                [capture.delegate captureOutput:capture audioData:[NSData dataWithBytes:buffers.mBuffers[0].mData length:buffers.mBuffers[0].mDataByteSize]];
            }
            /// 封装CMSampleBufferRef 参照 sampleBufferFromAudioBufferList
        }
        return status;
    }
}



#pragma mark -- NSNotification -
- (void)handleRouteChange:(NSNotification *)notification {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSString *seccReason = @"";
    NSInteger reason = [[[notification userInfo] objectForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    //  AVAudioSessionRouteDescription* prevRoute = [[notification userInfo] objectForKey:AVAudioSessionRouteChangePreviousRouteKey];
    switch (reason) {
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
            seccReason = @"路由改变了，因为没有合适的路由可用于指定的类别。";
            break;
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
            seccReason = @"当设备从睡眠中醒来时，路由发生变化。";
            break;
        case AVAudioSessionRouteChangeReasonOverride:
            seccReason = @"输出路由被应用程序重写。";
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            seccReason = @"会话对象的类别发生变化。";
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            seccReason = @"以前的音频输出路径不再可用。";
            break;
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            seccReason = @"一个首选的新的音频输出路径现在是可用的。";
            break;
        case AVAudioSessionRouteChangeReasonUnknown:
        default:
            seccReason = @"这一变化的原因尚不清楚。";
            break;
    }
    NSLog(@"handleRouteChange原因是 %@", seccReason);
    
    AVAudioSessionPortDescription *input = [[session.currentRoute.inputs count] ? session.currentRoute.inputs : nil objectAtIndex:0];
    if (input.portType == AVAudioSessionPortHeadsetMic) {
        
    }
}
- (void)handleInterruption:(NSNotification *)notification {
    NSInteger reason = 0;
    NSString *reasonStr = @"";
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        //当音频中断发生时
        reason = [[[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey] integerValue];
        if (reason == AVAudioSessionInterruptionTypeBegan) {
            if (self.isRunning) {
                dispatch_sync(_taskQueue, ^{
                    NSLog(@"被打断停止");
                    AudioOutputUnitStop(self.componetInstance);
                });
            }
        }
        
        if (reason == AVAudioSessionInterruptionTypeEnded) {
            reasonStr = @"结束打断";
            NSNumber *seccondReason = [[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey];
            switch ([seccondReason integerValue]) {
                case AVAudioSessionInterruptionOptionShouldResume:
                    if (self.isRunning) {
                        dispatch_async(_taskQueue, ^{
                            NSLog(@"被打断开始");
                            AudioOutputUnitStart(self.componetInstance);
                        });
                    }
                    break;
                default:
                    break;
            }
        }
    }
    NSLog(@"处理中断: %@ 原因 %@", [notification name], reasonStr);
}



#pragma mark - helper -
+ (CMSampleBufferRef)sampleBufferFromAudioBufferList:(AudioBufferList)buffers inTimeStamp:(const AudioTimeStamp *)inTimeStamp inNumberFrames:(UInt32)inNumberFrames description:(AudioStreamBasicDescription)description {
    CMSampleBufferRef sampleBuffer = NULL; // 待生成的 CMSampleBuffer 实例的引用。
    
    // 1、创建音频流的格式描述信息。
    CMFormatDescriptionRef format = NULL;
    OSStatus status = CMAudioFormatDescriptionCreate(kCFAllocatorDefault, &description, 0, NULL, 0, NULL, NULL, &format);
    if (status != noErr) {
        CFRelease(format);
        return nil;
    }
    
    // 2、处理音频帧的时间戳信息。
    mach_timebase_info_data_t info = {0, 0};
    mach_timebase_info(&info);
    uint64_t time = inTimeStamp->mHostTime;
    // 转换为纳秒。
    time *= info.numer;
    time /= info.denom;
    // PTS。
    CMTime presentationTime = CMTimeMake(time, 1000000000.0f);
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


@end
