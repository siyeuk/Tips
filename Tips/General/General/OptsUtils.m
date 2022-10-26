//
//  OptsUtils.m
//  MT_Tips
//
//  Created by lss on 2022/10/17.
//

#import "OptsUtils.h"

@implementation OptsUtils

+ (BOOL)isEmptyString:(NSString *)string{
    if(!string) {
        return YES;
    }
    if([string isKindOfClass:[NSNull class]]){
        return YES;
    }
    if(!string.length){
        return YES;
    }
    return NO;
}

+ (BOOL)isEqualToString:(NSString *)stringA :(NSString *)stringB{
    if([self isEmptyString:stringA] && [self isEmptyString:stringB]) {
        return YES;
    }
    if([self isEmptyString:stringA]){
        return NO;
    }
    return [stringA isEqualToString:stringB];
}

@end
