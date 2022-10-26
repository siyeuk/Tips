//
//  MTColorPickerC.m
//  MT_Tips
//
//  Created by lss on 2022/10/10.
//

#import "MTColorPickerC.h"
#import "MTAVCaptureSession.h"
#import "MTBlurView.h"
#import "UIImage+MTCommon.h"
#import "UIColor+MTCommon.h"


@interface MTColorPickerC ()<MTAVCaptureSessionDelegate>

@property (nonatomic, strong) MTAVCaptureSession    *avCaptureSession; //摄像头采集工具
@property (nonatomic, strong) UIView                *preview; //摄像头采集内容视图
@property (nonatomic, strong) MTBlurView            *colorPickerView; //识别的颜色中心
@property (nonatomic, strong) CIContext             *context;
@property (nonatomic, assign) int                   hexColor; //识别的16进制的颜色值
@property (nonatomic, strong) UIView                *showView;

@end

@implementation MTColorPickerC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_avCaptureSession stopRunning];
    _avCaptureSession = nil;
}
- (void)dealloc {
    NSLog(@"%@释放了",NSStringFromClass(self.class));
}
#pragma mark - UI
- (void)setupUI {
    //    self.navigationController.navigationBar.translucent = YES;
    
    [self.view addSubview:self.preview];
    [self.view addSubview:self.colorPickerView];
    self.avCaptureSession.preview = self.preview;
    [self.avCaptureSession startRunning];
    [self.view addSubview:self.showView];
}

#pragma mark - Getter
- (MTAVCaptureSession *)avCaptureSession {
    if (_avCaptureSession == nil) {
        _avCaptureSession = [[MTAVCaptureSession alloc] init];
        _avCaptureSession.delegate = self;
    }
    return _avCaptureSession;
}
- (UIView *)showView{
    if (!_showView) {
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    }
    return _showView;
}
- (UIView *)preview {
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _preview;
}
- (MTBlurView *)colorPickerView {
    if (!_colorPickerView) {
        _colorPickerView = [[MTBlurView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _colorPickerView.blurView.alpha = 0.5;
        _colorPickerView.layer.cornerRadius = 20;
        _colorPickerView.layer.masksToBounds = YES;
        _colorPickerView.layer.borderWidth = 1;
        _colorPickerView.center = self.view.center;
    }
    return _colorPickerView;
}
-(CIContext *)context{
    // default creates a context based on GPU
    if (_context == nil) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

#pragma mark - SLAvCaptureSessionDelegate 音视频实时输出代理
//实时输出视频样本
- (void)captureSession:(MTAVCaptureSession *_Nullable)captureSession didOutputVideoSampleBuffer:(CMSampleBufferRef _Nullable )sampleBuffer fromConnection:(AVCaptureConnection *_Nullable)connection{
    @autoreleasepool {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CIImage* ciimage = [CIImage imageWithCVImageBuffer:imageBuffer];
        CGImageRef imageRef = [self.context createCGImage:ciimage fromRect:ciimage.extent];
        UIImage *img = [UIImage imageWithCGImage:imageRef];
        MT_DISPATCH_ON_MAIN_THREAD((^{
            UIColor *color = [img mt_colorAtPixel:CGPointMake(img.size.width/2.0,img.size.height/2.0)];
            int hex = [UIColor mt_hexValueWithColor:color];
            //误差在0x080808之内，可看作颜色没变化
            if (abs(self.hexColor-hex) >= 0x080808) {
                //每次摄像头采集的图像帧都不是完全一样的，虽然人眼看着一样，但是像素在细微处会有差距，所以采集到的每一帧的颜色也会有误差
                self.hexColor = hex;
                NSLog(@"%x %x",self.hexColor, hex);
            }
            self.showView.backgroundColor = [UIColor mt_colorWithHex: self.hexColor alpha:1.0];
//            self.navigationController.navigationBar.barTintColor = [UIColor mt_colorWithHex: self.hexColor alpha:1.0];
            self.title = [NSString stringWithFormat:@"识别的颜色：0x%x", self.hexColor];
            CGImageRelease(imageRef);
        }));
    }
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
