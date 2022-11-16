//
//  MTWebRTC.h
//  Tips
//
//  Created by lss on 2022/11/10.
//

#import <Foundation/Foundation.h>
#import <WebRTC/WebRTC.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTWebRTC : NSObject

@property (nonatomic, strong, readonly) RTCPeerConnectionFactory *peerConnectionFactory;

@property (nonatomic, strong, readonly) RTCCameraVideoCapturer *videoCapturer;
@property (nonatomic, strong, readonly) RTCVideoTrack *localVideoTrack;
@property (nonatomic, strong, readonly) RTCAudioTrack *localAudioTrack;
@property (nonatomic, strong, readonly) RTCDataChannel *localDataChannel;
@property (nonatomic, strong, readonly) RTCAudioSession *rtcAudioSession;
@property (nonatomic, strong, readonly) RTCMediaStream *localStream;
@property (nonatomic, strong, readonly) RTCMediaConstraints *offerOranswerConstraint;

- (void)connectServer:(NSString *)server room:(NSString *)room;
- (void)sendDic:(NSDictionary *)dic;
- (void)exitRoom;

// 创建点对点连接
- (RTCPeerConnection *)createPeerConnection;
// 关闭 PeerConnection
- (void)closePeerConnection:(RTCPeerConnection *)peerConnection;

- (void)webRTC:(MTWebRTC *)webRTC setLocalStream:(RTCMediaStream *_Nullable)stream userId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
