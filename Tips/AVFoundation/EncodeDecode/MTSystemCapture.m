//
//  MTSystemCapture.m
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import "MTSystemCapture.h"
#import <CoreMotion/CoreMotion.h>

@interface MTSystemCapture ()<AVCaptureVideoDataOutputSampleBufferDelegate>

//@property (nonatomic, assign) MTSystemCaptureType           captureType;
@property (nonatomic, assign) BOOL                          isRecording; //是否正在录制

@property (nonatomic, assign) AVCaptureDevicePosition       devicePosition;

@property (nonatomic, strong) AVCaptureSession              *captureSession;  //采集会话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer    *previewLayer;//摄像头采集内容展示区域

@property (nonatomic, strong) AVCaptureDeviceInput          *audioInput; //音频输入流
@property (nonatomic, strong) AVCaptureDeviceInput          *videoInput; //视频输入流
@property (nonatomic, strong) AVCaptureAudioDataOutput      *audioDataOutput; //音频数据帧输出流
@property (nonatomic, strong) AVCaptureVideoDataOutput      *videoDataOutput; //视频数据帧输出流
@property (nonatomic, strong) AVCaptureConnection           *videoConnection;
@property (nonatomic, strong) AVCaptureConnection           *audioConnection;

@property (nonatomic, assign) UIDeviceOrientation           shootingOrientation;   //拍摄录制时的手机方向
@property (nonatomic, strong) CMMotionManager               *motionManager;       //运动传感器  监测设备方向


@end

@implementation MTSystemCapture

//- (instancetype)initWithType:(MTSystemCaptureType)type{
//    if (self = [super init]) {
//        self.devicePosition = AVCaptureDevicePositionBack;
//        self.captureType = type;
//    }
//    return self;
//}
- (instancetype)init{
    if (self = [super init]) {
        self.devicePosition = AVCaptureDevicePositionBack;
    }
    return self;
}
//- (void)setCaptureType:(MTSystemCaptureType)captureType{
//    _captureType = captureType;
//    if (captureType == MTSystemCaptureTypeAudio) {
//        [self setupAudio];
//    }else if (captureType == MTSystemCaptureTypeVideo) {
//        [self setupVideo];
//    }else if (captureType == MTSystemCaptureTypeAll) {
//        [self setupAudio];
//        [self setupVideo];
//    }
//}


#pragma mark - init audio video -
- (void)setupAudio{
    if ([self.captureSession canAddInput:self.audioInput]) {
        [self.captureSession addInput:self.audioInput];
    }
    if ([self.captureSession canAddOutput:self.audioDataOutput]) {
        [self.captureSession addOutput:self.audioDataOutput];
    }
}
- (void)setupVideo{
    if ([self.captureSession canAddInput:self.videoInput]) {
        [self.captureSession addInput:self.videoInput];
    }
    if ([self.captureSession canAddOutput:self.videoDataOutput]) {
        [self.captureSession addOutput:self.videoDataOutput];
    }
}

#pragma mark - Public -
- (void)startCapture{
    if (self.captureSession.isRunning){
        return;
    }
    [self.captureSession startRunning];
}
- (void)stopCapture{
    if (!self.captureSession.isRunning) {
        return;
    }
    [self.captureSession stopRunning];
}

#pragma mark - setter -
- (void)setPreview:(UIView *)preview{
    if (preview == nil) {
        [self.previewLayer removeFromSuperlayer];
    }else {
        self.previewLayer.frame = preview.bounds;
        [preview.layer addSublayer:self.previewLayer];
    }
    _preview = preview;
}


- (void)reverseCamera{
    if (self.devicePosition == AVCaptureDevicePositionBack){
        self.devicePosition = AVCaptureDevicePositionFront;
    }else{
        self.devicePosition = AVCaptureDevicePositionBack;
    }
    AVCaptureDevice *videoCaptureDevice = [self getCameraDeviceWithPosition:self.devicePosition];
    AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:nil];
    
    // 修改输入设备
    [self.captureSession beginConfiguration];
    [self.captureSession removeInput:self.videoInput];
    if ([self.captureSession canAddInput:newInput]) {
        [self.captureSession addInput:newInput];
        self.videoInput = newInput;
    }
    [self.captureSession commitConfiguration];
    
    // 重新获取连接并设置方向
    self.videoConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (self.devicePosition == AVCaptureDevicePositionFront && self.videoConnection.supportsVideoMirroring) {
        self.videoConnection.videoMirrored = YES;
    }
}
#pragma mark - getter -
- (BOOL)isRunning{
    return self.captureSession.isRunning;
}
- (AVCaptureConnection *)videoConnection{
    if (!_videoConnection) {
        _videoConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    }
    return _videoConnection;
}
- (AVCaptureConnection *)audioConnection{
    if (!_audioConnection) {
        _audioConnection = [self.audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
    }
    return _audioConnection;
}
- (AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}
- (AVCaptureDeviceInput *)videoInput{
    if (!_videoInput) {
        NSError *error = nil;
        AVCaptureDevice *videoCaptureDevice = [self getCameraDeviceWithPosition:self.devicePosition];
        _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
        if (error) {
            NSLog(@"获取视频输入设备失败");
            return nil;
        }
    }
    return _videoInput;
}
- (AVCaptureDeviceInput *)audioInput{
    if (!_audioInput) {
        NSError *error = nil;
        AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        _audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
        if (error) {
            NSLog(@"获取音频输入设备失败");
            return nil;
        }
    }
    return _audioInput;
}
- (AVCaptureVideoDataOutput *)videoDataOutput{
    if (!_videoDataOutput) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        // 设置输出串行队列和数据回调
        dispatch_queue_t outputQueue = dispatch_queue_create("video_capture_output_queue", DISPATCH_QUEUE_SERIAL);
        [_videoDataOutput setSampleBufferDelegate:self queue:outputQueue];
    }
    return _videoDataOutput;
}
- (AVCaptureAudioDataOutput *)audioDataOutput{
    if (!_audioDataOutput) {
        _audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
        // 设置输出串行队列和数据回调
        dispatch_queue_t outputQueue = dispatch_queue_create("audio_capture_output_queue", DISPATCH_QUEUE_SERIAL);
        [_audioDataOutput setSampleBufferDelegate:self queue:outputQueue];
    }
    return _audioDataOutput;
}
- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _previewLayer;
}
- (CMMotionManager *)motionManager{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate -
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
//    if (output == self.videoDataOutput) {
        if ([self.delegate respondsToSelector:@selector(captureSampleBuffer:)]) {
            [self.delegate captureSampleBuffer:sampleBuffer];
        }
//    }else if (output == self.audioDataOutput) {
//        if ([self.delegate respondsToSelector:@selector(captureSampleBuffer:type:)]) {
//            [self.delegate captureSampleBuffer:sampleBuffer type:MTSystemCaptureTypeAudio];
//        }
//    }
}

#pragma mark - helpMethods -
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position{
    AVCaptureDeviceDiscoverySession *dissession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInDualCamera,AVCaptureDeviceTypeBuiltInTelephotoCamera,AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    for (AVCaptureDevice *device in dissession.devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}
+ (int)checkCameraAuthor{
    int result = 0;
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined:{
            // 请求授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:{
            // 允许
            return 1;
        }
            break;
        case AVAuthorizationStatusDenied:{
            // 拒绝
            result = -1;
        }
            break;
        case AVAuthorizationStatusRestricted:{
            // 家长模式
            result = -1;
        }
            break;
        default:
            return -1;
            break;
    }
    return result;
}

@end
