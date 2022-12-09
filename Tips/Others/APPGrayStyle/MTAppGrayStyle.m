//
//  MTAppGrayStyle.m
//  Tips
//
//  Created by lss on 2022/12/9.
//

#import "MTAppGrayStyle.h"

@interface MTAppGrayStyleCoverView : UIView

@end

@implementation MTAppGrayStyleCoverView

+ (NSHashTable *)allCoverViews{
    static NSHashTable *array;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = [NSHashTable weakObjectsHashTable];
    });
    return array;
}
+ (void)showInMaskerView:(UIView *)maskerView{
    if (@available(iOS 13, *)) {
        for (UIView *subView in maskerView.subviews) {
            if ([subView isKindOfClass:MTAppGrayStyleCoverView.class]) {
                return;
            }
        }
        MTAppGrayStyleCoverView *coverView = [[self alloc] initWithFrame:maskerView.bounds];
        coverView.userInteractionEnabled = NO;
        coverView.backgroundColor = [UIColor lightGrayColor];
        coverView.layer.compositingFilter = @"saturationBlendMode";
        coverView.layer.zPosition = FLT_MAX;
        [maskerView addSubview:coverView];
        
        [self.allCoverViews addObject:coverView];
    }
}

@end

@implementation MTAppGrayStyle

/// 开启全局变灰
+ (void)open{
    NSAssert(NSThread.isMainThread, @"必须在主线程调用！");
    NSMutableSet *windows = [NSMutableSet set];
    [windows addObjectsFromArray:UIApplication.sharedApplication.windows];
    if (@available(iOS 13, *)) {
        for (UIWindowScene *scens in UIApplication.sharedApplication.connectedScenes) {
            if (![scens isKindOfClass:UIWindowScene.class]) {
                continue;
            }
            [windows addObjectsFromArray:scens.windows];
        }
        
    }
    for (UIWindow *window in windows) {
        NSString *className = NSStringFromClass(window.class);
        if (![className containsString:@"UIText"]){
            [MTAppGrayStyleCoverView showInMaskerView:window];
        }
    }
  
}

/// 关闭全局变灰
+ (void)close{
    NSAssert(NSThread.isMainThread, @"必须主线程调用");
    for (UIView *coverView in MTAppGrayStyleCoverView.allCoverViews) {
        [coverView removeFromSuperview];
    }
}

/// 添加灰色模式
+ (void)addToView:(UIView *)view{
    NSAssert(NSThread.isMainThread, @"必须在主线程调用！");
    [MTAppGrayStyleCoverView showInMaskerView:view];
}

/// 移除灰色模式
+ (void)removeFromView:(UIView *)view{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:MTAppGrayStyleCoverView.class]) {
            [subView removeFromSuperview];
        }
    }
}

@end
