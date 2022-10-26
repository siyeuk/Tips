//
//  MTViewController.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTViewController : UIViewController

- (UILabel *)createLabelText:(NSString *)text frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor;
- (UITextField *)createTextField:(NSString *)placeholder frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor;
- (UIButton *)createButton:(NSString *)title frame:(CGRect)frame font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)color target:(SEL)target;

@end

NS_ASSUME_NONNULL_END
