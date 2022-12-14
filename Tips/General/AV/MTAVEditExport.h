//
//  MTAVEditExport.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTAVEditExport : NSObject

/// 输出路径
@property (nonatomic, strong) NSURL * _Nonnull              outputURL;
/// 音视频裁剪范围   默认不裁剪
@property (nonatomic, assign) CMTimeRange                   timeRange;
/// 速率 默认1.0  推荐设置范围:0.5~2.0
@property (nonatomic, assign) float                         rate;
/// 是否保留原生音频 默认YES
@property (nonatomic, assign) BOOL                          isNativeAudio;
/// 添加音频
@property (nonatomic, strong, nullable) NSArray <NSURL *>   *audioUrls;
/// 涂鸦层
@property (nonatomic, strong, nullable) CALayer             *graffitiLayer;
/// 贴图 和文本 层集合
@property (nonatomic, strong, nullable) NSMutableArray <CALayer *>*stickerLayers;

/// 初始化
- (id)initWithAsset:(AVAsset *)asset;
/// 导出编辑后的视频
- (void)exportAsynchronouslyWithCompletionHandler:(void (^)(NSError *error))handler progress:(void (^)(float progress))exportProgress;

@end

NS_ASSUME_NONNULL_END
