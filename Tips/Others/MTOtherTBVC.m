//
//  MTOtherTBVC.m
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import "MTOtherTBVC.h"
#import "MTUnusedResourceC.h"
#import "MTExcelVC.h"
#import "MTCalculatorC.h"

#import "MTPanoramicPlayerC.h"

@interface MTOtherTBVC ()

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *classArray;

@end

@implementation MTOtherTBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"ipa瘦身之扫描无用资源",
                        @"文件存Excel",
                        @"计算",
                        @"全景播放器"];
    }
    return _dataSource;
}
- (NSArray *)classArray{
    if (!_classArray) {
        _classArray = @[[MTUnusedResourceC class],
                        [MTExcelVC class],
                        [MTCalculatorC class],
                        [MTPanoramicPlayerC class]];
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
}

@end
