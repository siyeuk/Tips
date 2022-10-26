//
//  UIDevice+StateHeight.h
//  Tips
//
//  Created by lss on 2022/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (StateHeight)
 
/** 顶部安全区高度 **/
+ (CGFloat)mt_safeDistanceTop;
 
/** 底部安全区高度 **/
+ (CGFloat)mt_safeDistanceBottom;
 
/** 顶部状态栏高度（包括安全区） **/
+ (CGFloat)mt_statusBarHeight;
 
/** 导航栏高度 **/
+ (CGFloat)mt_navigationBarHeight;
 
/** 状态栏+导航栏的高度 **/
+ (CGFloat)mt_navigationFullHeight;
 
/** 底部导航栏高度 **/
+ (CGFloat)mt_tabBarHeight;
 
/** 底部导航栏高度（包括安全区） **/
+ (CGFloat)mt_tabBarFullHeight;


@end

NS_ASSUME_NONNULL_END
