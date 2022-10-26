//
//  MTVideoCaptureManager.m
//  Tips
//
//  Created by lss on 2022/10/26.
//

#import "MTVideoCaptureManager.h"

@interface MTVideoCaptureManager ()

/// 负责输入和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession *captureSession;
/// 负责从AVCaptureDevice获得视频输入流
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;
/// 负责从AVCaptureDevice获得音频输入流
@property (nonatomic, strong) AVCaptureDeviceInput *audioCaptureDeviceInput;
/// 视频输出流
@property (nonatomic, strong) AVCaptureMovieFileOutput *captureMovieFileOutput;
/// 相机拍摄预览图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@end

@implementation MTVideoCaptureManager

// 获取输入设备
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position {
    // 获取系统设备信息
    AVCaptureDeviceDiscoverySession* deviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    NSArray* devices = deviceDiscoverySession.devices;
    for (AVCaptureDevice* device in devices) {
        if (device.position == position) {
            return device;
            break;
        }
    }
    return nil;
}

@end
