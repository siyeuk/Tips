//
//  MTScanC.m
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import "MTScanC.h"
#import "MTScanV.h"
#import "MTScanTool.h"
#import "MTScanResultC.h"

@interface MTScanC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) MTScanTool *scanTool;
@property (nonatomic, strong) MTScanV *scanView;

@end

@implementation MTScanC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"二维码/条码";
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(photoBtnClicked)],[[UIBarButtonItem alloc] initWithTitle:@"生成" style:UIBarButtonItemStylePlain target:self action:@selector(createScan)]];
    
    // 输出流视图
    UIView *preview = [[UIView alloc] initWithFrame:self.view.bounds];
    preview.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:preview];
    
 
    __weak typeof(self) weakSelf = self;
    
    MTScanV *scanView = [[MTScanV alloc] initWithFrame:self.view.bounds];
    scanView.scanRect = CGRectMake(60, 120, self.view.bounds.size.width - 2 * 60, self.view.bounds.size.width - 2 * 60);
    scanView.colorAngle = [UIColor greenColor];
    scanView.photoframeAngleH = 20;
    scanView.photoframeAngleW = 20;
    scanView.photoframeLineW = 2;
    scanView.isNeedLine = YES;
    scanView.lineColor = [UIColor whiteColor];
    scanView.backAreaColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    scanView.animationImage = [UIImage imageNamed:@"scanLine"];
    scanView.myQRCodeBlock = ^{
        
    };
    scanView.flashSwitchBlock = ^(BOOL status) {
        [weakSelf.scanTool openFlash:status];
    };
    [self.view addSubview:scanView];
    self.scanView = scanView;
   
    
    // 初始化扫描工具
    MTScanTool *scanTool = [[MTScanTool alloc] initWithPreview:preview scanFrame:self.scanView.scanRect];
    scanTool.scanFinishedBlock = ^(NSString * _Nullable scanString) {
        NSLog(@"扫描结果 %@",scanString);
        [weakSelf.scanView handlingResultsOfScan];
        MTScanResultC *result = [[MTScanResultC alloc] init];
        result.resultString = scanString;
        [weakSelf.navigationController pushViewController:result animated:YES];
    };
    scanTool.monitorLightBlock = ^(CGFloat brightness) {
//        NSLog(@"环境光感 %f",brightness);
        if (brightness < 0) {
            // 环境太暗，显示闪光灯开关按钮
            [weakSelf.scanView showFlashSwitch:YES];
        }else if (brightness > 0) {
            // 环境亮度可以,且闪光灯处于关闭状态时，隐藏闪光灯开关
            if (!weakSelf.scanTool.flashStatus) {
                [weakSelf.scanView showFlashSwitch:NO];
            }
        }
    };
    self.scanTool = scanTool;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scanTool startRuning];
    [self.scanView startScanAnimation];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.scanView stopScanAnimation];
    [self.scanView finishedHandle];
    [self.scanView showFlashSwitch:NO];
    [self.scanTool stopRuning];
}

- (void)createScan{
    MTScanResultC *result = [[MTScanResultC alloc] init];
    [self.navigationController pushViewController:result animated:YES];
}
- (void)photoBtnClicked{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController * _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }else{
        NSLog(@"不支持访问相册");
    }
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    //    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    MTScanResultC *result = [[MTScanResultC alloc] init];
    result.resultString = [MTScanTool scanImage:image];
    [self.navigationController pushViewController:result animated:YES];
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
