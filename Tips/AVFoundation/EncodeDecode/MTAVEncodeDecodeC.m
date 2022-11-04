//
//  MTAVEncodeDecodeC.m
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import "MTAVEncodeDecodeC.h"
#import "MTSystemCapture.h"
#import "MTAudioEncoder.h"


#import "MTAudioCapture.h"
#import "MTVideoCapture.h"
@interface MTAVEncodeDecodeC ()<MTAudioCaptureDelegate, MTVideoCaptureDelegate>//<MTSystemCaptureDelegate, MTAudioEncoderDelegate>

@property (nonatomic, strong) MTAudioCapture *audioCapture;
@property (nonatomic, strong) MTVideoCapture *videoCapture;
//@property (nonatomic, strong) MTSystemCapture *capture;
//@property (nonatomic, strong) MTAudioEncoder *encode;

@end

@implementation MTAVEncodeDecodeC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.audioCapture = [[MTAudioCapture alloc] initWithAudioConfiguration:[MTLiveAudioConfiguration defaultConfiguration]];
//    self.audioCapture.delegate = self;
    
    self.videoCapture = [[MTVideoCapture alloc] initWithVideoConfiguration:[MTLiveVideoConfiguration defaultConfiguration]];
    self.videoCapture.delegate = self;
    self.videoCapture.preview = self.view;
//    MTAudioEncoder *encode = [[MTAudioEncoder alloc] initWithConfig:[MTAudioConfig defaultConfig]];
//    encode.delegate = self;
//    self.encode = encode;
//
//    MTSystemCapture *capture = [[MTSystemCapture alloc] init];//WithType:MTSystemCaptureTypeAudio];
//    capture.delegate = self;
//    capture.preview = self.view;
//    self.capture = capture;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.videoCapture.running = YES;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.videoCapture reverseCamera];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.videoCapture openFlash];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(14 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.videoCapture closeFlash];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(16 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.videoCapture openAntiShake];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.videoCapture closeAntiShake];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(22 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.videoCapture openSlow];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(28 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.videoCapture closeSlow];
    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(14 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(16 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//    });

//    // 调节焦距
//    - (void)changeFocus:(CGFloat)focus;
//    // 数码变焦
//    - (void)changeZoom:(CGFloat)zoom;
//    // 调节ISO,光感度
//    - (void)changeISO:(CGFloat)iso;
//    // 点击屏幕自动对焦
//    - (void)tap:(CGPoint)point;

   
    // Do any additional setup after loading the view.
}
- (void)captureOutput:(nullable MTVideoCapture *)capture pixelBuffer:(nullable CMSampleBufferRef)pixelBuffer{
    NSLog(@"视频");
}
- (void)captureOutput:(nullable MTAudioCapture *)capture audioData:(nullable NSData*)audioData{
    NSLog(@"音频");
}
- (void)captureSampleBuffer:(CMSampleBufferRef)sampleBuffer{
//    if (type == MTSystemCaptureTypeAudio){
//        [self.encode encodeAudioSampleBuffer:sampleBuffer];
//    }else if (type == MTSystemCaptureTypeVideo){
//
//    }
//    NSLog(@"%@",@(type));
}

- (void)audioEncodeCallback:(NSData *)aacData timeStamp:(uint64_t)timestamp{
    NSLog(@"😁😁😁😁%llu",timestamp);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
