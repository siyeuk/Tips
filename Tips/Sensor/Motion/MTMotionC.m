//
//  MTMotionC.m
//  MT_Tips
//
//  Created by lss on 2022/10/25.
//

#import "MTMotionC.h"
#import <CoreMotion/CoreMotion.h>
#import "UIImageView+Tranform3D.h"

@interface MTMotionC ()

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation MTMotionC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView1 = [self imagev];
    self.imageView1.frame = CGRectMake(40, 20, self.view.bounds.size.width - 80, 300);
    
    self.imageView2 = [self imagev];
    self.imageView2.frame = CGRectMake(40, 300 + 20 + 20, self.view.bounds.size.width - 80, 300);
    
    [self.view addSubview:self.imageView1];
    [self.view addSubview:self.imageView2];
    
    [self motion];
}

- (void)motion{
    self.motionManager = [[CMMotionManager alloc] init];
    // 判断是否能用
    if (!self.motionManager.isDeviceMotionAvailable) {
        NSLog(@"没有此功能");
        return;
    }
    //更新速率是100Hz
    self.motionManager.deviceMotionUpdateInterval = 0.1;
    //开始更新采集数据
    //需要时采集数据
    //[motionManager startDeviceMotionUpdates];
    //实时获取数据
    __weak typeof(self) weakSelf = self;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        //获取X的值
        double x = motion.gravity.x;
        //手机水平位置测试
        //判断y是否小于0，大于等于-1.0
        if(motion.gravity.y < 0.0 && motion.gravity.y >= -1.0){
            //设置旋转
            [weakSelf.imageView1 setRotation:80 * motion.gravity.y];
        }else if (motion.gravity.z * -1 > 0 && motion.gravity.z * -1 <= 1.0){
            [weakSelf.imageView1 setRotation:80 - (80 * motion.gravity.z * -1)];
        }
        //X、Y方向上的夹角
        double rotation = atan2(motion.gravity.x, motion.gravity.y) - M_PI;
        NSLog(@"%.2f",rotation);
        //图片始终保持垂直方向
//        weakSelf.imageView2.transform = CGAffineTransformMakeRotation(rotation);
    }];
    
    
}
- (void)dealloc{
    [self.motionManager stopMagnetometerUpdates];
    self.motionManager = nil;
}

- (UIImageView *)imagev{
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face"]];
    img.backgroundColor = [UIColor blackColor];
    img.contentMode = UIViewContentModeScaleToFill;
    return img;
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
