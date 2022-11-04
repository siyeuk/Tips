//
//  MTExcelStyleModel.m
//  Tips
//
//  Created by lss on 2022/10/27.
//

#import "MTExcelStyleModel.h"

@implementation MTExcelStyleModel

- (instancetype)init{
    if (self = [super init]) {
        self.textFont = [UIFont systemFontOfSize:16];
        self.textColor = [UIColor blackColor];
        self.textHAlignment = NSTextHAlignmentJustify;
        self.textVAlignment = NSTextVAlignmentCenter;
        self.bold = NO;
        self.italic = NO;
        self.underline = NO;
        self.strikeout = NO;
        self.shadow = NO;
    }
    return self;
}

@end
