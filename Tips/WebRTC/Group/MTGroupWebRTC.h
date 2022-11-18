//
//  MTGroupWebRTC.h
//  Tips
//
//  Created by lss on 2022/11/10.
//

#import "MTWebRTC.h"

NS_ASSUME_NONNULL_BEGIN

@class MTGroupWebRTC;
@protocol MTGroupWebRTCDelegate <NSObject>

@optional
- (void)webRTC:(MTGroupWebRTC *)webRTC setLocalStream:(RTCMediaStream *_Nullable)stream userId:(NSString *)userId;
- (void)webRTC:(MTWebRTC *)webRTC addRemoteStream:(RTCMediaStream *_Nullable)stream userId:(NSString *)userId;
- (void)webRTC:(MTWebRTC *)webRTC closeWithUserId:(NSString *)userId;

@end

@interface MTGroupWebRTC : MTWebRTC

@property (nonatomic, weak) id<MTGroupWebRTCDelegate> delegate;

- (void)connectServer:(NSString *)server room:(NSString *)room;

@end

NS_ASSUME_NONNULL_END
