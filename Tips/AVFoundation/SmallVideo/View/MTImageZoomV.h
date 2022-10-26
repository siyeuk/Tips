//
//  MTImageZoomV.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MTImageZoomV;
@protocol MTImageZoomVDelegate <NSObject>
@optional
/// 开始移动图像位置
- (void)zoomViewDidBeginMoveImage:(MTImageZoomV *)zoomView;
/// 结束移动图像
- (void)zoomViewDidEndMoveImage:(MTImageZoomV *)zoomView;

@end

/// 缩放视图 用于图片编辑
@interface MTImageZoomV : UIScrollView

@property (nonatomic, strong) UIImage *image;
//
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id<MTImageZoomVDelegate> zoomViewDelegate;

@end

NS_ASSUME_NONNULL_END
