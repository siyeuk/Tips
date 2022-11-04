//
//  MTExcelVC.m
//  Daily
//
//  Created by lss on 2022/10/27.
//

#import "MTExcelVC.h"
#import "MTExcelManager.h"

// 仅做测试使用
@interface TestModel : NSObject
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *item;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *way;
@property (nonatomic, copy) NSString *expend;
@property (nonatomic, copy) NSString *income;
@property (nonatomic, copy) NSString *remark;
@end
@implementation TestModel @end

@interface MTExcelVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MTExcelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = [NSMutableArray array];
    for (NSInteger index = 0; index < 100; index++) {
        TestModel *model = [[TestModel alloc] init];
        model.identity = [NSString stringWithFormat:@"identity %ld",index];
        model.item = [NSString stringWithFormat:@"item %ld",index];
        model.date = [NSString stringWithFormat:@"date %ld",index];
        model.createTime = [NSString stringWithFormat:@"createTime %ld",index];
        model.type = [NSString stringWithFormat:@"type %ld",index];
        model.way = [NSString stringWithFormat:@"way %ld",index];
        model.expend = [NSString stringWithFormat:@"expend %ld",index];
        model.income = [NSString stringWithFormat:@"income %ld",index];
        model.remark = [NSString stringWithFormat:@"remark %ld",index];
        [self.dataArray addObject:model];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.font = [UIFont systemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"点击屏幕开始转换,去文件里面查看";
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    
    // Do any additional setup after loading the view.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 标题样式
    MTExcelStyleModel *titleStyle = [[MTExcelStyleModel alloc] init];
    titleStyle.bold = YES;

    
    MTExcelManager *maneger = [[MTExcelManager alloc] init];
   int ret = [maneger createExcelWithName:@"ojbk"];
    if (ret == -1) {
        [self alert:@"少年,重名了"];
        return;
    }
    
    [maneger write:@"对账单" merge:MTAeraMake(0, 0, 0, 8)];
    
    NSArray *titleArray = @[@"identity",@"item",@"date",@"createTime",@"type",@"way",@"expend",@"income",@"remark"];
    for (int index = 0; index < titleArray.count; index++) {
        [maneger write:titleArray[index] location:MTLocationMake(1, index) style:titleStyle];
    }
    [maneger setColumnWidth:40 start:0 end:8];
    
    [maneger setRowHeight:20 row:0];
    [maneger setRowHeight:20 row:1];
    
    for (int i = 0; i < self.dataArray.count; i++) {
        TestModel *model = self.dataArray[i];
        for (int j = 0; j < titleArray.count; j++) {
            [maneger write:[model valueForKey:titleArray[j]] location:MTLocationMake(i+2, j)];
        }
        [maneger setRowHeight:20 row:i+2];
    }
    
    [maneger save];
    
    [self alert:nil];
}
- (void)alert:(NSString *_Nullable)text{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:text?text:@"去文件查看吧" message:text?text:@"取文件APP查看吧" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"..." style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}
//- (UITableView *)tableView{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//    }
//    return _tableView;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
