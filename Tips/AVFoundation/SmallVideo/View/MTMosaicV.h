//
//  MTMosaicV.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 马赛克类型
typedef NS_ENUM(NSUInteger, MTMosaicType) {
    /// 方块马赛克
    MTMosaicTypeSquare,
    /// 画笔涂抹
    MTMosaicTypePaintbrush
};

/// 马赛克 画板
@interface MTMosaicV : UIView

/// 马赛克类型
@property (nonatomic, assign) MTMosaicType mosaicType;
/// 马赛克方块大小  默认15
@property (nonatomic, assign) CGFloat squareWidth;
/// 画笔涂抹大小   默认 (50, 50)
@property (nonatomic, assign) CGSize paintSize;
/// 正在涂抹
@property (nonatomic, readonly) BOOL isBrushing;
/// 开始涂抹
@property (nonatomic, copy) void(^brushBegan)(void);
/// 涂抹结束
@property (nonatomic, copy) void(^brushEnded)(void);
///某个点的颜色
@property (nonatomic, copy) UIColor *(^brushColor)(CGPoint point);

/// 数据
@property (nonatomic, strong) NSDictionary *data;

/// 是否可撤销
- (BOOL)canBack;
// 撤销
- (void)goBack;
/// 清空画板 不可恢复
- (void)clear;

@end

NS_ASSUME_NONNULL_END
