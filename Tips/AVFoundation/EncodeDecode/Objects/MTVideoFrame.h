//
//  MTVideoFrame.h
//  MT_Tips
//
//  Created by lss on 2022/10/13.
//

#import "MTFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTVideoFrame : MTFrame

@property (nonatomic, assign) BOOL   isKeyFrame;
@property (nonatomic, strong) NSData *sps;
@property (nonatomic, strong) NSData *pps;

@end

NS_ASSUME_NONNULL_END
