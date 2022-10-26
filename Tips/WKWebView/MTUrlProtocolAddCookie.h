//
//  MTUrlProtocolAddCookie.h
//  MT_Tips
//
//  Created by lss on 2022/10/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///解决WKWebView上请求不会自动携带Cookie的问题：通过NSURLProtocol，拦截request，然后在请求头里添加Cookie的方式
@interface MTUrlProtocolAddCookie : NSURLProtocol

@end

NS_ASSUME_NONNULL_END
