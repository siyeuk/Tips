//
//  MTWebRTCC.m
//  Tips
//
//  Created by lss on 2022/11/9.
//

#import "MTWebRTCC.h"
#import "MTChatC.h"
#import "MTGroupC.h"

@interface MTWebRTCC ()

@end

@implementation MTWebRTCC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"WebRTC";
    
   
    
   UIButton *button = [self createButton:@"单聊" frame:CGRectMake(100, 100, self.view.mt_width - 200, 60) font:[UIFont systemFontOfSize:16] backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] target:@selector(chatClicked)];
    button.layer.cornerRadius = 30;
    [self.view addSubview:button];
    
    UIButton *group = [self createButton:@"群聊" frame:CGRectMake(100, 300, self.view.mt_width - 200, 60) font:[UIFont systemFontOfSize:16] backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] target:@selector(groupBeClicked)];
    group.layer.cornerRadius = 30;
     [self.view addSubview:group];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.client.delegate = self;
}
- (void)chatClicked{
    MTChatC *chat = [[MTChatC alloc] init];
    [self.navigationController pushViewController:chat animated:YES];
}
- (void)groupBeClicked{
    MTGroupC *group = [[MTGroupC alloc] init];
    [self.navigationController pushViewController:group animated:YES];
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
