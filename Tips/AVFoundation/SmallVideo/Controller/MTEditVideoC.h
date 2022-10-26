//
//  MTEditVideoC.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 拍摄完毕后 编辑
@interface MTEditVideoC : UIViewController

/// 当前拍摄的视频路径
@property (nonatomic, strong) NSURL *videoPath;

@end

NS_ASSUME_NONNULL_END
