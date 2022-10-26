//
//  MTAudioEncoding.h
//  MT_Tips
//
//  Created by lss on 2022/10/13.
//

#import <Foundation/Foundation.h>
#import "MTAudioFrame.h"
#import "MTLiveAudioConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MTAudioEncoding <NSObject>
@required;
- (void)encodeAudioData:(nullable NSData*)audioData timeStamp:(uint64_t)timeStamp;
- (void)stopEncoder;

@end

NS_ASSUME_NONNULL_END
