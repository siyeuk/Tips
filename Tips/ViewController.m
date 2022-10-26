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
