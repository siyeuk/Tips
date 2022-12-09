//
//  MTAppGrayStyleC.m
//  Tips
//
//  Created by lss on 2022/12/9.
//

#import "MTAppGrayStyleC.h"
#import "MTAppGrayStyle.h"

@interface MTAppGrayStyleC ()

@end

@implementation MTAppGrayStyleC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *open = [self createButton:@"open" frame:CGRectMake(100, 200, 100, 100) font:[UIFont systemFontOfSize:20] backgroundColor:[UIColor lightGrayColor] titleColor:[UIColor whiteColor] target:@selector(open)];
    [self.view addSubview:open];
    
    UIButton *close = [self createButton:@"close" frame:CGRectMake(100, 350, 100, 100) font:[UIFont systemFontOfSize:20] backgroundColor:[UIColor greenColor] titleColor:[UIColor whiteColor] target:@selector(close)];
    [self.view addSubview:close];
    // Do any additional setup after loading the view.
}
- (void)open{
    [MTAppGrayStyle open];
}
- (void)close{
    [MTAppGrayStyle close];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

*/

@end
