//
//  MTAlertView.m
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import "MTAlertView.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation MTAlertView

+ (void)showAlertViewWithText:(NSString *)text delayHid:(NSTimeInterval)delay{
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    progressHUD.animationType = MBProgressHUDAnimationFade;
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.label.text = text;
    progressHUD.label.numberOfLines = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:progressHUD];
    [progressHUD showAnimated:YES];
    [progressHUD hideAnimated:YES afterDelay:delay];
}

@end
