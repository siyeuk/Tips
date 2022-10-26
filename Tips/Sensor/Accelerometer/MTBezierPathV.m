//
//  MTBezierPathV.m
//  Tips
//
//  Created by lss on 2022/10/26.
//

#import "MTBezierPathV.h"

@implementation MTBezierPathV

- (void)drawRect:(CGRect)rect{
    // 创建椭圆形路径对象
    [[UIColor blackColor] set];
    //眼圈1
    UIBezierPath * ellipsePath1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(30, 300, 130, 80)];
    ellipsePath1.lineWidth     = 5.f;
    ellipsePath1.lineCapStyle  = kCGLineCapRound;
    ellipsePath1.lineJoinStyle = kCGLineJoinRound;
    [ellipsePath1 stroke];
    //眼圈2
    UIBezierPath * ellipsePath2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(210, 300, 130, 80)];
    ellipsePath2.lineWidth     = 5.f;
    ellipsePath2.lineCapStyle  = kCGLineCapRound;
    ellipsePath2.lineJoinStyle = kCGLineJoinRound;
    [ellipsePath2 stroke];
    
    //鼻托
    UIBezierPath* nosePath1 = [UIBezierPath bezierPath];
    nosePath1.lineWidth     = 5.f;
    nosePath1.lineCapStyle  = kCGLineCapRound;
    nosePath1.lineJoinStyle = kCGLineJoinRound;
    [nosePath1 moveToPoint:CGPointMake(160, 340)];
    // 给定终点和控制点绘制贝塞尔曲线
    [nosePath1 addQuadCurveToPoint:CGPointMake(210, 340) controlPoint:CGPointMake(185, 320)];
    [nosePath1 stroke];
    
    //鼻子
    UIBezierPath* nosePath2 = [UIBezierPath bezierPath];
    nosePath2.lineWidth     = 5.f;
    nosePath2.lineCapStyle  = kCGLineCapRound;
    nosePath2.lineJoinStyle = kCGLineJoinRound;
    [nosePath2 moveToPoint:CGPointMake(180, 420)];
    // 给定终点和控制点绘制贝塞尔曲线
    [nosePath2 addQuadCurveToPoint:CGPointMake(180, 470) controlPoint:CGPointMake(130, 470)];
    [nosePath2 stroke];
    
    
    //嘴
    [[UIColor redColor] set];
    UIBezierPath* mouthPath = [UIBezierPath bezierPath];
    mouthPath.lineWidth     = 10.f;
    mouthPath.lineCapStyle  = kCGLineCapRound;
    mouthPath.lineJoinStyle = kCGLineJoinRound;
    [mouthPath moveToPoint:CGPointMake(100, 550)];
    // 给定终点和控制点绘制贝塞尔曲线
    [mouthPath addQuadCurveToPoint:CGPointMake(280, 550) controlPoint:CGPointMake(140, 620)];
    [mouthPath stroke];
    
    
    //眼镜腿1
    [[UIColor blackColor] set];
    UIBezierPath* legPath1 = [UIBezierPath bezierPath];
    legPath1.lineWidth     = 5.f;
    legPath1.lineCapStyle  = kCGLineCapRound;
    legPath1.lineJoinStyle = kCGLineJoinRound;
    [legPath1 moveToPoint:CGPointMake(30, 340)];
    // 给定终点和控制点绘制贝塞尔曲线
    [legPath1 addQuadCurveToPoint:CGPointMake(100, 100) controlPoint:CGPointMake(40, 100)];
    [legPath1 stroke];
    //眼镜腿2
    UIBezierPath* legPath2 = [UIBezierPath bezierPath];
    legPath2.lineWidth     = 5.f;
    legPath2.lineCapStyle  = kCGLineCapRound;
    legPath2.lineJoinStyle = kCGLineJoinRound;
    [legPath2 moveToPoint:CGPointMake(340, 340)];
    // 给定终点和控制点绘制贝塞尔曲线
    [legPath2 addQuadCurveToPoint:CGPointMake(410, 100) controlPoint:CGPointMake(350, 100)];
    [legPath2 stroke];
    
    
    
    
    [super drawRect:rect];
}

@end
