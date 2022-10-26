//
//  MTScanResultC.m
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import "MTScanResultC.h"
#import "MTScanTool.h"


@interface MTScanResultC ()

@property (nonatomic, strong) UITextView *label;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MTScanResultC

- (void)viewDidLoad {
    [super viewDidLoad];
   _label = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    _label.textColor = [UIColor blackColor];
    _label.font = [UIFont systemFontOfSize:16];
    _label.text = self.resultString;
    [self.view addSubview:_label];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"生成" style:UIBarButtonItemStylePlain target:self action:@selector(createScan)];
    
    // Do any additional setup after loading the view.
}
- (void)createScan{
    [self.label resignFirstResponder];
   self.imageView.image = [MTScanTool createQRCodeWithString:_label.text size:CGSizeMake(200, 200) backColor:[UIColor whiteColor] frontColor:[UIColor orangeColor] centerImage:nil];
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.0 - 100, 200, 200, 200)];
        [self.view addSubview:_imageView];
    }
    return _imageView;
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
