//
//  OptsUtils.h
//  MT_Tips
//
//  Created by lss on 2022/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OptsUtils : NSObject

//判断字符串是否为空串
+(BOOL)isEmptyString:(NSString *)string;
//判断两个字符串是否相等
+(BOOL)isEqualToString:(NSString *)stringA :(NSString *)stringB;

@end

NS_ASSUME_NONNULL_END
