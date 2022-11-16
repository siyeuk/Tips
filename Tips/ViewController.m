//
//  ViewController.m
//  MT_Tips
//
//  Created by lss on 2022/10/10.
//

#import "ViewController.h"
#import "MTAVListC.h"
#import "MTSensorC.h"
#import "MTMediaC.h"
#import "MTWebRTCC.h"
#import "MTOpenGLC.h"

#import "MTOtherTBVC.h"

#import <MediaPlayer/MediaPlayer.h>

#import "MTExcelManager.h"

#import "MTVideoCapture.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, MTVideoCaptureDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *classArray;

@property (nonatomic, strong) MTVideoCapture *video;
@property (nonatomic, strong) UIView *originView;
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, assign) NSUInteger fpsCount;

@end

@implementation ViewController

- (void)captureOutput:(nullable MTVideoCapture *)capture newbuffer:(uint8_t *)newbuffer dataSize:(size_t)dataSize{
    [self encodeWithData:newbuffer bufferSize:dataSize];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iOS";
//    self.fpsCount = 1;
//    self.originView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mt_width, self.view.mt_height / 2.0)];
//    self.originView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.originView];
//    self.codeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.mt_height / 2.0, self.view.mt_width, self.view.mt_height / 2.0)];
//    self.codeView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.codeView];
//    
//    MTLiveVideoConfiguration *confi = [MTLiveVideoConfiguration defaultConfiguration];
//    _video = [[MTVideoCapture alloc] initWithVideoConfiguration:confi];
//    _video.delegate = self;
//    _video.preview = self.originView;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _video.running = YES;
//    });
//    
//    return;
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    appearance.backgroundColor = [UIColor whiteColor]; //背景色
    appearance.shadowColor = UIColor.clearColor; //阴影
    
    self.navigationController.navigationBar.standardAppearance = appearance;
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    
    self.navigationController.navigationBar.translucent = NO;
    
//    MTExcelManager *maneger = [[MTExcelManager alloc] init];
//    [maneger createExcelWithName:@"ok"];
//    [maneger write:@"00000000" location:MTLocationMake(0, 0)];
//    [maneger write:@"11111111" location:MTLocationMake(1, 0)];
//    [maneger write:@"22222222" location:MTLocationMake(2, 0)];
//    [maneger write:@"33333333" location:MTLocationMake(3, 0)];
//    [maneger write:@"44444444" location:MTLocationMake(4, 0)];
//    [maneger write:@"55555555" location:MTLocationMake(5, 0)];
//    [maneger write:@"66666666" location:MTLocationMake(6, 0)];
//
//    [maneger write:@"qqqqqqqq" merge:MTAeraMake(0, 1, 0, 5)];
//    [maneger write:@"wwwwwwww" merge:MTAeraMake(1, 1, 1, 5)];
//    [maneger write:@"eeeeeeee" merge:MTAeraMake(2, 1, 2, 5)];
//    [maneger write:@"rrrrrrrr" merge:MTAeraMake(3, 1, 3, 5)];
//    [maneger write:@"tttttttt" merge:MTAeraMake(4, 1, 4, 5)];
//    [maneger write:@"yyyyyyyy" merge:MTAeraMake(5, 1, 5, 5)];
//    [maneger write:@"uuuuuuuu" merge:MTAeraMake(5, 1, 5, 5)];
//
//    [maneger save];
//
    // Do any additional setup after loading the view.
}

- (void)h264Encode:(NSString *)input output:(NSString *)output{
//    NSFileHandle *infile = [NSFileHandle fileHandleForReadingAtPath:@"filename"];
//    [[NSFileManager defaultManager] createFileAtPath:output contents:nil attributes:nil];
//    NSFileHandle *outfile = [NSFileHandle fileHandleForWritingAtPath:output];
//    // 一帧图片的大小
//    int imageSize = av_image_get_buffer_size(<#enum AVPixelFormat pix_fmt#>, <#int width#>, <#int height#>, <#int align#>)

}

- (void)encodeWithData:(uint8_t *)inputBuffer bufferSize:(size_t)bufferSize{
    
//
//    AVCodecContext *context;
//
//    AVFrame *frame = av_frame_alloc();
//    frame->pts = self.fpsCount;
//    frame->width = 230;
//    frame->height = 480;
//    frame->format = AV_PIX_FMT_RGB24;
//
//
//
//
////    @param dst_data            要填充的数据指针
////    @param dst_linesize        dst_data中要被填充的线条大小(即linesize, 行宽)
////    @param src                包含实际图像的缓冲区(可以为空).
////    @param pix_fmt            图像的像素格式
////    @param width             图像的像素宽度
////    @param height            图像的像素高度
////    @param align             在src中用于行宽对齐的值
//    int ret = av_image_fill_arrays(frame->data, frame->linesize, inputBuffer, AV_PIX_FMT_BGR24, 230, 480, 1);
//    if (ret != 0){
//        NSLog(@"<><><><");
//    }
//
//
//
//    AVPacket *videoPacket = av_packet_alloc();
//
//    videoPacket->data = NULL;
//    videoPacket->size = 0;
//
//    // 进行H264编码
//    ret = avcodec_send_frame(context, frame);
//
//    // 打开文件
////    inData = [infile readDataOfLength:imageSize];
////    while (<#condition#>) {
////        <#statements#>
////    }
//
//    int gotPicture = 0;
//    // 将原始数据填充到AVFrame结构里,便于进行编码
    
}
              

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"AVFoundation音视频相关",
                        @"传感器集锦",
                        @"视频处理相关",
                        @"OpenGL-ES学习",
                        @"WebRTC",
                        @"Ohters"];
    }
    return _dataSource;
}
- (NSArray *)classArray{
    if (!_classArray) {
        _classArray = @[[MTAVListC class],
                        [MTSensorC class],
                        [MTMediaC class],
                        [MTOpenGLC class],
                        [MTWebRTCC class],
                        [MTOtherTBVC class]];
    }
    return _classArray;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = [[self.classArray[indexPath.row] alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
