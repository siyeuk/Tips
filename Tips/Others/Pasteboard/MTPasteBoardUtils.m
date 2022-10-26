//
//  MTPasteBoardUtils.m
//  MT_Tips
//
//  Created by lss on 2022/10/17.
//

#import "MTPasteBoardUtils.h"

#define PASTEBOARD_MARK @"MTPasteboardmark"


//读取剪切板的内容只从系统剪切板读区
//应用内保存到剪切板的内容在主动读取的时候需要过滤掉
@implementation MTPasteBoardUtils

+ (NSString *)read {
    //创建系统剪切板
    UIPasteboard *systemBoard = [UIPasteboard generalPasteboard];
    if(!systemBoard.numberOfItems) {
        //剪切板为空
        return nil;
    }
    if([self hasMark]) {
        //剪切板数据已经标记过了，则数据来自当前应用，不予处理
        return nil;
    }
    return systemBoard.string;
}

+ (void)save:(NSString *)content {
    //创建系统剪切板
    UIPasteboard *systemBoard = [UIPasteboard generalPasteboard];
    //将文本写入剪切板
    systemBoard.string = content;
    //给剪切板加入一条标记性的数据，只是为了检测剪切板的数据是否来自当前应用
    NSDictionary<NSString *, id> *item = @{PASTEBOARD_MARK:content};
    [systemBoard addItems:@[item]];
}

+ (void)clear {
    //创建系统剪切板
    UIPasteboard *systemBoard = [UIPasteboard generalPasteboard];
    systemBoard.string = @"";
}

+ (BOOL)hasMark{
    //创建系统剪切板
    UIPasteboard *systemBoard = [UIPasteboard generalPasteboard];
    if(!systemBoard.numberOfItems) {
        return YES;
    }
    NSArray<NSDictionary<NSString *, id> *> *items = systemBoard.items;
    long count = systemBoard.numberOfItems;
    for(int i=0; i < count; i++){
        NSDictionary<NSString *, id> *item = [items objectAtIndex:i];
        if([[item allKeys] containsObject:PASTEBOARD_MARK]){
            return YES;
        }
    }
    return NO;
}


@end


