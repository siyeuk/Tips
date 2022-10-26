//
//  MTBallV.m
//  Tips
//
//  Created by lss on 2022/10/26.
//

#import "MTBallV.h"
#import "MTBallTool.h"

@interface MTBallV ()

//@property (nonatomic, assign) UIDynamicItemCollisionBoundsType collisionBoundsType;

@end

@implementation MTBallV

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image{
    if (self = [super initWithFrame:frame]) {
        self.image = image;
        self.layer.cornerRadius = frame.size.width * 0.5;
        self.layer.masksToBounds = YES;
        // 圆形碰撞
//        self.collisionBoundsType = UIDynamicItemCollisionBoundsTypeEllipse;
    }
    return self;
}

- (void)starMotion{
    MTBallTool *ball = [MTBallTool shareBallTool];
    [ball addAimView:self referenceView:self.superview];
}

- (void)stopMotion{
    MTBallTool *ball = [MTBallTool shareBallTool];
    [ball stopMotionUpdates];
}

@end
