//
//  MTVideoCapture.m
//  MT_Tips
//
//  Created by lss on 2022/10/13.
//

#import "MTVideoCapture.h"

@interface MTVideoCapture ()<AVCaptureVideoDataOutputSampleBufferDelegate>{
    AVCaptureDeviceFormat *_defaultFormat;
    CMTime _defaultMinFrameDuration;
    CMTime _defaultMaxFrameDuration;
}

@property (nonatomic, assign) AVCaptureDevicePosition       devicePosition;

@property (nonatomic, strong) AVCaptureSession              *captureSession;  //采集会话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer    *previewLayer;//摄像头采集内容展示区域

@property (nonatomic, strong) AVCaptureDeviceInput          *videoInput; //视频输入流
@property (nonatomic, strong) AVCaptureVideoDataOutput      *videoDataOutput; //视频数据帧输出流
@property (nonatomic, strong) AVCaptureConnection           *videoConnection;

@property (nonatomic, assign) BOOL                          capturePaused;

@property (nonatomic, assign) MTLiveVideoConfiguration      *configuration;
@property (nonatomic, strong) dispatch_queue_t taskQueue;

@end

@implementation MTVideoCapture

- (nullable instancetype)initWithVideoConfiguration:(nullable MTLiveVideoConfiguration *)configuration{
    if (self = [super init]) {
        _configuration = configuration;
        self.capturePaused = NO;
        self.taskQueue = dispatch_queue_create("com.videoCapture.mt", DISPATCH_QUEUE_SERIAL);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        self.devicePosition = AVCaptureDevicePositionFront;
        if ([self.captureSession canAddInput:self.videoInput]) {
            [self.captureSession addInput:self.videoInput];
        }
        if ([self.captureSession canAddOutput:self.videoDataOutput]) {
            [self.captureSession addOutput:self.videoDataOutput];
        }
        
     
    }
    return self;
}

- (void)setRunning:(BOOL)running{
    if (_running == running) {
        return;
    }
    _running = running;
    if (_running) {
        dispatch_async(_taskQueue, ^{
            [self.captureSession startRunning];
        });
    }else{
        [self.captureSession stopRunning];
    }
}
- (void)setPreview:(UIView *)preview{
    if (preview == nil) {
        [self.previewLayer removeFromSuperlayer];
    }else {
        self.previewLayer.frame = preview.bounds;
        [preview.layer addSublayer:self.previewLayer];
    }
    _preview = preview;
}
#pragma mark - Public -
// 切换摄像头
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
- (void)setCameraResolutionByPreset:(AVCaptureSessionPreset)sessionPreset{
    if ([self.captureSession.sessionPreset isEqualToString:sessionPreset]) {
        NSLog(@"已是当前分辨率");
        return;
    }
    if ([self.captureSession canSetSessionPreset:sessionPreset]) {
        NSLog(@"不能设置当前分辨率");
        return;
    }
    [self.captureSession beginConfiguration];
    self.captureSession.sessionPreset = sessionPreset;
    [self.captureSession commitConfiguration];
}
// 调整帧率 
- (void)changeFrameRate:(int)frameRate{
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:self.devicePosition];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]){
        [captureDevice setActiveVideoMinFrameDuration:CMTimeMake(1, frameRate)];
        [captureDevice setActiveVideoMaxFrameDuration:CMTimeMake(1, frameRate)];
        [captureDevice unlockForConfiguration];
    }
    
}
// 打开闪光灯
- (void)openFlash{
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:self.devicePosition];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        if ([captureDevice isTorchModeSupported:AVCaptureTorchModeOn]){
            [captureDevice setTorchMode:AVCaptureTorchModeOn];
        }
    }
}
// 关闭闪光灯
- (void)closeFlash{
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:self.devicePosition];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        if ([captureDevice isTorchModeSupported:AVCaptureTorchModeOff]){
            [captureDevice setTorchMode:AVCaptureTorchModeOff];
        }
    }
}
// 调节焦距
- (void)changeFocus:(CGFloat)focus{
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:self.devicePosition];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) [captureDevice setFocusModeLockedWithLensPosition:focus completionHandler:nil];
    }
}
// 数码变焦
- (void)changeZoom:(CGFloat)zoom{
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:self.devicePosition];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        [captureDevice rampToVideoZoomFactor:zoom withRate:50];
    }
}
// 调节ISO,光感度
- (void)changeISO:(CGFloat)iso{
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:self.devicePosition];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        CGFloat minISO = captureDevice.activeFormat.minISO;
        CGFloat maxISO = captureDevice.activeFormat.maxISO;
        CGFloat currentISO = (maxISO - minISO) * iso + minISO;
        [captureDevice setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent ISO:currentISO completionHandler:nil];
        [captureDevice unlockForConfiguration];
    }
}
// 点击屏幕自动对焦
- (void)tap:(CGPoint)point{
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:self.devicePosition];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        CGPoint location = point;
        CGPoint pointOfInerest = CGPointMake(0.5, 0.5);
        CGSize frameSize = self.previewLayer.frame.size;
        if ([captureDevice position] == AVCaptureDevicePositionFront) location.x = frameSize.width - location.x;
        pointOfInerest = CGPointMake(location.y / frameSize.height, 1.f - (location.x / frameSize.width));
        [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:pointOfInerest];
        
        [[self.videoInput device] addObserver:self forKeyPath:@"ISO" options:NSKeyValueObservingOptionNew context:NULL];
    }
}
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    AVCaptureDevice *captureDevice = [self.videoInput device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        if ([captureDevice isFocusModeSupported:focusMode]) [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        if ([captureDevice isFocusPointOfInterestSupported]) [captureDevice setFocusPointOfInterest:point];
        if ([captureDevice isExposureModeSupported:exposureMode]) [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        if ([captureDevice isExposurePointOfInterestSupported]) [captureDevice setExposurePointOfInterest:point];
    }
}
// 开启慢动作拍摄
- (void)openSlow{
    [self.captureSession stopRunning];
    CGFloat desiredFPS = 240.0;
       AVCaptureDevice *videoDevice = self.videoInput.device;
       AVCaptureDeviceFormat *selectedFormat = nil;
       int32_t maxWidth = 0;
       AVFrameRateRange *frameRateRange = nil;
       for (AVCaptureDeviceFormat *format in [videoDevice formats]) {
           for (AVFrameRateRange *range in format.videoSupportedFrameRateRanges) {
               CMFormatDescriptionRef desc = format.formatDescription;
               CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(desc);
               int32_t width = dimensions.width;
               if (range.minFrameRate <= desiredFPS && desiredFPS <= range.maxFrameRate && width >= maxWidth) {
                   selectedFormat = format;
                   frameRateRange = range;
                   maxWidth = width;
               }
           }
       }
       if (selectedFormat) {
           if ([videoDevice lockForConfiguration:nil]) {
               NSLog(@"selected format: %@", selectedFormat);
               videoDevice.activeFormat = selectedFormat;
               videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
               videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
               [videoDevice unlockForConfiguration];
           }
       }
       [self.captureSession startRunning];
}
// 关闭慢动作拍摄
- (void)closeSlow{
    [self.captureSession stopRunning];
      CGFloat desiredFPS = 60.0;
      AVCaptureDevice *videoDevice = self.videoInput.device;
      AVCaptureDeviceFormat *selectedFormat = nil;
      int32_t maxWidth = 0;
      AVFrameRateRange *frameRateRange = nil;
      for (AVCaptureDeviceFormat *format in [videoDevice formats]) {
          for (AVFrameRateRange *range in format.videoSupportedFrameRateRanges) {
              CMFormatDescriptionRef desc = format.formatDescription;
              CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(desc);
              int32_t width = dimensions.width;
              if (range.minFrameRate <= desiredFPS && desiredFPS <= range.maxFrameRate && width >= maxWidth) {
                  selectedFormat = format;
                  frameRateRange = range;
                  maxWidth = width;
              }
          }
      }
      if (selectedFormat) {
          if ([videoDevice lockForConfiguration:nil]) {
              NSLog(@"selected format: %@", selectedFormat);
              videoDevice.activeFormat = _defaultFormat;
              videoDevice.activeVideoMinFrameDuration = _defaultMinFrameDuration;
              videoDevice.activeVideoMaxFrameDuration = _defaultMaxFrameDuration;
              [videoDevice unlockForConfiguration];
          }
      }
      [self.captureSession startRunning];
}
// 打开防抖
- (void)openAntiShake{
//    AVCaptureConnection *captureConnection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
//    NSLog(@"change captureConnection: %@", captureConnection);
//    AVCaptureDevice *videoDevice = self.captureDeviceInput.device;
//    NSLog(@"set format: %@", videoDevice.activeFormat);
//    if ([videoDevice.activeFormat isVideoStabilizationModeSupported:AVCaptureVideoStabilizationModeCinematic]) {
//        captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
//    }
}
// 关闭防抖
- (void)closeAntiShake{
    
}
#pragma mark - getter -
- (AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}
- (AVCaptureConnection *)videoConnection{
    if (!_videoConnection) {
        _videoConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    }
    return _videoConnection;
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
        // 保存默认的AVCaptureDeviceFormat
        // 之所以保存是因为修改摄像头捕捉频率之后，防抖就无法再次开启，试了下只能够用这个默认的format才可以，所以把它存起来，关闭慢动作拍摄后在设置会默认的format开启防抖
        
        _defaultFormat = videoCaptureDevice.activeFormat;
        _defaultMinFrameDuration = videoCaptureDevice.activeVideoMinFrameDuration;
        _defaultMaxFrameDuration = videoCaptureDevice.activeVideoMaxFrameDuration;
        
    }
    return _videoInput;
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
- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _previewLayer;
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


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate -
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (!self.capturePaused) {
        if ([self.delegate respondsToSelector:@selector(captureOutput:pixelBuffer:)]) {
            [self.delegate captureOutput:self pixelBuffer:sampleBuffer];
        }
    }
    if ([self.delegate respondsToSelector:@selector(captureOutput:newbuffer:dataSize:)]) {
        // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // 锁定pixel buffer的基地址
        if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess) {
            // 得到pixel buffer的基地址
            uint8_t *bufferPtr = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
            uint8_t *uvPtr = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 1);
            size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
            NSLog(@"=== buffsize : %zu",bufferSize);
            bool isPlanar = CVPixelBufferIsPlanar(imageBuffer);
            if (isPlanar) {
                int planeCount = CVPixelBufferGetPlaneCount(imageBuffer);
                NSLog(@"=== planeCount : %d \n ",planeCount);
            }
            size_t ysize = 640 * 480;
            uint8_t *newbuffer = (uint8_t *)malloc(ysize * 1.5);
            memcpy(newbuffer, bufferPtr, ysize * 1.5);
            // 录制视频的原始数据 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
            [self.delegate captureOutput:self newbuffer:newbuffer dataSize:ysize];
            
            free(newbuffer);
            // 解锁pixel buffer
            CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        }
    }
}
#pragma mark - notification -
- (void)willEnterBackground:(NSNotification *)notification {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    self.capturePaused = YES;
}

- (void)willEnterForeground:(NSNotification *)notification {
    self.capturePaused = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)statusBarChanged:(NSNotification *)notification {
    NSLog(@"UIApplicationWillChangeStatusBarOrientationNotification. UserInfo: %@", notification.userInfo);
    UIInterfaceOrientation statusBar = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(self.configuration.autorotate){
        if (self.configuration.landscape) {
            if (statusBar == UIInterfaceOrientationLandscapeLeft) {
                //                self.videoCamera.outputImageOrientation = UIInterfaceOrientationLandscapeRight;
            } else if (statusBar == UIInterfaceOrientationLandscapeRight) {
                //                self.videoCamera.outputImageOrientation = UIInterfaceOrientationLandscapeLeft;
            }
        } else {
            if (statusBar == UIInterfaceOrientationPortrait) {
                //                self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortraitUpsideDown;
            } else if (statusBar == UIInterfaceOrientationPortraitUpsideDown) {
                //                self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
            }
        }
    }
}

@end
