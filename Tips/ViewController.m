//
//  ViewController.m
//  MT_Tips
//
//  Created by lss on 2022/10/10.
//

#import "ViewController.h"
#import "MTAVListC.h"
#import "MTSensorC.h"
#import "MTMediaC.h"

#import "MTOpenGLC.h"

#import "MTOtherTBVC.h"

#import <MediaPlayer/MediaPlayer.h>

#import "MTExcelManager.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *classArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iOS";
    
    
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    appearance.backgroundColor = [UIColor whiteColor]; //背景色
    appearance.shadowColor = UIColor.clearColor; //阴影
    
    self.navigationController.navigationBar.standardAppearance = appearance;
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    
    self.navigationController.navigationBar.translucent = NO;
    
//    MTExcelManager *maneger = [[MTExcelManager alloc] init];
//    [maneger createExcelWithName:@"ok"];
//    [maneger write:@"00000000" location:MTLocationMake(0, 0)];
//    [maneger write:@"11111111" location:MTLocationMake(1, 0)];
//    [maneger write:@"22222222" location:MTLocationMake(2, 0)];
//    [maneger write:@"33333333" location:MTLocationMake(3, 0)];
//    [maneger write:@"44444444" location:MTLocationMake(4, 0)];
//    [maneger write:@"55555555" location:MTLocationMake(5, 0)];
//    [maneger write:@"66666666" location:MTLocationMake(6, 0)];
//
//    [maneger write:@"qqqqqqqq" merge:MTAeraMake(0, 1, 0, 5)];
//    [maneger write:@"wwwwwwww" merge:MTAeraMake(1, 1, 1, 5)];
//    [maneger write:@"eeeeeeee" merge:MTAeraMake(2, 1, 2, 5)];
//    [maneger write:@"rrrrrrrr" merge:MTAeraMake(3, 1, 3, 5)];
//    [maneger write:@"tttttttt" merge:MTAeraMake(4, 1, 4, 5)];
//    [maneger write:@"yyyyyyyy" merge:MTAeraMake(5, 1, 5, 5)];
//    [maneger write:@"uuuuuuuu" merge:MTAeraMake(5, 1, 5, 5)];
//
//    [maneger save];
//
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"AVFoundation音视频相关",
                        @"传感器集锦",
                        @"视频处理相关",
                        @"OpenGL-ES学习",
                        @"Ohters"];
    }
    return _dataSource;
}
- (NSArray *)classArray{
    if (!_classArray) {
        _classArray = @[[MTAVListC class],
                        [MTSensorC class],
                        [MTMediaC class],
                        [MTOpenGLC class],
                        [MTOtherTBVC class]];
    }
    return _classArray;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = [[self.classArray[indexPath.row] alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
