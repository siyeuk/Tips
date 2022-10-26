//
//  MTSystemAppInfo.h
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MTAuthorizationStatus) {
    MTAuthorizationStatusUnknow = -1, //未知的
    MTAuthorizationStatusNotDetermined = 0, //用户还没有选择过(第一次) 这时会自动出现系统询问授权弹窗，之后不会
    MTAuthorizationStatusRestricted,  //家长控制，限制用户授权的权限
    MTAuthorizationStatusDenied,    //用户拒绝授权
    MTAuthorizationStatusAuthorized,  //已授权
    MTAuthorizationStatusAuthorizedAlways,  //始终都授权，比如定位，蓝牙
    MTAuthorizationStatusAuthorizedWhenInUse,  //仅当应用使用时授权 比如定位
    MTAuthorizationStatusProvisional,   //临时授权，用完一次即权利解除，下次再申请
    MTAuthorizationStatusUnsupported,   //该硬件不支持授权的功能，比如蓝牙、FaceID、摄像头，设备可能不支持
    MTAuthorizationStatusOff          //请求授权的功能处于关闭状态，比如蓝牙
};

@interface MTSystemAppInfo : NSObject

#pragma mark - System info -
///获取手机型号 iPhone 8...
+ (NSString *)iphoneType;
///获取手机系统版本 13.4
+ (NSString *)systemVersion;
///获取设备类型  iPhone/iPad/iPod touch
+ (NSString *)deviceModel;
///根据地区语言返回设备类型字符串 （国际化区域名称）
+(NSString *)localDeviceModel;
///操作系统名称 iOS
+ (NSString *)systemName;
///获取用户手机别名  用户定义的名称 通用-关于本机-名称  wsl的iphone
+ (NSString *)userPhoneName;
///设备唯一标识的字母数字字符串 但如果用户重新安装，那么这个 UUID 就会发生变化。 C5668446-C443-4898-A213-209AECE3626C
+ (NSString *)uuidString;
///是否是iPhoneX系列/刘海屏
+ (BOOL)isIPhoneXSeries;
/// 获取电话运营商信息
+ (NSString *)telephonyInfo;
/// 获取网络类型
+(NSString*)networkType;
///获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

#pragma mark - Device info -
///获取APP名字  SLTips
+ (NSString *)appName;
///获取APP bundle id    com.wsl2ls.tips
+ (NSString *)appBundleId;
///获取当前App版本号 1.1.0
+ (NSString *)appVersion;
///获取当前App编译版本号 1
+ (NSString *)appBuild;

#pragma mark - 权限相关 -
///检查相册访问权限  handler 用户授权结果的回调
+ (MTAuthorizationStatus)checkPhotoLibraryAuthorization:(void(^)(MTAuthorizationStatus status))handler;

///检查定位权限
+ (MTAuthorizationStatus)checkLocationAuthorization;

///检查相机/摄像头权限
+ (MTAuthorizationStatus)checkCameraAuthorization:(void(^)(MTAuthorizationStatus status))handler;

///检查话筒/麦克风权限
+ (MTAuthorizationStatus)checkMicrophoneAuthorization:(void(^)(MTAuthorizationStatus status))handler;

///检测通讯录权限
+ (MTAuthorizationStatus)checkContactsAuthorization:(void(^)(MTAuthorizationStatus status))handler;

///检测日历权限
+ (MTAuthorizationStatus)checkCalendarAuthorization:(void(^)(MTAuthorizationStatus status))handler;

///检测提醒事项权限
+ (MTAuthorizationStatus)checkRemindAuthorization:(void(^)(MTAuthorizationStatus status))handler;

///检测蓝牙权限
- (void)checkBluetoothAuthorization;
///CBCentralManagerDelegate
//- (void)centralManagerDidUpdateState:(CBCentralManager *)central;

///请求FaceID权限
+ (void)checkFaceIDAuthorization;


@end

NS_ASSUME_NONNULL_END
