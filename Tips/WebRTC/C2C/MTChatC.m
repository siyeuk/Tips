//
//  MTChatC.m
//  Tips
//
//  Created by lss on 2022/11/10.
//

#import "MTChatC.h"

@interface MTChatC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MTChatC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@"服务器连接状态:", @"本地SDP状态:", @"远程SDP状态:", @"本地Candidate数量:", @"远程Candidate数量:", @"WebRTC连接状态:", @"静音", @"扬声器", @"点击以下进行连接", @"先发送offer", @"再发送answer", @"点击以下进行通信", @"发送文字", @"进入视频直播"];
    
    CGFloat width = self.view.bounds.size.width / 2 ;
  
    UIButton *offerBtn = [self createButton:@"发送offer" frame:CGRectMake(20, 0, width - 40, 40) font:[UIFont systemFontOfSize:16] backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] target:@selector(offerBtnClicked)];
     offerBtn.layer.cornerRadius = 20;
     [self.view addSubview:offerBtn];
    
    UIButton *answerBtn = [self createButton:@"发送answer" frame:CGRectMake(width + 20, 0, width - 40, 40) font:[UIFont systemFontOfSize:16] backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] target:@selector(answerBtnClicked)];
    answerBtn.layer.cornerRadius = 30;
     [self.view addSubview:answerBtn];
    
    UIButton *sendText = [self createButton:@"发送文字" frame:CGRectMake(100, 100, self.view.mt_width - 200, 60) font:[UIFont systemFontOfSize:16] backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] target:@selector(sendTextClicked)];
    sendText.layer.cornerRadius = 30;
     [self.view addSubview:sendText];
    // Do any additional setup after loading the view.
}
- (void)offerBtnClicked{
    
}
- (void)answerBtnClicked{
    
}
- (void)sendTextClicked{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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
