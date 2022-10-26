//
//  MTFaceFingerC.m
//  MT_Tips
//
//  Created by lss on 2022/10/25.
//

#import "MTFaceFingerC.h"
#import <LocalAuthentication/LocalAuthentication.h>
// 面容解锁需要plist里面配置 Privacy - Face ID Usage Description


@interface MTFaceFingerC ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation MTFaceFingerC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 60)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:20];
    self.label.text = @"点击屏幕触发";
    [self.view addSubview:self.label];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self fingerVerification];
}
// 是否支出Touch ID
- (void)fingerVerification{
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        self.label.text = @"iOS 8.0以后才支持指纹识别";
        return;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        self.label.text = @"iOS 11.0以后才支持面容识别!";
        return;
    }
    //IOS11之后如果支持faceId也是走同样的逻辑，faceId和TouchId只能选一个
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持 localizedReason为alert弹框的message内容
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证指纹/面容" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                [self updateLabelText:@"验证通过"];
            } else {
                NSLog(@"验证失败:%@",error.description);
                // -1: 连续三次指纹识别错误
                // -2: 在TouchID对话框中点击了取消按钮
                // -3: 在TouchID对话框中点击了输入密码按钮
                // -4: TouchID对话框被系统取消，例如按下Home或者电源键
                // -8: 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                switch (error.code) {
                    case LAErrorSystemCancel:{
                        //系统取消授权，如其他APP切入
                        [self updateLabelText:@"系统取消授权，如其他APP切入"];
                        break;
                    }
                    case LAErrorUserCancel:{
                        //用户取消验证Touch ID
                        [self updateLabelText:@"用户取消验证"];
                        break;
                    }
                    case LAErrorAuthenticationFailed:{
                        //授权失败
                        [self updateLabelText:@"授权失败"];
                        break;
                    }
                    case LAErrorPasscodeNotSet:{
                        //系统未设置密码
                        [self updateLabelText:@"系统未设置密码"];
                        break;
                    }
                    case LAErrorBiometryNotAvailable:{
                        //设备Touch ID不可用，例如未打开
                        [self updateLabelText:@"设备Touch ID不可用，例如未打开"];
                        break;
                    }
                    case LAErrorBiometryNotEnrolled:{
                        //设备Touch ID不可用，用户未录入
                        [self updateLabelText:@"设备Touch ID不可用，用户未录入"];
                        break;
                    }
                    case LAErrorUserFallback:{
                        [self updateLabelText:@"用户选择输入密码，切换主线程处理"];
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            
                        }];
                        break;
                    }
                    default:{
                        [self updateLabelText:@"其他情况，切换主线程处理"];
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                            
                        }];
                        break;
                    }
                }
            }
        }];
    }else{
        //  -8 : 由于五次识别错误TouchID已经被锁定,请前往设置界面重新启用
        switch (error.code) {
            case LAErrorBiometryNotEnrolled:
                [self updateLabelText:@"错误:未注册"];
                break;
            case LAErrorPasscodeNotSet:
                [self updateLabelText:@"错误:设置密码"];
                break;
            default:
                [self updateLabelText:@"错误:不可用"];
                break;
        }
    }
}

- (void)updateLabelText:(NSString *)text{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.label.text = text;
    }];
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
