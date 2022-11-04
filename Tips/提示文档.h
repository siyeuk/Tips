//
//  提示文档.h
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#ifndef _____h
#define _____h

// 支持暴漏Document
Supports opening documents in place
Application supports iTunes file sharing

/// 配置权限的XML格式
<!-- 蓝牙 -->
<key>NSBluetoothPeripheralUsageDescription</key>
<string>App需要您的同意,才能访问蓝牙</string>

<!-- 日历 -->
<key>NSCalendarsUsageDescription</key>
<string>App需要您的同意,才能访问日历</string>

<!-- 相机 -->
<key>NSCameraUsageDescription</key>
<string>App需要您的同意,才能访问相机</string>

<!-- 通讯录 -->
<key>NSContactsUsageDescription</key>
<string>App需要您的同意,才能访问通讯录</string>

<!-- Face ID -->
<key>NSFaceIDUsageDescription</key>
<string>App需要您的同意,才能访问Face ID</string>

<!-- 健康分享 -->
<key>NSHealthShareUsageDescription</key>
<string>App需要您的同意,才能访问健康分享</string>

<!-- 健康更新 -->
<key>NSHealthUpdateUsageDescription</key>
<string>App需要您的同意,才能访问健康更新 </string>

<!-- 住宅配件 -->
<key>NSHomeKitUsageDescription</key>
<string>App需要您的同意,才能访问住宅配件 </string>

<!-- 位置 -->
<key>NSLocationUsageDescription</key>
<string>App需要您的同意,才能访问位置</string>

<!-- 始终访问位置 -->
<key>NSLocationAlwaysUsageDescription</key>
<string>App需要您的同意,才能始终访问位置</string>

<!-- 在使用期间访问位置 -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>App需要您的同意,才能在使用期间访问位置</string>

<!-- 麦克风 -->
<key>NSMicrophoneUsageDescription</key>
<string>App需要您的同意,才能访问麦克风</string>

<!-- 运动与健身 -->
<key>NSMotionUsageDescription</key>
<string>App需要您的同意,才能访问运动与健身</string>

<!-- 媒体资料库 -->
<key>NSAppleMusicUsageDescription</key>
<string>App需要您的同意,才能访问媒体资料库</string>

<!-- NFC -->
<key>NFCReaderUsageDescription</key>
<string>App需要您的同意,才能访问NFC</string>

<!-- 相册 -->
<key>NSPhotoLibraryUsageDescription</key>
<string>App需要您的同意,才能访问相册</string>

<!-- 提醒事项 -->
<key>NSRemindersUsageDescription</key>
<string>App需要您的同意,才能访问提醒事项</string>

<!-- Siri -->
<key>NSSiriUsageDescription</key>
<string>App需要您的同意,才能使用Siri功能</string>

<!-- 语音识别 -->
<key>NSSpeechRecognitionUsageDescription</key>
<string>App需要您的同意,才能使用语音识别功能</string>

<!-- 电视提供商 -->
<key>NSVideoSubscriberAccountUsageDescription</key>
<string>App需要您的同意,才能访问电视提供商</string>


/// 需要引入的库
#import <CoreBluetooth/CoreBluetooth.h>
#import <EventKit/EventKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Contacts/Contacts.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <HealthKit/HealthKit.h>
#import <HomeKit/HomeKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <StoreKit/StoreKit.h>
#import <CoreNFC/CoreNFC.h>
#import <Photos/Photos.h>
#import <Intents/Intents.h>
#import <Speech/Speech.h>

/// 请求方式 见MTSystemAppInfo.m

#endif /* _____h */
