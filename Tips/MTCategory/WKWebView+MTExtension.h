//
//  WKWebView+MTExtension.h
//  MT_Tips
//
//  Created by lss on 2022/10/14.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
// 设置UserAgent的方式
typedef NS_ENUM(NSInteger, MTSetUAType) {
    // 替换默认UA
    MTSetUATypeReplace,
    // 拼接默认UA
    MTSetUATypeAppend,
} ;


@interface WKWebView (MTExtension)

///注册http/https  以支持NSURLProtocol拦截WKWebView的网络请求
+ (void)mt_registerSchemeForSupportHttpProtocol;
///取消注册http/https
+ (void)mt_unregisterSchemeForSupportHttpProtocol;

/// 获取UA
+ (NSString *)mt_getUserAgent;
/// 设置UA  在WKWebView初始化之前设置，才能实时生效
+ (void)mt_setCustomUserAgentWithType:(MTSetUAType)type UAString:(NSString *)customUserAgent;

///设置自定义Cookie
+ (void)mt_setCustomCookieWithName:(NSString *)name
                    value:(NSString *)value
                   domain:(NSString *)domain
                     path:(NSString *)path
                 expiresDate:(NSDate *)expiresDate;
///查询获取所有Cookies
+ (void)mt_getAllCookies;


@end

NS_ASSUME_NONNULL_END
