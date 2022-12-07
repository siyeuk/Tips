//
//  MTChangeLanuchImage.m
//  Tips
//
//  Created by lss on 2022/12/7.
//

#import "MTChangeLanuchImage.h"
#import "MTLaunchImageHelper.h"

@interface MTChangeLanuchImage ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    BOOL _autoExit;
    UILabel *_infoLabel;
}
@end

@implementation MTChangeLanuchImage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"启动图替换";
    _autoExit = YES;
    CGFloat minX = self.view.bounds.size.width / 2 - 60;
    UIButton *autoExitBtn = [self createButton:@"自动退出" frame:CGRectMake(minX, 70, 120, 40) font:[UIFont systemFontOfSize:16] backgroundColor:nil titleColor:[UIColor blackColor] target:@selector(autoExit:)];
    [autoExitBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    [autoExitBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateSelected];
    [self.view addSubview:autoExitBtn];
    
    UIButton *photo = [self createButton:@"从相册中选" frame:CGRectMake(minX, 120, 120, 50) font:[UIFont systemFontOfSize:16] backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] target:@selector(openAlbum)];
    photo.layer.cornerRadius = 5;
    [self.view addSubview:photo];
    
    UIButton *xib = [self createButton:@"使用xib替换" frame:CGRectMake(minX, 190, 120, 50) font:[UIFont systemFontOfSize:16] backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] target:@selector(useSB)];
    xib.layer.cornerRadius = 5;
    [self.view addSubview:xib];
    
    UIButton *reset = [self createButton:@"恢复" frame:CGRectMake(minX, 260, 120, 50) font:[UIFont systemFontOfSize:16] backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] target:@selector(reset)];
    reset.layer.cornerRadius = 5;
    [self.view addSubview:reset];
    // Do any additional setup after loading the view.
}
- (void)autoExit:(UIButton *)button{
    _autoExit = button.isSelected;
    button.selected = !button.isSelected;
}
- (void)openAlbum{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}
- (void)useSB{
    UIImage *portraitImage = [MTLaunchImageHelper snapshotStoryboardForPortrait:@"DynamicLaunchScreen"];
    UIImage *landscapeImage = [MTLaunchImageHelper snapshotStoryboardForLandscape:@"DynamicLaunchScreen"];
    [MTLaunchImageHelper changePortraitLaunchImage:portraitImage landscapeLaunchImage:landscapeImage];
    [self exitIfNeeded];
}
- (void)reset{
    UIImage *portraitImage = [MTLaunchImageHelper snapshotStoryboardForPortrait:@"LaunchScreen"];
    UIImage *landscapeImage = [MTLaunchImageHelper snapshotStoryboardForLandscape:@"LaunchScreen"];
    [MTLaunchImageHelper changePortraitLaunchImage:portraitImage landscapeLaunchImage:landscapeImage];
    [self exitIfNeeded];
}
- (void)exitIfNeeded{
    if (_autoExit) {
        self.view.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            exit(0);
        });
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            exit(0);
        });
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    [MTLaunchImageHelper changePortraitLaunchImage:selectedImage landscapeLaunchImage:selectedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self exitIfNeeded];
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
