//
//  MTKeyChain.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString* const MTkeychainService;

@interface MTKeyChain : NSObject

/// 保存用户信息到钥匙串中
/// - Parameters:
///   - service: 存储服务的key，一个service可以存储多个account/password键值对
///   - account: 账号
///   - password: 密码
+ (NSError *)saveKeychainWithService:(NSString *)service
                             account:(NSString *)account
                            password:(NSString *)password;
/// 从钥匙串中删除这条用户信息
+ (NSError *)deleteWithService:(NSString *)service
                       account:(NSString *)account;

/// 查询用户信息 查到的结果存在NSError中
+ (NSError *)queryKeychainWithService:(NSString *)service
                              account:(NSString *)account;

/// 更新钥匙串中的用户名和密码
+ (NSError *)updateKeychainWithService:(NSString *)service
                               account:(NSString *)account
                              password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
