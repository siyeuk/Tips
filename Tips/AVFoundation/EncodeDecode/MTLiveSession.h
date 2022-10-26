//
//  MTLiveSession.h
//  MT_Tips
//
//  Created by lss on 2022/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 捕获的数据类型
typedef NS_ENUM(NSInteger, MTSystemCaptureType) {
    MTSystemCaptureTypeVideo = 0,
    MTSystemCaptureTypeAudio,
    MTSystemCaptureTypeAll
};

@interface MTLiveSession : NSObject



@end

NS_ASSUME_NONNULL_END
