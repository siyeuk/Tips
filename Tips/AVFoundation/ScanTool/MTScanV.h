//
//  MTScanV.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN




@interface MTScanV : UIView

// 点击我的二维码回调
@property (nonatomic, copy) void(^myQRCodeBlock)(void);
// 闪光灯状态回调
@property (nonatomic, copy) void(^flashSwitchBlock)(BOOL status);


// 扫码区域 默认正方形 x=60 y=100
@property (nonatomic, assign) CGRect scanRect;
// 是否需要绘制扫码矩形框 默认yes
@property (nonatomic, assign) BOOL isNeedLine;
// 矩形框线条颜色
@property (nonatomic, strong) UIColor *lineColor;

// 扫码区域周围四个角
// 四个角的颜色
@property (nonatomic, strong) UIColor *colorAngle;
// 扫码区域四个角宽带和高度 默认都为20
@property (nonatomic, assign) CGFloat photoframeAngleW;
@property (nonatomic, assign) CGFloat photoframeAngleH;

// 扫码区域四个角的线条宽度 默认6
@property (nonatomic, assign) CGFloat photoframeLineW;

// 动画效果
// 动画效果的图像
@property (nonatomic, strong) UIImage *animationImage;
// 非识别区域颜色 默认RGBA(0, 0, 0, 0.5)
@property (nonatomic, strong) UIColor *backAreaColor;

// 开启扫描动画
- (void)startScanAnimation;
// 结束扫描动画
- (void)stopScanAnimation;

// 正宗处理扫描到的结果
- (void)handlingResultsOfScan;
// 完成扫描结果处理
- (void)finishedHandle;

// 是否显示闪光灯开关
- (void)showFlashSwitch:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
