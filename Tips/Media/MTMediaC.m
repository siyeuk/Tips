//
//  MTMediaC.m
//  Tips
//
//  Created by lss on 2022/10/26.
//

#import "MTMediaC.h"
#import "MTVideoSpeedC.h"
#import "MTMixVideoC.h"

@interface MTMediaC ()

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *classArray;

@end

@implementation MTMediaC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"调整视频速度",
                        @"合并视频",
                        @"AVFoundation 原生二维码扫描识别和生成",
                        @"AVFoundation 相机拍摄和编辑功能",
                        @"AVFoundation 实时滤镜拍摄和导出",
                        @"VideoToolBox和AudioToolBox音视频编解码",
        @"GPUImage 框架"];
    }
    return _dataSource;
}
- (NSArray *)classArray{
    if (!_classArray) {
        _classArray = @[[MTVideoSpeedC class],
                        [MTMixVideoC class],
                        [MTVideoSpeedC class],
                        [MTVideoSpeedC class],
                        [MTVideoSpeedC class],
                        [MTVideoSpeedC class],
        [MTVideoSpeedC class]];
    }
    return _classArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIViewController *vc = [[self.classArray[indexPath.row] alloc] init];
    switch (indexPath.row) {
//        case 0:
//        case 3:
//        case 4:
//        case 6:
//            vc.modalPresentationStyle = UIModalPresentationFullScreen;
//            [self presentViewController:vc animated:YES completion:nil];
//            break;
//            
        default:
            [self.navigationController pushViewController:vc animated:YES];
            break;
    }
    //    [self.navigationController pushViewController:vc animated:YES];
}

@end
