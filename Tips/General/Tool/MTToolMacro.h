//
//  MTToolMacro.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#ifndef MTToolMacro_h
#define MTToolMacro_h

/// 屏幕宽高
#define MT_kScreenWidth [UIScreen mainScreen].bounds.size.width
#define MT_kScreenHeight [UIScreen mainScreen].bounds.size.height

/** 判断是否为iPhone */
#define isiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/** 判断是否是iPad */
#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
/** 判断是否为iPod */
#define isiPod ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

//Get the OS version.       判断操作系统版本
#define MT_IOSVERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define MT_CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define MT_CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


#pragma mark - Helper 辅助方法 -
/// 弱引用对象
#define MT_WeakSelf __weak typeof(self) weakSelf = self;

///主线程操作
#define MT_DISPATCH_ON_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(),mainQueueBlock);
#define MT_GCDWithGlobal(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MT_GCDWithMain(block) dispatch_async(dispatch_get_main_queue(),block)

///NSUserDefaults 存储
#define MT_UserDefaultSetObjectForKey(__VALUE__,__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}
///NSUserDefaults     获得存储的对象
#define MT_UserDefaultObjectForKey(__KEY__)  [[NSUserDefaults standardUserDefaults] objectForKey:__KEY__]
///NSUserDefaults      删除对象
#define MT_UserDefaultRemoveObjectForKey(__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

/** 快速查询一段代码的执行时间 */
/** 用法
 MT_StartTime
 do your work here
 MT_EndDuration
 */
#define MT_StartTime NSDate *startTime = [NSDate date]
#define MT_EndDuration -[startTime timeIntervalSinceNow]

// STRING容错机制
#define MT_IS_NULL(x)                    (!x || [x isKindOfClass:[NSNull class]])
#define MT_IS_EMPTY_STRING(x)            (MT_IS_NULL(x) || [x isEqual:@""] || [x isEqual:@"(null)"])
#define MT_DEFUSE_EMPTY_STRING(x)        (!MT_IS_EMPTY_STRING(x) ? x : @"")


//沙盒目录
///获取沙盒主目录路径
#define MT_HomeDir  NSHomeDirectory();
/// 获取Documents目录路径
#define MT_DocumentDir  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
/// 获取Library的目录路径
#define MT_LibraryDir  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
/// 获取Caches目录路径
#define MT_CachesDir  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
/// 获取tmp目录路径
#define MT_TmpDir  NSTemporaryDirectory()

#pragma mark - Color 颜色 -
/// 随机颜色
#define MT_UIColorFromRandomColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0]
/// rgb颜色
#define MT_UIColorFromRGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
/// 16进制 颜色
#define MT_UIColorFromHex(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#pragma mark - Log 打印日志 -
/// 打印
#ifdef DEBUG
#   define NSLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
#   define MT_Log(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define MT_NSLog(...) printf("%f %s %ld :%s\n",[[NSDate date]timeIntervalSince1970],strrchr(__FILE__,'/'),[[NSNumber numberWithInt:__LINE__] integerValue],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#   define NSLog(fmt, ...)
#   define MT_Log(...)
#   define MT_NSLog(...)
#endif

//---------------------- Shader 着色器 ----------------------------
//#x 将参数x字符串化
#define STRINGIZE(x)    #x
#define STRINGIZE2(x)    STRINGIZE(x)
#define Shader_String(text) @ STRINGIZE2(text)



#endif /* MTToolMacro_h */
