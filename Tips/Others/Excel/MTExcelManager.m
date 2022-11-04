//
//  MTExcelManager.m
//  Tips
//
//  Created by lss on 2022/10/27.
//

#import "MTExcelManager.h"
#import <xlsxwriter/xlsxwriter.h>
#import <CoreText/CoreText.h>

@interface MTExcelManager (){
    lxw_workbook *_workbook;
    lxw_worksheet *_worksheet;
    lxw_format *_default_format;
    MTExcelStyleModel *_systemStyle;
    MTExcelStyleModel *_defaultStyle;
}

@end

@implementation MTExcelManager

- (instancetype)init{
    if (self = [super init]) {
        _systemStyle = [[MTExcelStyleModel alloc] init];
        _defaultStyle = [[MTExcelStyleModel alloc] init];
    }
    return self;
}

// 根据名字创建文档
- (int)createExcelWithName:(NSString *)excelName{
    NSString *docunemtPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *xlsxName = [NSString stringWithFormat:@"%@.xlsx",excelName];
    NSString *filePath = [docunemtPath stringByAppendingPathComponent:xlsxName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return -1;
    }
    // 创建新xlsx文件
    _workbook = workbook_new([filePath UTF8String]);
    // 创建sheet
    _worksheet = workbook_add_worksheet(_workbook, NULL);
    _default_format = [self addStyle:_defaultStyle];
    return 0;
}

- (void)write:(NSString *)content location:(MTLocation)location{
    [self write:content location:location style:_systemStyle];
}
- (void)write:(NSString *)content location:(MTLocation)location style:(MTExcelStyleModel *)style{
    if (_defaultStyle != style) {
        _defaultStyle = style;
        _default_format = [self addStyle:style];
    }
    if (_worksheet){
        worksheet_write_string(_worksheet, location.row, location.column, [content UTF8String], _default_format);
    }
}

- (void)write:(NSString *)content merge:(MTAera)aera{
    [self write:content merge:aera style:_systemStyle];
}
- (void)write:(NSString *)content merge:(MTAera)aera style:(MTExcelStyleModel *)style{
    if (_defaultStyle != style) {
        _defaultStyle = style;
        _default_format = [self addStyle:style];
    }
    if (_worksheet) {
        worksheet_merge_range(_worksheet, aera.startRow, aera.startColumn, aera.endRow, aera.endColumn, [content UTF8String], _default_format);
    }
}
// 设置单元格高度
- (void)setRowHeight:(double)height row:(int)row{
    if (!_worksheet) return;
    worksheet_set_row(_worksheet, row, height, nil);
}


// 设置单元格宽度
- (void)setColumnWidth:(double)width start:(int)start end:(int)end{
    if (!_worksheet) return;
    worksheet_set_column(_worksheet, start, end, width, nil);
}
/// 结束写入并保存
- (void)save{
    workbook_close(_workbook);
}
#pragma mark - private -
- (lxw_format *)addStyle:(MTExcelStyleModel *)style{
    if (_workbook) {
        lxw_format *formate = workbook_add_format(_workbook);
        if (style.isBold) format_set_bold(formate);
        format_set_font_size(formate, style.textFont.pointSize);
        format_set_align(formate, LXW_ALIGN_VERTICAL_CENTER);
        //        format_set_align(formate, (style.textVAlignment==NSTextVAlignmentCenter)?LXW_ALIGN_VERTICAL_CENTER:LXW_ALIGN_VERTICAL_CENTER);
        format_set_align(formate, LXW_ALIGN_CENTER);
        return formate;
    }
    return nil;
}

//- (void)createExcel{
//    // 获取Document路径
//    NSString *document = MT_DocumentDir;
//    NSString *xlsxName = [NSString stringWithFormat:@"文档.xlsx"];
//    
//    NSString *filePah = [document stringByAppendingPathComponent:xlsxName];
//    
//    // 创建新xlsx文件
//    lxw_workbook *workbook = workbook_new([filePah UTF8String]);
//    // 创建sheet
//    lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
//    
//    // 格式1
//    lxw_format *titleformat = workbook_add_format(workbook);
//    // 加粗
//    format_set_bold(titleformat);
//    // 字体尺寸
//    format_set_font_size(titleformat, 20);
//    // 内容垂直居中
//    format_set_align(titleformat, LXW_ALIGN_VERTICAL_CENTER);
//    // 合并单元格. 0行0列到0行8列合并为一行, 并设定内容为 "这是文档标题"
//    worksheet_merge_range(worksheet, 0, 0, 0, 8, [@"这是文档标题" cStringUsingEncoding:NSUTF8StringEncoding], titleformat);
//    
//    // 格式2
//    lxw_format *columnTitleformat = workbook_add_format(workbook);
//    // 内容垂直居中
//    format_set_align(columnTitleformat, LXW_ALIGN_VERTICAL_CENTER);
//    // 内容水平居中
//    format_set_align(columnTitleformat, LXW_ALIGN_CENTER);
//    
//    // 将"统计周期：" 的总价写入到1行5列
//    worksheet_write_string(worksheet, 1, 5, [@"统计周期：" UTF8String], columnTitleformat);
//    // 将"填报日期：" 的总价写入到1行7列
//    worksheet_write_string(worksheet, 1, 7, [@"填报日期：" UTF8String], columnTitleformat);
//    // 第1行的高度为20，并将格式2应用到该行上。注意 行的高度和列表的宽度的值单位不一样，此50非彼50
//    worksheet_set_row(worksheet, 1, 30, columnTitleformat);
//    
//    // 第0列到第8列的宽度为30。注意 此30非彼30
//    worksheet_set_column(worksheet, 0, 8, 30.0, NULL);
//    // 第2行的高度为30，并将格式2应用到该行上。注意 行的高度和列表的宽度的值单位不一样，此30非彼30
//    worksheet_set_row(worksheet, 2, 30, columnTitleformat);
//    
//    // 将"序号"写入到2行0列
//    worksheet_write_string(worksheet, 2, 0, [@"序号" UTF8String], columnTitleformat);
//    // 将"企业名称"写入到2行1列
//    worksheet_write_string(worksheet, 2, 1, [@"企业名称" UTF8String], columnTitleformat);
//    // 将"商家账号"写入到2行2列
//    worksheet_write_string(worksheet, 2, 2, [@"商家账号" UTF8String], columnTitleformat);
//    // 将"消费日期"写入到2行3列
//    worksheet_write_string(worksheet, 2, 3, [@"消费日期" UTF8String], columnTitleformat);
//    // 将"销售订单号"写入到2行4列
//    worksheet_write_string(worksheet, 2, 4, [@"销售订单号" UTF8String], columnTitleformat);
//    // 将"销售金额"写入到2行5列
//    worksheet_write_string(worksheet, 2, 5, [@"销售金额" UTF8String], columnTitleformat);
//    // 将"通联订单号"写入到2行6列
//    worksheet_write_string(worksheet, 2, 6, [@"通联订单号" UTF8String], columnTitleformat);
//    // 将"优惠（券）"写入到2行7列
//    worksheet_write_string(worksheet, 2, 7, [@"优惠（券）" UTF8String], columnTitleformat);
//    // 将"实付金额"写入到2行8列
//    worksheet_write_string(worksheet, 2, 8, [@"实付金额" UTF8String], columnTitleformat);
//    
//    int  rowA = 3 + (int)self.accountDataArray.count;
//    // 合并单元格。rowA行0列 到 rowA行5列合并为一行，并设定内容为 "合计："
//    worksheet_merge_range(worksheet, rowA,  0 ,rowA, 5, [@"合计：" cStringUsingEncoding:NSUTF8StringEncoding], columnTitleformat);
//    // 第rowA行的高度为50。注意 行的高度和列表的宽度的值单位不一样，此50非彼50
//    worksheet_set_row(worksheet, rowA, 50, columnTitleformat);
//    
//    float discountPrice = 0.00;
//    float realPrice = 0.00;
//    // 统计 优惠（券）所在列的总价 和 实付金额 所在列的总价
//    for (int i = 0; i < self.accountDataArray.count; i++) {
//        //        ZB_AccountModel *model = self.accountDataArray[i];
//        //        discountPrice = discountPrice + [model.discountMoney floatValue];
//        //        realPrice = realPrice + [model.payment floatValue];
//    }
//    // 将优惠（券）所在列的总价写入到rowA行7列
//    worksheet_write_string(worksheet, rowA, 7, [[NSString stringWithFormat:@"%.2lf",discountPrice] UTF8String], columnTitleformat);
//    // 将实付金额 所在列的总价写入到rowA行8列
//    worksheet_write_string(worksheet, rowA, 8, [[NSString stringWithFormat:@"%.2lf",realPrice] UTF8String], columnTitleformat);
//    
//    int  rowB = 4 + (int)self.accountDataArray.count;
//    // 合并单元格。rowB行0列 到 rowB行1列合并为一行，并设定内容为 "负责人："
//    worksheet_merge_range(worksheet, rowB,  0 ,rowB, 1, [@"负责人：" cStringUsingEncoding:NSUTF8StringEncoding], columnTitleformat);
//    // 合并单元格。rowB行3列 到 rowB行4列合并为一行，并设定内容为 "填表人："
//    worksheet_merge_range(worksheet, rowB,  3 ,rowB, 4, [@"填表人：" cStringUsingEncoding:NSUTF8StringEncoding], columnTitleformat);
//    // 合并单元格。rowB行6列 到 rowB行7列合并为一行，并设定内容为 "单位：（盖章）"
//    worksheet_merge_range(worksheet, rowB,  6 ,rowB, 7, [@"单位：（盖章）" cStringUsingEncoding:NSUTF8StringEncoding], columnTitleformat);
//    // 第rowB行的高度为50，并将格式2应用到该行上。注意 行的高度和列表的宽度的值单位不一样，此50非彼50
//    worksheet_set_row(worksheet, rowB, 50, columnTitleformat);
//    
//    // 格式3
//    lxw_format *markformat = workbook_add_format(workbook);
//    // 内容垂直居中
//    format_set_align(markformat, LXW_ALIGN_VERTICAL_CENTER);
//    // 内容水平居中
//    format_set_align(markformat, LXW_ALIGN_CENTER);
//    // 字体尺寸
//    format_set_font_size(markformat, 17);
//    // 字体颜色
//    format_set_font_color(markformat,0xFF0000);
//    int  rowC = 5 + (int)self.accountDataArray.count;
//    // 合并单元格。rowC行0列 到 rowB行8列合并为一行，并设定内容为 "备注1、使用文化和旅游惠民消费券的订单，以通联订单号为唯一标识逐笔填写。"
//    worksheet_merge_range(worksheet, rowC,  0 ,rowC, 8, [@"备注1、使用文化和旅游惠民消费券的订单，以通联订单号为唯一标识逐笔填写。" cStringUsingEncoding:NSUTF8StringEncoding], markformat);
//    // 第rowC行的高度为50，并将格式3应用到该行上。注意 行的高度和列表的宽度的值单位不一样，此30非彼30
//    worksheet_set_row(worksheet,  rowC, 30, markformat);
//    
//    // 遍历数据源，将表格数据写入到某行某列中
//    for (int i = 0; i < self.accountDataArray.count; i++) {
//        //        ZB_AccountModel *model = self.accountDataArray[i];
//        //        NSString *calTime  = [FYTimeManager timeWithDataTime:model.paymentTime/1000];
//        //        worksheet_set_row(worksheet, 3+i, 30, columnTitleformat);
//        //        worksheet_write_string(worksheet, 3+i, 0, [[NSString stringWithFormat:@"%d",i+1] UTF8String], columnTitleformat);
//        //        worksheet_write_string(worksheet, 3+i, 1, [model.companyName UTF8String], columnTitleformat);
//        //        worksheet_write_string(worksheet, 3+i, 2, [model.accountNo UTF8String], columnTitleformat);
//        //        worksheet_write_string(worksheet, 3+i, 3, [calTime UTF8String], columnTitleformat);
//        //        worksheet_write_string(worksheet, 3+i, 4, [model.orderNo UTF8String], columnTitleformat);
//        //        worksheet_write_string(worksheet, 3+i, 5, [model.price UTF8String], columnTitleformat);
//        //        worksheet_write_string(worksheet, 3+i, 6, [model.allInPayOrderNo UTF8String], columnTitleformat);
//        //        worksheet_write_string(worksheet, 3+i, 7, [model.discountMoney UTF8String], columnTitleformat);
//        //        worksheet_write_string(worksheet, 3+i, 8, [model.payment UTF8String], columnTitleformat);
//    }
//    //保存
//    workbook_close(workbook);
//}

@end
