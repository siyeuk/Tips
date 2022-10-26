//
//  MTSystemAppInfo.m
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import "MTSystemAppInfo.h"
// 手机型号头文件
#import "sys/utsname.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <Photos/Photos.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import <CoreLocation/CLLocationManager.h>
#import <UserNotifications/UserNotifications.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <EventKit/EventKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <LocalAuthentication/LocalAuthentication.h>

#define MT_IOS_CELLULAR    @"pdp_ip0"
#define MT_IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define MT_IP_ADDR_IPv4    @"ipv4"
#define MT_IP_ADDR_IPv6    @"ipv6"

@implementation MTSystemAppInfo

#pragma mark - System info -

///获取手机系统版本 15.0
+ (NSString *)systemVersion{
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    return systemVersion;
}
///获取设备类型  iPhone/iPad/iPod touch
+ (NSString *)deviceModel{
    NSString* deviceModel = [[UIDevice currentDevice] model];
    return deviceModel;
}
///根据地区语言返回设备类型字符串 （国际化区域名称）
+(NSString *)localDeviceModel{
    NSString* localizedModel = [[UIDevice currentDevice] localizedModel];
    return localizedModel;;
}
///操作系统名称 iOS
+ (NSString *)systemName{
    NSString* systemName = [[UIDevice currentDevice] systemName];
    return systemName;
}
///获取用户手机别名  用户定义的名称 通用-关于本机-名称  wsl的iphone
+ (NSString *)userPhoneName{
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    return userPhoneName;
}
///设备唯一标识的字母数字字符串 但如果用户重新安装，那么这个 UUID 就会发生变化。 C5668446-C443-4898-A213-209AECE3626C
+ (NSString *)uuidString{
    NSString *UUIDString = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    return UUIDString;
}
///是否是iPhoneX系列/刘海屏
+ (BOOL)isIPhoneXSeries{
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [self getKeyWindow];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}
+ (UIWindow *)getKeyWindow{
    UIWindow *keyWindow = nil;
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        keyWindow = [[UIApplication sharedApplication].delegate window];
    }else{
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *window in windows) {
            if (!window.hidden) {
                keyWindow = window;
                break;
            }
        }
    }
    return keyWindow;
}
/// 获取电话运营商信息
+ (NSString *)telephonyInfo{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    return mCarrier;
}
/// 获取网络类型
+(NSString*)networkType{
    /**
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyGPRS          __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyEdge          __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyWCDMA         __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyHSDPA         __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyHSUPA         __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyCDMA1x        __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyCDMAEVDORev0  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyCDMAEVDORevA  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyCDMAEVDORevB  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyeHRPD         __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyLTE           __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     **/
    //
    CTTelephonyNetworkInfo* info=[[CTTelephonyNetworkInfo alloc] init];
    if (@available(iOS 12.0, *)) {
        NSDictionary *dict= info.serviceCurrentRadioAccessTechnology;
        //        NSLog(@"%@",dict);
    } else {
    }
    NSString *networkType = info.currentRadioAccessTechnology;
    return networkType;
}
///获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" MT_IP_ADDR_IPv4, IOS_VPN @"/" MT_IP_ADDR_IPv6,*/ MT_IOS_WIFI @"/" MT_IP_ADDR_IPv4, MT_IOS_WIFI @"/" MT_IP_ADDR_IPv6, MT_IOS_CELLULAR @"/" MT_IP_ADDR_IPv4, MT_IOS_CELLULAR @"/" MT_IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" MT_IP_ADDR_IPv6, IOS_VPN @"/" MT_IP_ADDR_IPv4,*/ MT_IOS_WIFI @"/" MT_IP_ADDR_IPv6, MT_IOS_WIFI @"/" MT_IP_ADDR_IPv4, MT_IOS_CELLULAR @"/" MT_IP_ADDR_IPv6, MT_IOS_CELLULAR @"/" MT_IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [[self class] getIPAddresses];
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
        address = addresses[key];
        if(address) *stop = YES;
    } ];
    return address ? address : @"0.0.0.0";
}
//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = MT_IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = MT_IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
#pragma mark - Device info -
///获取APP名字  SLTips
+ (NSString *)appName {
    NSString *appCurName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    if (!appCurName) {
        appCurName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    }
    return appCurName;
}
///获取APP bundle id    com.wsl2ls.tips
+ (NSString *)appBundleId {
    NSString *appBundleId = [[NSBundle mainBundle] bundleIdentifier];
    return appBundleId;
}
///获取当前App版本号 1.1.0
+ (NSString *)appVersion {
    NSString *appCurVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return appCurVersion;
}
///获取当前App编译版本号 1
+ (NSString *)appBuild {
    NSString *appBuildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return appBuildVersion;
}

///获取手机型号 iPhone 12 Pro
+ (NSString *)iphoneType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSDictionary *dict = @{
        // iPhone
        @"iPhone1,1" : @"iPhone 1G",
        @"iPhone1,2" : @"iPhone 3G",
        @"iPhone2,1" : @"iPhone 3GS",
        @"iPhone3,1" : @"iPhone 4",
        @"iPhone3,2" : @"iPhone 4",
        @"iPhone4,1" : @"iPhone 4S",
        @"iPhone5,1" : @"iPhone 5",
        @"iPhone5,2" : @"iPhone 5",
        @"iPhone5,3" : @"iPhone 5C",
        @"iPhone5,4" : @"iPhone 5C",
        @"iPhone6,1" : @"iPhone 5S",
        @"iPhone6,2" : @"iPhone 5S",
        @"iPhone7,1" : @"iPhone 6 Plus",
        @"iPhone7,2" : @"iPhone 6",
        @"iPhone8,1" : @"iPhone 6S",
        @"iPhone8,2" : @"iPhone 6S Plus",
        @"iPhone8,4" : @"iPhone SE",
        @"iPhone9,1" : @"iPhone 7",
        @"iPhone9,3" : @"iPhone 7",
        @"iPhone9,2" : @"iPhone 7 Plus",
        @"iPhone9,4" : @"iPhone 7 Plus",
        @"iPhone10,1" : @"iPhone 8",
        @"iPhone10.4" : @"iPhone 8",
        @"iPhone10,2" : @"iPhone 8 Plus",
        @"iPhone10,5" : @"iPhone 8 Plus",
        @"iPhone10,3" : @"iPhone X",
        @"iPhone10,6" : @"iPhone X",
        @"iPhone11,8" : @"iPhone XR",
        @"iPhone11,2" : @"iPhone XS",
        @"iPhone11,4" : @"iPhone XS Max",
        @"iPhone11,6" : @"iPhone XS Max",
        @"iPhone12,1" : @"iPhone 11",
        @"iPhone12,3" : @"iPhone 11 Pro",
        @"iPhone12,5" : @"iPhone 11 Pro Max",
        @"iPhone12,8" : @"iPhone SE (2nd generation)",
        @"iPhone13,1" : @"iPhone 12 mini",
        @"iPhone13,2" : @"iPhone 12",
        @"iPhone13,3" : @"iPhone 12 Pro",
        @"iPhone13,4" : @"iPhone 12 Pro Max",
        @"iPhone14,4" : @"iPhone 13 mini",
        @"iPhone14,5" : @"iPhone 13",
        @"iPhone14,2" : @"iPhone 13 Pro",
        @"iPhone14,3" : @"iPhone 13 Pro Max",
        @"iPhone14,6" : @"iPhone SE (3rd generation)",
        @"iPhone14,7" : @"iPhone 14",
        @"iPhone14,8" : @"iPhone 14 Plus",
        @"iPhone15,2" : @"iPhone 14 Pro",
        @"iPhone15,3" : @"iPhone 14 Pro Max",
        // iPad
        @"iPad1,1" : @"iPad",
        @"iPad2,1" : @"iPad 2",
        @"iPad2,2" : @"iPad 2",
        @"iPad2,3" : @"iPad 2",
        @"iPad2,4" : @"iPad 2",
        @"iPad3,1" : @"iPad (3rd generation)",
        @"iPad3,2" : @"iPad (3rd generation)",
        @"iPad3,3" : @"iPad (3rd generation)",
        @"iPad3,4" : @"iPad (4th generation)",
        @"iPad3,5" : @"iPad (4th generation)",
        @"iPad3,6" : @"iPad (4th generation)",
        @"iPad6,11" : @"iPad (5th generation)",
        @"iPad6,12" : @"iPad (5th generation)",
        @"iPad7,5" : @"iPad (6th generation)",
        @"iPad7,6" : @"iPad (6th generation)",
        @"iPad7,11" : @"iPad (7th generation)",
        @"iPad7,12" : @"iPad (7th generation)",
        @"iPad11,6" : @"iPad (8th generation)",
        @"iPad11,7" : @"iPad (8th generation)",
        @"iPad12,1" : @"iPad (9th generation)",
        @"iPad12,2" : @"iPad (9th generation)",
        @"iPad4,1" : @"iPad Air",
        @"iPad4,2" : @"iPad Air",
        @"iPad4,3" : @"iPad Air",
        @"iPad5,3" : @"iPad Air 2",
        @"iPad5,4" : @"iPad Air 2",
        @"iPad11,3" : @"iPad Air (3rd generation)",
        @"iPad11,4" : @"iPad Air (3rd generation)",
        @"iPad13,1" : @"iPad Air (4th generation)",
        @"iPad13,2" : @"iPad Air (4th generation)",
        @"iPad13,16" : @"iPad Air (5th generation)",
        @"iPad13,17" : @"iPad Air (5th generation)",
        @"iPad6,7" : @"iPad Pro (12.9-inch)",
        @"iPad6,8" : @"iPad Pro (12.9-inch)",
        @"iPad6,3" : @"iPad Pro (9.7-inch)",
        @"iPad6,4" : @"iPad Pro (9.7-inch)",
        @"iPad7,1" : @"iPad Pro (12.9-inch) (2nd generation)",
        @"iPad7,2" : @"iPad Pro (12.9-inch) (2nd generation)",
        @"iPad7,3" : @"iPad Pro (10.5-inch)",
        @"iPad7,4" : @"iPad Pro (10.5-inch)",
        @"iPad8,1" : @"iPad Pro (11-inch)",
        @"iPad8,2" : @"iPad Pro (11-inch)",
        @"iPad8,3" : @"iPad Pro (11-inch)",
        @"iPad8,4" : @"iPad Pro (11-inch)",
        @"iPad8,5" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,6" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,7" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,8" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,9" : @"iPad Pro (11-inch) (2nd generation)",
        @"iPad8,10" : @"iPad Pro (11-inch) (2nd generation)",
        @"iPad8,11" : @"iPad Pro (12.9-inch) (4th generation)",
        @"iPad8,12" : @"iPad Pro (12.9-inch) (4th generation)",
        @"iPad13,4" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,5" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,6" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,7" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,8" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad13,9" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad13,10" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad13,11" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad2,5" : @"iPad mini",
        @"iPad2,6" : @"iPad mini",
        @"iPad2,7" : @"iPad mini",
        @"iPad4,4" : @"iPad mini 2",
        @"iPad4,5" : @"iPad mini 2",
        @"iPad4,6" : @"iPad mini 2",
        @"iPad4,7" : @"iPad mini 3",
        @"iPad4,8" : @"iPad mini 3",
        @"iPad4,9" : @"iPad mini 3",
        @"iPad5,1" : @"iPad mini 4",
        @"iPad5,2" : @"iPad mini 4",
        @"iPad11,1" : @"iPad mini (5th generation)",
        @"iPad11,2" : @"iPad mini (5th generation)",
        @"iPad14,1" : @"iPad mini (6th generation)",
        @"iPad14,2" : @"iPad mini (6th generation)",
        @"i386" : @"Simulator",
        @"x86_64" : @"Simulator"
    };
    return dict[deviceString] == nil ? deviceString : dict[deviceString];
}


#pragma mark - 隐私权限 -
///检查相册访问权限  handler 用户授权结果的回调
+ (MTAuthorizationStatus)checkPhotoLibraryAuthorization:(void(^)(MTAuthorizationStatus status))handler {
    __block MTAuthorizationStatus authorizationStatus = MTAuthorizationStatusUnknow;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0 //iOS 8.0以下使用AssetsLibrary.framework
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    authorizationStatus = (MTAuthorizationStatus)status;
#else   //iOS 8.0以上使用Photos.framework
    PHAuthorizationStatus current = [PHPhotoLibrary authorizationStatus];
    authorizationStatus = (MTAuthorizationStatus)current;
    //用户还没有做出过是否授权的选择时
    if (current == PHAuthorizationStatusNotDetermined) {
        //只有第一次请求授权时才会自动出现系统弹窗，之后再请求授权时也不会弹出系统询问弹窗
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    authorizationStatus = (MTAuthorizationStatus)status;
                    handler(authorizationStatus);
                }
            });
        }];
    }
#endif
    if (handler) {
        handler(authorizationStatus);
    }
    return authorizationStatus;
}

///检查定位权限
+ (MTAuthorizationStatus)checkLocationAuthorization  {
    MTAuthorizationStatus authorizationStatus = MTAuthorizationStatusUnknow;
    //定位服务是否可用
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus state = [CLLocationManager authorizationStatus];
        if (state == kCLAuthorizationStatusNotDetermined) {
            authorizationStatus = MTAuthorizationStatusNotDetermined;
        }else if(state == kCLAuthorizationStatusRestricted){
            authorizationStatus = MTAuthorizationStatusRestricted;
        }else if(state == kCLAuthorizationStatusDenied){
            authorizationStatus = MTAuthorizationStatusDenied;
        }else if(state == kCLAuthorizationStatusAuthorizedAlways){
            authorizationStatus = MTAuthorizationStatusAuthorizedAlways;
        }else if(state == kCLAuthorizationStatusAuthorizedWhenInUse){
            authorizationStatus = MTAuthorizationStatusAuthorizedWhenInUse;
        }
    }else{
        //定位服务不可用
        authorizationStatus = MTAuthorizationStatusUnsupported;
    }
    return authorizationStatus;
}

///检查相机/摄像头权限
+ (MTAuthorizationStatus)checkCameraAuthorization:(void(^)(MTAuthorizationStatus status))handler {
    __block MTAuthorizationStatus authorizationStatus = MTAuthorizationStatusUnknow;
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    authorizationStatus = (MTAuthorizationStatus)authStatus;
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                authorizationStatus = MTAuthorizationStatusAuthorized;
            }else{
                authorizationStatus = MTAuthorizationStatusDenied;
            }
            if (handler) {
                handler(authorizationStatus);
            }
        }];
    }
    if (handler) {
        handler(authorizationStatus);
    }
    return authorizationStatus;
}

///检查话筒/麦克风权限
+ (MTAuthorizationStatus)checkMicrophoneAuthorization:(void(^)(MTAuthorizationStatus status))handler {
    __block MTAuthorizationStatus authorizationStatus = MTAuthorizationStatusUnknow;
    NSString *mediaType = AVMediaTypeAudio;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    authorizationStatus = (MTAuthorizationStatus)authStatus;
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                authorizationStatus = MTAuthorizationStatusAuthorized;
            } else {
                authorizationStatus = MTAuthorizationStatusDenied;
            }
            if (handler) {
                handler(authorizationStatus);
            }
        }];
    }
    if (handler) {
        handler(authorizationStatus);
    }
    return authorizationStatus;
}

///检测通讯录权限
+ (MTAuthorizationStatus)checkContactsAuthorization:(void(^)(MTAuthorizationStatus status))handler {
    __block  MTAuthorizationStatus authorizationStatus = MTAuthorizationStatusUnknow;
    if (@available(iOS 9.0, *)) {//iOS9.0之后
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        authorizationStatus = (MTAuthorizationStatus)authStatus;
        if (authStatus == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
                if (!error){
                    if (granted) {
                        authorizationStatus = MTAuthorizationStatusAuthorized;
                    } else {
                        authorizationStatus = MTAuthorizationStatusDenied;
                    }
                    if (handler) {
                        handler(authorizationStatus);
                    }
                }
                
            }];
        }
    }else{//iOS9.0之前
        ABAuthorizationStatus authorStatus = ABAddressBookGetAuthorizationStatus();
        authorizationStatus = (MTAuthorizationStatus)authorStatus;
    }
    if (handler) {
        handler(authorizationStatus);
    }
    return authorizationStatus;
}

///检测日历权限
+ (MTAuthorizationStatus)checkCalendarAuthorization:(void(^)(MTAuthorizationStatus status))handler {
    __block MTAuthorizationStatus authorizationStatus = MTAuthorizationStatusUnknow;
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    authorizationStatus = (MTAuthorizationStatus)status;
    if (status == EKAuthorizationStatusNotDetermined) {
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (error) {} else {
                if (granted) {
                    authorizationStatus = MTAuthorizationStatusAuthorized;
                } else {
                    authorizationStatus = MTAuthorizationStatusDenied;
                }
                if (handler) {
                    handler(authorizationStatus);
                }
            }
        }];
    }
    if (handler) {
        handler(authorizationStatus);
    }
    return authorizationStatus;
}

///检测提醒事项权限
+ (MTAuthorizationStatus)checkRemindAuthorization:(void(^)(MTAuthorizationStatus status))handler {
    __block MTAuthorizationStatus authorizationStatus = MTAuthorizationStatusUnknow;
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    authorizationStatus = (MTAuthorizationStatus)status;
    if (status == EKAuthorizationStatusNotDetermined) {
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
            if (!error){
                if (granted) {
                    authorizationStatus = MTAuthorizationStatusAuthorized;
                } else {
                    authorizationStatus = MTAuthorizationStatusDenied;
                }
                if (handler) {
                    handler(authorizationStatus);
                }
            }
        }];
    }
    if (handler) {
        handler(authorizationStatus);
    }
    return authorizationStatus;
}

///检测蓝牙权限
- (void)checkBluetoothAuthorization {
    if (@available(iOS 13.1, *)) {
        CBManagerAuthorization authorization = [CBManager authorization];
        MTAuthorizationStatus authorizationStatus = MTAuthorizationStatusUnknow;
        if (authorization == CBManagerAuthorizationAllowedAlways) {
            authorizationStatus = MTAuthorizationStatusAuthorizedAlways;
        }else {
            authorizationStatus = (MTAuthorizationStatus)authorization;
        }
    } else {
        CBCentralManager *bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
}
///CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    MTAuthorizationStatus authorizationStatus = MTAuthorizationStatusUnknow;
    CBManagerState state = central.state;
    if (state == CBManagerStateResetting) {
        //重置或重新连接
        authorizationStatus = MTAuthorizationStatusUnknow;
    } else if (state == CBManagerStateUnsupported) {
        //不支持蓝牙功能
        authorizationStatus = MTAuthorizationStatusUnsupported;
    } else if (state == CBManagerStateUnauthorized) {
        //拒绝授权
        authorizationStatus = MTAuthorizationStatusDenied;
    } else if (state == CBManagerStatePoweredOff) {
        //蓝牙处于关闭状态
        authorizationStatus = MTAuthorizationStatusOff;
    } else if (state == CBManagerStatePoweredOn) {
        //已授权
        authorizationStatus = MTAuthorizationStatusAuthorized;
    }
}

///请求FaceID权限
+ (void)checkFaceIDAuthorization {
    __block MTAuthorizationStatus authorizationStatus = MTAuthorizationStatusUnknow;
    if (@available(iOS 11.0, *)) {
        LAContext *authenticationContext = [[LAContext alloc]init];
        NSError *error = nil;
        ///是否能验证人脸数据
        BOOL canEvaluatePolicy = [authenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
        if (canEvaluatePolicy) {
            if (authenticationContext.biometryType == LABiometryTypeFaceID) {
                //验证当前人脸数据
                [authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"开始验证" reply:^(BOOL success, NSError * _Nullable error) {
                    if (!error) {
                        if (success) {
                            //验证通过
                        }else {
                            //验证失败
                        }
                    }
                }];
            }
        }else {
            if (error.code == -8) {
                NSLog(@"错误次数太多，被锁定");
            }else{
                NSLog(@"没有设置人脸数据,请前往设置");
            }
        }
    }else {
        authorizationStatus = MTAuthorizationStatusUnsupported;
    }
    
}
@end
