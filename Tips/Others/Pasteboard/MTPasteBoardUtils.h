//
//  MTPasteBoardUtils.h
//  MT_Tips
//
//  Created by lss on 2022/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTPasteBoardUtils : NSObject

//读取剪切板，nil表示剪切板为空
+ (NSString *)read;
//保存到剪切板
+ (void)save:(NSString *)content;
//清空剪切板
+ (void)clear;

@end

NS_ASSUME_NONNULL_END
