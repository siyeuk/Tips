//
//  MTExcelManager.h
//  Tips
//
//  Created by lss on 2022/10/27.
//

#import <Foundation/Foundation.h>
#import "MTExcelStyleModel.h"

NS_ASSUME_NONNULL_BEGIN
// 插入区域
typedef struct _MTLocation {
    int row; // 行
    int column; // 列
} MTLocation;

NS_INLINE MTLocation MTLocationMake(int row, int column) {
    MTLocation l;
    l.row = row;
    l.column = column;
    return l;
}
// 合并区域
typedef struct _MTAera {
    int startRow; // 起始行
    int startColumn; // 起始列
    int endRow; // 结束行
    int endColumn; // 结束列
} MTAera;

NS_INLINE MTAera MTAeraMake(int startRow, int startColumn, int endRow, int endColumn) {
    MTAera a;
    a.startRow = startRow;
    a.startColumn = startColumn;
    a.endRow = endRow;
    a.endColumn = endColumn;
    return a;
}

@interface MTExcelManager : NSObject

// 根据名字创建文档 返回0说明创建成功,返回-1说明该文件已存在,换个名字吧
- (int)createExcelWithName:(NSString *)excelName;



/// 将内容填入哪个单元格
/// - Parameters:
///   - content: 填入的内容
///   - location: 第几行 第几列
///   - style: 样式 无则为默认上次样式
- (void)write:(NSString *)content location:(MTLocation)location;
- (void)write:(NSString *)content location:(MTLocation)location style:(MTExcelStyleModel *)style;


/// 将内容填入哪几个合并后的单元格
/// - Parameters:
///   - content: 填入的内容
///   - aera: 合并第几行第几列到第几行第几列
///   - style: 样式 无则为默认上次样式
- (void)write:(NSString *)content merge:(MTAera)aera;
- (void)write:(NSString *)content merge:(MTAera)aera style:(MTExcelStyleModel *)style;


// 设置单元格高度
- (void)setRowHeight:(double)height row:(int)row;


/// 设置单元格宽度
/// - Parameters:
///   - width: 宽度
///   - start: 开始列
///   - end: 结束列
- (void)setColumnWidth:(double)width start:(int)start end:(int)end;

/// 结束写入并保存
- (void)save;


@end

NS_ASSUME_NONNULL_END
