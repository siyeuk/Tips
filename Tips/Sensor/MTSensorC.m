//
//  MTSensorC.m
//  MT_Tips
//
//  Created by lss on 2022/10/25.
//

#import "MTSensorC.h"
#import "MTFaceFingerC.h"
#import "MTMotionC.h"
#import "MTDistanceC.h"
#import "MTLightSensitiveC.h"
#import "MTCompassC.h"
#import "MTGyroscopeC.h"
#import "MTAccelerometerC.h"

@interface MTSensorC ()

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *classArray;

@end

@implementation MTSensorC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"指纹 人脸识别",
                        @"运动传感器 加速计 陀螺仪",
                        @"距离传感器",
                        @"环境光感",
                        @"指南针",
                        @"陀螺仪",
                        @"加速计 物理学"];
    }
    return _dataSource;
}
- (NSArray *)classArray{
    if (!_classArray) {
        _classArray = @[[MTFaceFingerC class],
                        [MTMotionC class],
                        [MTDistanceC class],
                        [MTLightSensitiveC class],
                        [MTCompassC class],
                        [MTGyroscopeC class],
                        [MTAccelerometerC class]];
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
            
        default:
            [self.navigationController pushViewController:vc animated:YES];
            break;
    }
    //    [self.navigationController pushViewController:vc animated:YES];
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
