//
//  MTVideoSpeedC.m
//  Tips
//
//  Created by lss on 2022/10/26.
//

#import "MTVideoSpeedC.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MTVideoSpeedC ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *waitLabel;

@end

@implementation MTVideoSpeedC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"调整视频速度";
    UILabel *titleLabel = [self createLabelText:@"默认使用demo.mp4, 5倍速" frame:CGRectMake(0, 0, self.view.mt_width, 30) font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
//    self.textField = [self createTextField:@"填入倍率(数字)" frame:CGRectMake(20, 40, self.view.mt_width - 40, 40) font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor]];
//    self.textField.borderStyle = UITextBorderStyleRoundedRect;
//    [self.view addSubview:self.textField];
    
    UIButton *button = [self createButton:@"转换" frame:CGRectMake(50, 100, self.view.mt_width - 100, 38) font:[UIFont systemFontOfSize:17] backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] target:@selector(buttonBeClicked:)];
    [self.view addSubview:button];
    
    self.waitLabel = [self createLabelText:@"请等待" frame:CGRectMake(0, 150, self.view.mt_width, 200) font:[UIFont systemFontOfSize:30] textColor:[UIColor blackColor]];
    self.waitLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.waitLabel];
    self.waitLabel.hidden = YES;
    
    // Do any additional setup after loading the view.
}
- (void)buttonBeClicked:(UIButton *)btn{
    self.waitLabel.hidden = NO;
    btn.hidden = YES;
    
    NSString *kMoviePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mp4"];
    NSString *kMovieName = @"fastVideo.mp4";
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"视频设置线程: %@", [NSThread currentThread]);
        // 获取视频
        AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:kMoviePath] options:nil];
        // 视频混合
        AVMutableComposition* mixComposition = [AVMutableComposition composition];
        // 视频轨道
        AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        // 音频轨道
        AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        // 视频方向
        CGAffineTransform videoTransform = [videoAsset tracksWithMediaType:AVMediaTypeVideo].lastObject.preferredTransform;
        if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
            NSLog(@"垂直拍摄");
            videoTransform = CGAffineTransformMakeRotation(M_PI_2);
        }else if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
            NSLog(@"倒立拍摄");
            videoTransform = CGAffineTransformMakeRotation(-M_PI_2);
        }else if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
            NSLog(@"Home键右侧水平拍摄");
            videoTransform = CGAffineTransformMakeRotation(0);
        }else if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
            NSLog(@"Home键左侧水平拍摄");
            videoTransform = CGAffineTransformMakeRotation(M_PI);
        }
        
        // 根据视频的方向同步视频轨道方向
        compositionVideoTrack.preferredTransform = videoTransform;
        compositionVideoTrack.naturalTimeScale = 600;
        
        // 插入视频轨道
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(videoAsset.duration.value, videoAsset.duration.timescale)) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject] atTime:kCMTimeZero error:nil];
        // 插入音频轨道
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(videoAsset.duration.value, videoAsset.duration.timescale)) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject] atTime:kCMTimeZero error:nil];
        
        // 适配视频速度比率
        CGFloat scale = 0.2;
//        if([video[kMovieSpeed] isEqualToString:kMovieSpeed_Fast]){
//            scale = 0.2f;  // 快速 x5
//        } else if ([video[kMovieSpeed] isEqualToString:kMovieSpeed_Slow]) {
//            scale = 4.0f;  // 慢速 x4
//        }
        
        // 根据速度比率调节音频和视频
        [compositionVideoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(videoAsset.duration.value, videoAsset.duration.timescale)) toDuration:CMTimeMake(videoAsset.duration.value * scale , videoAsset.duration.timescale)];
        [compositionAudioTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(videoAsset.duration.value, videoAsset.duration.timescale)) toDuration:CMTimeMake(videoAsset.duration.value * scale, videoAsset.duration.timescale)];
        
        // 配置导出
        AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset1280x720];
        // 导出视频的临时保存路径
        NSString *exportPath = [MT_CachesDir stringByAppendingPathComponent:kMovieName];
        NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];
        
        // 导出视频的格式 .MOV
        _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
        _assetExport.outputURL = exportUrl;
        _assetExport.shouldOptimizeForNetworkUse = YES;
        
        // 导出视频
        [_assetExport exportAsynchronouslyWithCompletionHandler:
         ^(void ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [_processedVideoPaths addObject:exportPath];
                // 将导出的视频保存到相册
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                if (![library videoAtPathIsCompatibleWithSavedPhotosAlbum:[NSURL URLWithString:exportPath]]){
                    [self showText:@"cache can't write"];
                    return;
                }
                [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:exportPath] completionBlock:^(NSURL *assetURL, NSError *error) {
                    if (error) {
                        [self showText:@"cache write error"];
                    } else {
                        [self showText:@"cache write success"];
                    }
                }];
            });
        }];
    });
    
    
}
- (void)showText:(NSString *)text{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MTAlertView showAlertViewWithText:text delayHid:1.4];
    });
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
