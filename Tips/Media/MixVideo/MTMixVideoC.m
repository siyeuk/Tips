//
//  MTMixVideoC.m
//  Tips
//
//  Created by lss on 2022/10/26.
//

#import "MTMixVideoC.h"
#import <AVFoundation/AVFoundation.h>


@interface MTMixVideoC ()

@property (nonatomic, strong) UILabel *waitLabel;

@end

@implementation MTMixVideoC

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [self createLabelText:@"默认使用demo.mp4, MyHeartWillGoOn.mp4, 合并结果从文件查看" frame:CGRectMake(0, 0, self.view.mt_width, 30) font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    self.waitLabel = [self createLabelText:@"拼接中,请等待" frame:CGRectMake(0, 150, self.view.mt_width, 200) font:[UIFont systemFontOfSize:30] textColor:[UIColor blackColor]];
    self.waitLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.waitLabel];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self mixVideo:@[[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mp4"],[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mp4"]] newVideoName:@"MyHeartWillGoOn.mp4"];
}
- (void)mixVideo:(NSArray <NSString *>*)paths newVideoName:(NSString *)name{
    dispatch_async(dispatch_get_main_queue(), ^{
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        videoTrack.preferredTransform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
        
        CMTime totalDuration = kCMTimeZero;
        
        //        NSMutableArray<AVMutableVideoCompositionLayerInstruction *> *instructions = [NSMutableArray array];
        
        for (int i = 0; i < paths.count; i++) {
            AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:paths[i]]];
            
            
            AVAssetTrack *assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
            AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]firstObject];
            
            NSLog(@"%lld", asset.duration.value/asset.duration.timescale);
            
            NSError *erroraudio = nil;
            BOOL ba = [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetAudioTrack atTime:totalDuration error:&erroraudio];
            NSLog(@"erroraudio:%@--%d", erroraudio, ba);
            
            NSError *errorVideo = nil;
            
            BOOL bl = [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetVideoTrack atTime:totalDuration error:&errorVideo];
            NSLog(@"errorVideo:%@--%d",errorVideo,bl);
            
            //            AVMutableVideoCompositionLayerInstruction *instruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
            //            UIImageOrientation assetOrientation = UIImageOrientationUp;
            //            BOOL isAssetPortrait = NO;
            //            // 根据视频的实际拍摄方向来调整视频的方向
            //            CGAffineTransform videoTransform = assetVideoTrack.preferredTransform;
            //            if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
            //                NSLog(@"垂直拍摄");
            //                assetOrientation = UIImageOrientationRight;
            //                isAssetPortrait = YES;
            //            }else if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
            //                NSLog(@"倒立拍摄");
            //                assetOrientation = UIImageOrientationLeft;
            //                isAssetPortrait = YES;
            //            }else if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
            //                NSLog(@"Home键右侧水平拍摄");
            //                assetOrientation = UIImageOrientationUp;
            //            }else if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
            //                NSLog(@"Home键左侧水平拍摄");
            //                assetOrientation = UIImageOrientationDown;
            //            }
            //            CGFloat assetScaleToFitRatio = 720.0 / assetVideoTrack.naturalSize.width;
            //            if (isAssetPortrait) {
            //                assetScaleToFitRatio = 720.0 / assetVideoTrack.naturalSize.height;
            //                CGAffineTransform assetSacleFactor = CGAffineTransformMakeScale(assetScaleToFitRatio, assetScaleToFitRatio);
            //                [instruction setTransform:CGAffineTransformConcat(assetVideoTrack.preferredTransform, assetSacleFactor) atTime:totalDuration];
            //            } else {
            //                /**
            //                 竖直方向视频尺寸：720*1280
            //                 水平方向视频尺寸：720*405
            //                 水平方向视频需要剧中的y值：（1280 － 405）／ 2 ＝ 437.5
            //                 **/
            //                CGAffineTransform assetSacleFactor = CGAffineTransformMakeScale(assetScaleToFitRatio, assetScaleToFitRatio);
            //                [instruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(assetVideoTrack.preferredTransform, assetSacleFactor), CGAffineTransformMakeTranslation(0, 437.5)) atTime:totalDuration];
            //            }
            //            // 把新的插入到最上面，最后是按照数组顺序播放的。
            //            [instructions insertObject:instruction atIndex:0];
            //            totalDuration = CMTimeAdd(totalDuration, asset.duration);
            //            // 在当前视频时间点结束后需要清空尺寸，否则如果第二个视频尺寸比第一个小，它会显示在第二个视频的下方。
            //            [instruction setCropRectangle:CGRectZero atTime:totalDuration];
        }
        
        //        AVMutableVideoCompositionInstruction *mixInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        //        mixInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
        //        mixInstruction.layerInstructions = instructions;
        
        //        AVMutableVideoComposition *mixVideoComposition = [AVMutableVideoComposition videoComposition];
        //        mixVideoComposition.instructions = [NSArray arrayWithObject:mixInstruction];
        //        mixVideoComposition.frameDuration = CMTimeMake(1, 25);
        //        mixVideoComposition.renderSize = CGSizeMake(720.0, 1280.0);
        //
        NSString *outPath = [MT_DocumentDir stringByAppendingPathComponent:name];
        NSURL *mergeFileURL = [NSURL fileURLWithPath:outPath];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        exporter.outputURL = mergeFileURL;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        //        exporter.videoComposition = mixVideoComposition;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.waitLabel.text = @"合并成功,前往文件查看";
                [MTAlertView showAlertViewWithText:@"合并成功,前往文件查看" delayHid:2];
            });
        }];
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
