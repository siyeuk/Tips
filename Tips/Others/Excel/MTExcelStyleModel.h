//
//  MTExcelStyleModel.h
//  Tips
//
//  Created by lss on 2022/10/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 垂直对齐方式
typedef NS_ENUM(NSUInteger, NSTextVAlignment){
    NSTextVAlignmentNone        = 0,
    NSTextVAlignmentTop         = 1, // 顶部垂直对齐
    NSTextVAlignmentBottom      = 2, // 底部垂直对齐
    NSTextVAlignmentCenter      = 3, // 中心垂直对齐
    NSTextVAlignmentJustify     = 4, // 两端垂直对齐 每一行被展开为宽度相等，左，右外边距是对齐（如杂志和报纸）
    NSTextVAlignmentDistributed = 5 // 分布式垂直对齐
};
// 水平对齐方式
typedef NS_ENUM(NSUInteger, NSTextHAlignment){
    NSTextHAlignmentNone    = 0,
    NSTextHAlignmentLeft    = 1, // 左对齐
    NSTextHAlignmentCenter  = 2, // 居中
    NSTextHAlignmentRight   = 2, // 右对齐
    NSTextHAlignmentFill    = 4, // 单元格填充水平对齐
    NSTextHAlignmentJustify = 5, // 两端对齐
    NSTextHAlignmentAcross  = 6, // 横向对齐

};
@interface MTExcelStyleModel : NSObject


//@property (nonatomic, assign) cf
@property (nonatomic, strong) UIFont *textFont; // 大小 默认16 目前生效的只有大小
@property (nonatomic, strong) UIColor *textColor; // 颜色 默认黑色
@property (nonatomic, assign) NSTextHAlignment textHAlignment; //水平对齐方式 默认水平填充 暂未生效
@property (nonatomic, assign) NSTextVAlignment textVAlignment; //垂直对齐方式 默认垂直居中
@property (nonatomic, assign, getter=isBold) BOOL bold; //是否加粗 默认NO
@property (nonatomic, assign, getter=isItalic) BOOL italic; // 是否斜体 默认NO
@property (nonatomic, assign, getter=isUnderline) BOOL underline;// 是否有下划线 默认NO
@property (nonatomic, assign, getter=isStrikeout) BOOL strikeout;// 是否加删除线 默认NO
@property (nonatomic, assign, getter=isShadow) BOOL shadow; // 是否有阴影 默认NO
//@property (nonatomic, assign, getter=isItalic) BOOL




@end

NS_ASSUME_NONNULL_END
