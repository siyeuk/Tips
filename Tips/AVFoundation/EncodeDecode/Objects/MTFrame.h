//
//  MTFrame.h
//  MT_Tips
//
//  Created by lss on 2022/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFrame : NSObject

@property (nonatomic, assign) uint64_t  timestamp;
@property (nonatomic, strong) NSData    *data;

@end

NS_ASSUME_NONNULL_END
