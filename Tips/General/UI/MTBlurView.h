//
//  MTBlurView.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 高斯模糊视图
@interface MTBlurView : UIView

//高斯模糊
@property (nonatomic, strong) UIVisualEffectView *blurView;

@end

NS_ASSUME_NONNULL_END
