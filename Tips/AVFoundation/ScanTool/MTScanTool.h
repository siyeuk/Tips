//
//  MTScanTool.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 环境光亮度
typedef void(^MTMonitorLightBlock)(CGFloat brightness);
/// 结果回调
typedef void(^MTScanFinishedBlock)(NSString *_Nullable scanString);


@interface MTScanTool : NSObject

// 闪光灯状态
@property (nonatomic, assign, readonly) BOOL flashStatus;
// 扫描结果回调 多个目前默认展示第一个
@property (nonatomic, copy) MTScanFinishedBlock _Nullable scanFinishedBlock;
// 获取环境光亮度
@property (nonatomic, copy) MTMonitorLightBlock _Nullable monitorLightBlock;


- (instancetype)initWithPreview:(UIView *)preview scanFrame:(CGRect)scanFrame;

- (void)openFlash:(BOOL)status;
- (void)startRuning;
- (void)stopRuning;

/// 识别图片
+ (NSString *)scanImage:(UIImage *)image;
/// 生成二维码
+ (UIImage *)createQRCodeWithString:(nonnull NSString *)codeString size:(CGSize)size backColor:(nullable UIColor *)backColor frontColor:(nullable UIColor *)frontColor centerImage:(nullable UIImage *)centerImage;



@end

NS_ASSUME_NONNULL_END
