//
//  MTBallTool.h
//  Tips
//
//  Created by lss on 2022/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTBallTool : NSObject

// 参考视图,设置仿真范围
@property (nonatomic, weak) UIView *referenceView;

+ (instancetype)shareBallTool;
- (void)addAimView:(UIView *)ballView referenceView:(UIView *)referenceView;
- (void)stopMotionUpdates;

@end

NS_ASSUME_NONNULL_END
