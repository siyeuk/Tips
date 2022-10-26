//
//  MTDistanceC.m
//  MT_Tips
//
//  Created by lss on 2022/10/25.
//

#import "MTDistanceC.h"

@interface MTDistanceC ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation MTDistanceC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"距离传感器";
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 60)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:20];
    self.label.text = @"贴近话筒即可检测";
    [self.view addSubview:self.label];
    
    [self distanceSensor];
    // Do any additional setup after loading the view.
}
//距离传感器 感应是否有其他物体靠近屏幕,iPhone手机中内置了距离传感器，位置在手机的听筒附近，当我们在打电话或听微信语音的时候靠近听筒，手机的屏幕会自动熄灭，这就靠距离传感器来控制
- (void)distanceSensor{
    // 打开距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    
    // 通过通知监听有物品靠近还是离开
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
}
- (void)proximityStateDidChange:(NSNotification *)noti{
    if ([UIDevice currentDevice].proximityState) {
        self.label.text = @"有东西靠近";
    } else {
        self.label.text = @"有物体离开";
    }
}
- (void)dealloc{
    // 关闭距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    
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
