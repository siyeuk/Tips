//
//  MTLiveVideoConfiguration.m
//  MT_Tips
//
//  Created by lss on 2022/10/13.
//

#import "MTLiveVideoConfiguration.h"
#import <AVFoundation/AVFoundation.h>

@implementation MTLiveVideoConfiguration


+ (instancetype)defaultConfiguration {
    MTLiveVideoConfiguration *configuration = [MTLiveVideoConfiguration defaultConfigurationForQuality:MTLiveVideoQuality_Default];
    return configuration;
}

+ (instancetype)defaultConfigurationForQuality:(MTLiveVideoQuality)videoQuality {
    MTLiveVideoConfiguration *configuration = [MTLiveVideoConfiguration defaultConfigurationForQuality:videoQuality outputImageOrientation:UIInterfaceOrientationPortrait];
    return configuration;
}

+ (instancetype)defaultConfigurationForQuality:(MTLiveVideoQuality)videoQuality outputImageOrientation:(UIInterfaceOrientation)outputImageOrientation {
    MTLiveVideoConfiguration *configuration = [MTLiveVideoConfiguration new];
    switch (videoQuality) {
    case MTLiveVideoQuality_Low1:{
        configuration.sessionPreset = MTCaptureSessionPreset360x640;
        configuration.videoFrameRate = 15;
        configuration.videoMaxFrameRate = 15;
        configuration.videoMinFrameRate = 10;
        configuration.videoBitRate = 500 * 1000;
        configuration.videoMaxBitRate = 600 * 1000;
        configuration.videoMinBitRate = 400 * 1000;
        configuration.videoSize = CGSizeMake(360, 640);
    }
        break;
    case MTLiveVideoQuality_Low2:{
        configuration.sessionPreset = MTCaptureSessionPreset360x640;
        configuration.videoFrameRate = 24;
        configuration.videoMaxFrameRate = 24;
        configuration.videoMinFrameRate = 12;
        configuration.videoBitRate = 600 * 1000;
        configuration.videoMaxBitRate = 720 * 1000;
        configuration.videoMinBitRate = 500 * 1000;
        configuration.videoSize = CGSizeMake(360, 640);
    }
        break;
    case MTLiveVideoQuality_Low3: {
        configuration.sessionPreset = MTCaptureSessionPreset360x640;
        configuration.videoFrameRate = 30;
        configuration.videoMaxFrameRate = 30;
        configuration.videoMinFrameRate = 15;
        configuration.videoBitRate = 800 * 1000;
        configuration.videoMaxBitRate = 960 * 1000;
        configuration.videoMinBitRate = 600 * 1000;
        configuration.videoSize = CGSizeMake(360, 640);
    }
        break;
    case MTLiveVideoQuality_Medium1:{
        configuration.sessionPreset = MTCaptureSessionPreset540x960;
        configuration.videoFrameRate = 15;
        configuration.videoMaxFrameRate = 15;
        configuration.videoMinFrameRate = 10;
        configuration.videoBitRate = 800 * 1000;
        configuration.videoMaxBitRate = 960 * 1000;
        configuration.videoMinBitRate = 500 * 1000;
        configuration.videoSize = CGSizeMake(540, 960);
    }
        break;
    case MTLiveVideoQuality_Medium2:{
        configuration.sessionPreset = MTCaptureSessionPreset540x960;
        configuration.videoFrameRate = 24;
        configuration.videoMaxFrameRate = 24;
        configuration.videoMinFrameRate = 12;
        configuration.videoBitRate = 800 * 1000;
        configuration.videoMaxBitRate = 960 * 1000;
        configuration.videoMinBitRate = 500 * 1000;
        configuration.videoSize = CGSizeMake(540, 960);
    }
        break;
    case MTLiveVideoQuality_Medium3:{
        configuration.sessionPreset = MTCaptureSessionPreset540x960;
        configuration.videoFrameRate = 30;
        configuration.videoMaxFrameRate = 30;
        configuration.videoMinFrameRate = 15;
        configuration.videoBitRate = 1000 * 1000;
        configuration.videoMaxBitRate = 1200 * 1000;
        configuration.videoMinBitRate = 500 * 1000;
        configuration.videoSize = CGSizeMake(540, 960);
    }
        break;
    case MTLiveVideoQuality_High1:{
        configuration.sessionPreset = MTCaptureSessionPreset720x1280;
        configuration.videoFrameRate = 15;
        configuration.videoMaxFrameRate = 15;
        configuration.videoMinFrameRate = 10;
        configuration.videoBitRate = 1000 * 1000;
        configuration.videoMaxBitRate = 1200 * 1000;
        configuration.videoMinBitRate = 500 * 1000;
        configuration.videoSize = CGSizeMake(720, 1280);
    }
        break;
    case MTLiveVideoQuality_High2:{
        configuration.sessionPreset = MTCaptureSessionPreset720x1280;
        configuration.videoFrameRate = 24;
        configuration.videoMaxFrameRate = 24;
        configuration.videoMinFrameRate = 12;
        configuration.videoBitRate = 1200 * 1000;
        configuration.videoMaxBitRate = 1440 * 1000;
        configuration.videoMinBitRate = 800 * 1000;
        configuration.videoSize = CGSizeMake(720, 1280);
    }
        break;
    case MTLiveVideoQuality_High3:{
        configuration.sessionPreset = MTCaptureSessionPreset720x1280;
        configuration.videoFrameRate = 30;
        configuration.videoMaxFrameRate = 30;
        configuration.videoMinFrameRate = 15;
        configuration.videoBitRate = 1200 * 1000;
        configuration.videoMaxBitRate = 1440 * 1000;
        configuration.videoMinBitRate = 500 * 1000;
        configuration.videoSize = CGSizeMake(720, 1280);
    }
        break;
    default:
        break;
    }
    configuration.sessionPreset = [configuration supportSessionPreset:configuration.sessionPreset];
    configuration.videoMaxKeyframeInterval = configuration.videoFrameRate*2;
    configuration.outputImageOrientation = outputImageOrientation;
    CGSize size = configuration.videoSize;
    if(configuration.landscape) {
        configuration.videoSize = CGSizeMake(size.height, size.width);
    } else {
        configuration.videoSize = CGSizeMake(size.width, size.height);
    }
    return configuration;
    
}

- (MTLiveVideoSessionPreset)supportSessionPreset:(MTLiveVideoSessionPreset)sessionPreset {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *inputCamera;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices){
        if ([device position] == AVCaptureDevicePositionFront){
            inputCamera = device;
        }
    }
    AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:nil];
    
    if ([session canAddInput:videoInput]){
        [session addInput:videoInput];
    }
    
    if (![session canSetSessionPreset:self.avSessionPreset]) {
        if (sessionPreset == MTCaptureSessionPreset720x1280) {
            sessionPreset = MTCaptureSessionPreset540x960;
            if (![session canSetSessionPreset:self.avSessionPreset]) {
                sessionPreset = MTCaptureSessionPreset360x640;
            }
        } else if (sessionPreset == MTCaptureSessionPreset540x960) {
            sessionPreset = MTCaptureSessionPreset360x640;
        }
    }
    return sessionPreset;
}


@end
