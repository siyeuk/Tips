//
//  MTWebRTC.m
//  Tips
//
//  Created by lss on 2022/11/10.
//

#import "MTWebRTC.h"
#import <SRWebSocket.h>

@interface MTWebRTC ()<SRWebSocketDelegate, RTCPeerConnectionDelegate>{
    NSString *_room;
}

@property (nonatomic, strong) SRWebSocket *socket;

@property (nonatomic, strong) RTCVideoSource *videoSource;

@property (nonatomic, strong) RTCPeerConnectionFactory *peerConnectionFactory;

@property (nonatomic, strong) RTCCameraVideoCapturer *videoCapturer;
@property (nonatomic, strong) RTCVideoTrack *localVideoTrack;
@property (nonatomic, strong) RTCAudioTrack *localAudioTrack;
@property (nonatomic, strong) RTCDataChannel *localDataChannel;
@property (nonatomic, strong) RTCAudioSession *rtcAudioSession;
@property (nonatomic, strong) RTCMediaStream *localStream;

@property (nonatomic, strong) RTCPeerConnection *peerConnection;

@property (nonatomic, strong) RTCMediaConstraints *offerOranswerConstraint;

@end


@implementation MTWebRTC


- (void)connectServer:(NSString *)server room:(NSString *)room{
    _room = room;
    self.socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:3000",server]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10]];
    self.socket.delegate = self;
    [self.socket open];
}
- (void)joinRoom{
    [self sendDic:@{@"eventName": @"__join", @"data": @{@"room": _room?:@""}}];
    
    AVCaptureDevice *frontCamera;
    NSArray <AVCaptureDevice *>*devices = [RTCCameraVideoCapturer captureDevices];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionFront){
            frontCamera = device;
            break;
        }
    }
    // 选择最高配置
    NSArray<AVCaptureDeviceFormat *> *formats = [RTCCameraVideoCapturer supportedFormatsForDevice:frontCamera];
    AVCaptureDeviceFormat *highestFormat = formats.firstObject;
    for (AVCaptureDeviceFormat *format in formats) {
        if (CMVideoFormatDescriptionGetDimensions(format.formatDescription).width > CMVideoFormatDescriptionGetDimensions(highestFormat.formatDescription).width) {
            highestFormat = format;
        }
    }
    // 选择最高分辨率
    NSArray<AVFrameRateRange *> *fpsArray = highestFormat.videoSupportedFrameRateRanges;
    AVFrameRateRange *highestFps = fpsArray.firstObject;
    for (AVFrameRateRange *fps in fpsArray) {
        if (fps.maxFrameRate > highestFps.maxFrameRate) {
            highestFps = fps;
        }
    }
    [self.videoCapturer startCaptureWithDevice:frontCamera format:highestFormat fps:(NSInteger)highestFps completionHandler:^(NSError * _Nonnull error) {
        
    }];
    [self webRTC:self setLocalStream:self.localStream userId:@""];
}
- (void)webRTC:(MTWebRTC *)webRTC setLocalStream:(RTCMediaStream *_Nullable)stream userId:(NSString *)userId{
    
}
- (void)sendDic:(NSDictionary *)dic{
    if (self.socket.readyState == SR_OPEN) {
        [self.socket sendData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] error:nil];
    }
}
- (void)exitRoom{
    _localStream = nil;
    
}
- (RTCPeerConnectionFactory *)peerConnectionFactory{
    if (!_peerConnectionFactory) {
        // 如果想要更加安全就开启SSL。
        //        RTCInitializeSSL();
        RTCDefaultVideoEncoderFactory *videoEncoder = [[RTCDefaultVideoEncoderFactory alloc] init];
        RTCDefaultVideoDecoderFactory *videoDecoder = [[RTCDefaultVideoDecoderFactory alloc] init];
        _peerConnectionFactory = [[RTCPeerConnectionFactory alloc] initWithEncoderFactory:videoEncoder decoderFactory:videoDecoder];
    }
    return _peerConnectionFactory;
}
- (RTCMediaStream *)localStream{
    if (!_localStream) {
        // 创建本地流
        // 初始化媒体流，ARDAMSa0和ARDAMS为专业标识符。
        _localStream = [self.peerConnectionFactory mediaStreamWithStreamId:@"ARDAMS"];
        // 添加音频
        [_localStream addAudioTrack:self.localAudioTrack];
        // 添加视频
        [_localStream addVideoTrack:self.localVideoTrack];
    }
    return _localStream;
}
- (RTCAudioTrack *)localAudioTrack{
    if (!_localAudioTrack) {
        RTCMediaConstraints *audioConstrains = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:nil optionalConstraints:nil];
        RTCAudioSource *audioSource = [self.peerConnectionFactory audioSourceWithConstraints:audioConstrains];
        _localAudioTrack = [self.peerConnectionFactory audioTrackWithSource:audioSource trackId:@"ARDAMSa0"];
    }
    return _localAudioTrack;
}
- (RTCVideoSource *)videoSource{
    if (!_videoSource){
        /**获取数据源
         *一是表明它是一个视频源。当我们要展示视频的时候，就从这里获取数据；
         *另一方面，它也是一个终点。即，当我们从视频设备采集到视频数据时，要交给它暂存起来
         */
        _videoSource = [self.peerConnectionFactory videoSource];
    }
    return _videoSource;
}
- (RTCVideoTrack *)localVideoTrack{
    if (!_localVideoTrack) {
        _localVideoTrack = [self.peerConnectionFactory videoTrackWithSource:self.videoSource trackId:@"ARDAMSv0"];
    }
    return _localVideoTrack;
}
- (RTCCameraVideoCapturer *)videoCapturer{
    if (!_videoCapturer) {
        _videoCapturer = [[RTCCameraVideoCapturer alloc] initWithDelegate:self.videoSource];
    }
    return _videoCapturer;
}

- (RTCDataChannel *)localDataChannel{
    if (!_localDataChannel) {
        RTCDataChannelConfiguration *config = [[RTCDataChannelConfiguration alloc] init];
        _localDataChannel = [self.peerConnection dataChannelForLabel:@"WebRTCData" configuration:config];
        _localDataChannel.delegate = self;
    }
    return _localDataChannel;
}
- (RTCMediaConstraints *)offerOranswerConstraint{
    if (!_offerOranswerConstraint) {
        NSDictionary *mediaConstrains = @{kRTCMediaConstraintsOfferToReceiveAudio: kRTCMediaConstraintsValueTrue,
                                          kRTCMediaConstraintsOfferToReceiveVideo: kRTCMediaConstraintsValueTrue};
        _offerOranswerConstraint = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:mediaConstrains optionalConstraints:nil];
    }
    return _offerOranswerConstraint;
}


// 创建点对点连接
- (RTCPeerConnection *)createPeerConnection{
//    NSArray *iceServers =  @[@"stun:stun.l.google.com:19302",
//                             @"stun:stun1.l.google.com:19302",
//                             @"stun:stun2.l.google.com:19302",
//                             @"stun:stun3.l.google.com:19302",
//                             @"stun:stun4.l.google.com:19302"];
    RTCConfiguration *config = [[RTCConfiguration alloc] init];
    //    config.iceServers = @[[[RTCIceServer alloc] initWithURLStrings:iceServers]];
    // // 统一方案比方案b更好
    //    config.sdpSemantics = RTCSdpSemanticsUnifiedPlan;
    // gathercontinual将允许WebRTC监听任何网络变化，并将任何新的候选客户机发送到另一个客户机
    config.continualGatheringPolicy = RTCContinualGatheringPolicyGatherContinually;
    
    RTCMediaConstraints *mediaConstraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:nil optionalConstraints:@{@"DtlsSrtpKeyAgreement":kRTCMediaConstraintsValueTrue}];
    RTCPeerConnection *connection = [self.peerConnectionFactory peerConnectionWithConfiguration:config constraints:mediaConstraints delegate:self];
    return connection;
}
// 关闭 PeerConnection
- (void)closePeerConnection:(RTCPeerConnection *)peerConnection{
    if (peerConnection) {
        [peerConnection close];
    }
}
#pragma mark - SRWebSocketDelegate -
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
   
}
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"websocket 建立成功");
    [self joinRoom];
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"建立连接失败 : %ld:%@",(long)error.code, error.localizedDescription);
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"连接关闭 : %ld:%@",(long)code, reason);
}

#pragma mark - RTCPeerConnectionDelegate -
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeSignalingState:(RTCSignalingState)stateChanged{
    NSLog(@"信令状态改变 %ld",(long)stateChanged);
}
- (void)peerConnection:(RTCPeerConnection *)peerConnection didAddStream:(RTCMediaStream *)stream{

}
- (void)peerConnection:(RTCPeerConnection *)peerConnection didRemoveStream:(RTCMediaStream *)stream{
    NSLog(@"远程peer关闭一个流");
}
- (void)peerConnectionShouldNegotiate:(RTCPeerConnection *)peerConnection{
    NSLog(@"需要协商，比如ICE已经重启");
}
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeIceConnectionState:(RTCIceConnectionState)newState{
    NSLog(@"当IceConnectionState改变的时候");
}
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeIceGatheringState:(RTCIceGatheringState)newState{
    NSLog(@"当IceGatheringState改变的时候");
}
- (void)peerConnection:(RTCPeerConnection *)peerConnection didGenerateIceCandidate:(RTCIceCandidate *)candidate{
    NSLog(@"发现新的 ice candidate");
//    _currentId = [self getKeyFromConnectionDic:peerConnection];
//    NSDictionary *dic = @{@"eventName": @"__ice_candidate", @"data": @{@"id":candidate.sdpMid,@"label": [NSNumber numberWithInteger:candidate.sdpMLineIndex], @"candidate": candidate.sdp, @"socketId": _currentId}};
//    [_socket sendData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] error:nil];
}
- (void)peerConnection:(RTCPeerConnection *)peerConnection didRemoveIceCandidates:(NSArray<RTCIceCandidate *> *)candidates{
    NSLog(@">>>%s",__func__);
}
- (void)peerConnection:(RTCPeerConnection *)peerConnection didOpenDataChannel:(RTCDataChannel *)dataChannel{
    NSLog(@"New data channel has been opened");
}


- (NSString *)getKeyFromConnectionDic:(RTCPeerConnection *)peerConnection{
    static NSString *socketId;
//    [self.connectionDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, RTCPeerConnection *obj, BOOL * _Nonnull stop) {
//        if ([obj isEqual:peerConnection]) {
////            NSLog(@"获取到的key：%@",key);
//            socketId = key;
//        }
//    }];
    return socketId;
}


@end
