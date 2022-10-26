//
//  MTWaterMarkC.h
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import "MTViewController.h"

NS_ASSUME_NONNULL_BEGIN
/// 添加水印 文字和GIF图
@interface MTWaterMarkC : MTViewController

@property (nonatomic, strong) NSURL *videoPath; //当前拍摄的视频路径
@property (nonatomic, assign) UIDeviceOrientation videoOrientation;// 视频方向

@end

NS_ASSUME_NONNULL_END
