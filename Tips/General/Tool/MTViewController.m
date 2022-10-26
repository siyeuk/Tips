//
//  MTViewController.m
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import "MTViewController.h"

@interface MTViewController ()

@end

@implementation MTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (UILabel *)createLabelText:(NSString *)text frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    return label;
}
- (UITextField *)createTextField:(NSString *)placeholder frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.font = font;
    textField.textColor = textColor;
    return textField;
}
- (UIButton *)createButton:(NSString *)title frame:(CGRect)frame font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)color target:(SEL)target{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = font;
    button.backgroundColor = backgroundColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];
    return button;
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
