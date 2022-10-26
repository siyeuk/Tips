//
//  WKWebView+MTExtension.m
//  MT_Tips
//
//  Created by lss on 2022/10/14.
//

#import "WKWebView+MTExtension.h"

@implementation WKWebView (MTExtension)


#pragma mark - NSURLProtocol
///注册http/https  以支持NSURLProtocol对WKWebView的网络请求
+ (void)mt_registerSchemeForSupportHttpProtocol{
    Class cls = NSClassFromString([NSString stringWithFormat:@"%@%@%@%@%@", @"W", @"K", @"Browsing", @"Context", @"Controller"]);
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@%@%@%@", @"register", @"SchemeFor", @"Custom", @"Protocol", @":"]);
    if ([cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [cls performSelector:sel withObject:@"http"];
        [cls performSelector:sel withObject:@"https"];
#pragma clang diagnostic pop
    }
}
///取消注册http/https
+ (void)mt_unregisterSchemeForSupportHttpProtocol{
    Class cls = NSClassFromString([NSString stringWithFormat:@"%@%@%@%@%@", @"W", @"K", @"Browsing", @"Context", @"Controller"]);
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@%@%@%@", @"unregister", @"SchemeFor", @"Custom", @"Protocol", @":"]);
    if ([cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [cls performSelector:sel withObject:@"http"];
        [cls performSelector:sel withObject:@"https"];
#pragma clang diagnostic pop
    }
}

#pragma mark - UserAgent
/// 获取UA
+ (NSString *)mt_getUserAgent {
    //获取UserAgent 这个是异步的
    //    [self evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
    //        NSString *userAgent = response;
    //    }];
    UIWebView *webView = [[UIWebView alloc] init];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    return userAgent;
}
/// 设置UA  在WKWebView初始化之前设置 ，才能实时生效
+ (void)mt_setCustomUserAgentWithType:(MTSetUAType)type UAString:(NSString *)customUserAgent {
    if (!customUserAgent || customUserAgent.length <= 0) {
        return;
    }
    // 这种设置方式仅对当前webView对象有效
    //  self.customUserAgent = customUserAgent;
    if (type == MTSetUATypeReplace) {
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:customUserAgent, @"UserAgent", nil];
        //iOS8.0之前 是通过这种方式设置的，设置之后是全局
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }else {
        NSString *originalUserAgent = [WKWebView mt_getUserAgent];
        NSString *appUserAgent = [NSString stringWithFormat:@"%@-%@", originalUserAgent, customUserAgent];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:appUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }
}

#pragma mark - Cookie
///设置自定义Cookie
+ (void)mt_setCustomCookieWithName:(NSString *)name
                             value:(NSString *)value
                            domain:(NSString *)domain
                              path:(NSString *)path
                       expiresDate:(NSDate *)expiresDate{
    NSDictionary *mCookProperties = @{
        NSHTTPCookieDomain: domain,
        NSHTTPCookiePath: path,
        NSHTTPCookieName: name,
        NSHTTPCookieValue: value,
        NSHTTPCookieExpires : expiresDate
    };
    NSHTTPCookie *myCookie = [NSHTTPCookie cookieWithProperties:mCookProperties];
    if (@available(iOS 11.0, *)) {
        WKWebsiteDataStore *store = [WKWebsiteDataStore defaultDataStore];
        [store.httpCookieStore setCookie:myCookie completionHandler:^{
        }];
    } else {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:myCookie];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
///查询获取所有Cookies
+ (void)mt_getAllCookies {
    if (@available(iOS 11.0, *)) {
        WKWebsiteDataStore *store = [WKWebsiteDataStore defaultDataStore];
        [store.httpCookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * cookies) {
            [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //                    NSLog(@"  name:%@; value:%@ domain:%@ ", obj.name, obj.value, obj.domain);
            }];
        }];
    }
    else {
        NSArray *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
        for (NSHTTPCookie *cookie in cookieJar) {
            //                NSLog(@" name:%@; value:%@ domain:%@ ", cookie.name, cookie.value, cookie.domain);
        }
    }
}


@end
