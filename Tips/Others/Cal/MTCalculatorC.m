//
//  MTCalculatorC.m
//  Tips
//
//  Created by lss on 2022/11/3.
//

#import "MTCalculatorC.h"

@interface MTCalculatorC (){
    BOOL _equal;
    NSMutableArray *_textFieldArray;
}
@end

@implementation MTCalculatorC

- (void)viewDidLoad {
    [super viewDidLoad];
    _equal =  YES;
    _textFieldArray = [NSMutableArray array];
    
    NSArray *titleArray = @[@"type",@"total",@"month",@"rate"];
    for (NSInteger index = 0; index < titleArray.count; index++) {
        UILabel *label = [self titleLabel:titleArray[index]];
        label.frame = CGRectMake(10, 30 + index * 40, 70, 40);
        [self.view addSubview:label];
        if (index == 0) {
            UISwitch *swit = [[UISwitch alloc] init];
            swit.frame = CGRectMake(self.view.bounds.size.width - 80, 30 + index * 40, 70, 40);
            [swit setOn:YES];
            [swit addTarget:self action:@selector(switchValue:) forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:swit];
        }else{
            UITextField *fiel = [self textField];
            fiel.frame = CGRectMake(self.view.bounds.size.width - 80, 30 + index * 40, 70, 40);
            [self.view addSubview:fiel];
            [_textFieldArray addObject:fiel];
        }
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(60, 80 + titleArray.count * 40, self.view.bounds.size.width - 120, 50);
    button.backgroundColor = [UIColor orangeColor];
    button.layer.cornerRadius = 25;
    [button addTarget:self action:@selector(buttonBeClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    [(UITextField *)_textFieldArray[0] setText:@"650000"];
    [(UITextField *)_textFieldArray[1] setText:@"360"];
    [(UITextField *)_textFieldArray[2] setText:@"5.65"];
}
- (void)buttonBeClicked{
    double totalMoney = [[(UITextField *)_textFieldArray[0] text] doubleValue];
    double totalMonth = [[(UITextField *)_textFieldArray[1] text] doubleValue];
    double yearRate = [[(UITextField *)_textFieldArray[2] text] doubleValue] / 100.0;
    double monthRate = yearRate / 12.0;
    
    if (_equal) {
        double monthMoney = totalMoney * monthRate * pow((1 + monthRate), totalMonth) / ((pow((1 + monthRate), totalMonth) - 1));
        
        NSInteger monthInt = (NSInteger)totalMonth;
        
        double currentMoney = totalMoney;
        
        double tttt = 0;
        
        for (NSInteger index = 0; index < monthInt; index++) {
            double interest = currentMoney * monthRate;
            double money = monthMoney - interest;
            NSLog(@"%ld %.2f %.2f %.2f",index + 1, monthMoney, interest, money);
            tttt += money;
            currentMoney -= money;
            
        }
    }else{
        
        
        double montyMoney = totalMoney / totalMonth;
        double currentMoney = totalMoney;
        
        NSInteger monthInt = (NSInteger)totalMonth;
        for (NSInteger index = 0; index < monthInt; index++) {
            NSLog(@"%ld  %.2f  %.2f  %.2f",index + 1, currentMoney * monthRate + montyMoney, currentMoney * monthRate, montyMoney);
            currentMoney -= montyMoney;
        }
    }
}
- (void)switchValue:(UISwitch *)swit{
    _equal = swit.isOn;
}

- (UILabel *)titleLabel:(NSString *)text{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = text;
    return label;
}
- (UITextField *)textField{
    UITextField *textF = [[UITextField alloc] init];
    textF.font = [UIFont systemFontOfSize:14];
    textF.textAlignment = NSTextAlignmentCenter;
    textF.borderStyle = UITextBorderStyleRoundedRect;
    return textF;
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
