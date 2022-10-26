//
//  MTAccelerometerC.m
//  Tips
//
//  Created by lss on 2022/10/26.
//

#import "MTAccelerometerC.h"
#import "MTBezierPathV.h"
#import "MTBallV.h"

@interface MTAccelerometerC ()

@end

@implementation MTAccelerometerC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加速计 滚动小球";
    [self acceleratorBall];
    // Do any additional setup after loading the view.
}
// 滚动小球 仿真物理学  加速计
- (void)acceleratorBall{
    NSArray *array = @[[UIImage imageNamed:@"ball.png"],[UIImage imageNamed:@"eyes.png"]];
    
    MTBezierPathV *backView = [[MTBezierPathV alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - [UIDevice mt_navigationFullHeight])];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    MTBallV *ballV1 = [[MTBallV alloc] initWithFrame:CGRectMake(30, 300, 30, 30) image:array[1]];
    [backView addSubview:ballV1];
    [ballV1 starMotion];
    
    MTBallV *ballV2 = [[MTBallV alloc] initWithFrame:CGRectMake(230, 300, 30, 30) image:array[1]];
    [backView addSubview:ballV2];
    [ballV2 starMotion];
    
    MTBallV *ballV3 = [[MTBallV alloc] initWithFrame:CGRectMake(100, 64, 40, 40) image:array[0]];
    [backView addSubview:ballV3];
    [ballV3 starMotion];
    
    MTBallV *ballV4 = [[MTBallV alloc] initWithFrame:CGRectMake(100, 64, 28, 28) image:array[0]];
    [backView addSubview:ballV4];
    [ballV4 starMotion];
    
    MTBallV *ballV5 = [[MTBallV alloc] initWithFrame:CGRectMake(100, 500, 28, 28) image:array[0]];
    [backView addSubview:ballV5];
    [ballV5 starMotion];
    
    MTBallV *ballV6 = [[MTBallV alloc] initWithFrame:CGRectMake(100, 500, 40, 40) image:array[0]];
    [backView addSubview:ballV6];
    [ballV6 starMotion];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
