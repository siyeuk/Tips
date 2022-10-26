//
//  MTAPMMemoryDisk.h
//  MT_Tips
//
//  Created by lss on 2022/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 内存磁盘容量监控
@interface MTAPMMemoryDisk : NSObject

///当前应用的内存占用情况，和Xcode数值相近 单位MB
+ (double)getAppUsageMemory;
///剩余空闲内存  单位MB
+ (double)getFreeMemory;
/// 总共的内存大小  单位MB
+ (double)getTotalMemory;

///filePath目录下的文件 占用的磁盘大小  单位MB  默认沙盒Caches目录   此句代码不要频繁定时执行，比较耗内存
+ (double)getFileUsageDisk:(NSString *)filePath;
///剩余空闲的磁盘容量  单位G
+ (double)getFreeDisk;
///总磁盘容量  单位G
+ (double)getTotalDisk;

@end

NS_ASSUME_NONNULL_END
