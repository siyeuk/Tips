//
//  MTGroupWebRTC.m
//  Tips
//
//  Created by lss on 2022/11/10.
//

#import "MTGroupWebRTC.h"
#import <SRWebSocket.h>

typedef enum : NSUInteger {
    // 发送者
    RoleCaller,
    // 被发送者
    RoleCallee,
} Role;

@interface MTGroupWebRTC (){
    NSString *_myId;
    NSMutableArray *_connectionIdArray;
    NSMutableDictionary *_connectionDictionary;
    Role _role;
    NSString *_currentId;
}

@end

@implementation MTGroupWebRTC

- (instancetype)init{
    if (self = [super init]) {
        _connectionIdArray = [NSMutableArray array];
        _connectionDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)connectServer:(NSString *)server room:(NSString *)room{
    [super connectServer:server room:room];
}
- (void)webRTC:(MTWebRTC *)webRTC setLocalStream:(RTCMediaStream *_Nullable)stream userId:(NSString *)userId{
    if ([self.delegate respondsToSelector:@selector(webRTC:setLocalStream:userId:)]) {
        [self.delegate webRTC:self setLocalStream:stream userId:_myId];
    }
}
#pragma mark - 处理收到不同消息后的操作 -
- (void)messageWithMessage:(NSDictionary *)dic{
    NSString *eventName = dic[@"eventName"];
    // 发送加入房间后的反馈
    if ([eventName isEqualToString:@"_peers"]) {
        // 得到data
        NSDictionary *dataDic = dic[@"data"];
        // 得到所有的连接
        NSArray *connections = dataDic[@"connections"];
        // 加到连接数组中去
        [_connectionIdArray addObjectsFromArray:connections];
        // 拿到给自己分配的ID
        _myId = dataDic[@"you"];
        [self createPeerConnectionAddStream];
        [self createOffers];
    }
    // 接收到新加入的人发了ICE候选，（即经过ICEServer而获取到的地址）
    else if ([eventName isEqualToString:@"_ice_candidate"]) {
        NSDictionary *dataDic = dic[@"data"];
        NSString *socketId = dataDic[@"socketId"];
        NSString *sdpMid = dataDic[@"id"];
        int sdpMLineIndex = [dataDic[@"label"] intValue];
        NSString *sdp = dataDic[@"candidate"];
        // 生成远端网络地址对象
        RTCIceCandidate *candidate = [[RTCIceCandidate alloc] initWithSdp:sdp sdpMLineIndex:sdpMLineIndex sdpMid:sdpMid];
        // 拿到当前对应的点对点连接
        RTCPeerConnection *peerConnection = [_connectionDictionary objectForKey:socketId];
        // 添加到点对点连接中
        [peerConnection addIceCandidate:candidate];
    }
    // 其他新人加入房间的信息
    else if ([eventName isEqualToString:@"_new_peer"]){
        NSDictionary *dataDic = dic[@"data"];
        //拿到新人的ID
        NSString *socketId = dataDic[@"socketId"];
        //再去创建一个连接
        RTCPeerConnection *peerConnection = [self createPeerConnection];
        // 把本地流加到连接中去
        [peerConnection addStream:self.localStream];
        //连接ID新加一个
        [_connectionIdArray addObject:socketId];
        //并且设置到Dic中去
        [_connectionDictionary setObject:peerConnection forKey:socketId];
    }
    //有人离开房间的事件
    else if ([eventName isEqualToString:@"_remove_peer"]){
        //得到socketId，关闭这个peerConnection
        NSDictionary *dataDic = dic[@"data"];
        NSString *socketId = dataDic[@"socketId"];
        RTCPeerConnection *peerConnection = [_connectionDictionary objectForKey:socketId];
        [_connectionDictionary removeObjectForKey:socketId];
        [_connectionIdArray removeObject:socketId];
        if ([self.delegate respondsToSelector:@selector(webRTC:closeWithUserId:)]) {
            [self.delegate webRTC:self closeWithUserId:socketId];
        }
        [self closePeerConnection:peerConnection];
    }
    // 这个新加入的人发了个offer
    else if ([eventName isEqualToString:@"_offer"]){
        NSDictionary *dataDic = dic[@"data"];
        NSDictionary *sdpDic = dataDic[@"sdp"];
        // 拿到SDP
        NSString *sdp = sdpDic[@"sdp"];
        NSString *type = sdpDic[@"type"];
        NSString *socketId = dataDic[@"socketId"];
        
        RTCSdpType sdpType = ([type isEqualToString:@"offer"] ? RTCSdpTypeOffer : RTCSdpTypeAnswer);
        // 拿到这个点对点的连接
        RTCPeerConnection *connection = [_connectionDictionary objectForKey:socketId];
        // 根据类型和SDP 生成SDP描述对象
        RTCSessionDescription *remoteSdp = [[RTCSessionDescription alloc] initWithType:sdpType sdp:sdp];
        if (sdpType == RTCSdpTypeOffer) {
            // 设置给这个点对点连接
            __weak typeof(connection) wConnection = connection;
            // B:设置连接对端 SDP
            [connection setRemoteDescription:remoteSdp completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"❌❌❌❌setRemoteDescription ERROR❌❌❌❌");
                }
                [self didSetSessionDescription:wConnection];
            }];
        }
        // 把当前的ID保存下来
        _currentId = socketId;
        // 设置当前角色状态为被呼叫，（被发offer）
        _role = RoleCallee;
    }
    // 收到别人的offer，而回复answer
    else if ([eventName isEqualToString:@"_answer"]){
        NSDictionary *dataDic = dic[@"data"];
        NSDictionary *sdpDic = dataDic[@"sdp"];
        NSString *sdp = sdpDic[@"sdp"];
        NSString *type = sdpDic[@"type"];
        NSString *socketId = dataDic[@"socketId"];
        RTCSdpType sdpType = ([type isEqualToString:@"offer"] ? RTCSdpTypeOffer : RTCSdpTypeAnswer);
        RTCPeerConnection *connection = [_connectionDictionary objectForKey:socketId];
        RTCSessionDescription *remoteSdp = [[RTCSessionDescription alloc] initWithType:sdpType sdp:sdp];
        if (sdpType == RTCSdpTypeAnswer) {
            __weak typeof(connection) wConnection = connection;
            /**应用提供的RTCSessionDescription作为远程描述。*/
            // A:设置连接对端 SDP
            [connection setRemoteDescription:remoteSdp completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"❌❌❌❌setRemoteDescription ERROR❌❌❌❌");
                }
                [self didSetSessionDescription:wConnection];
            }];
        }
    }
}

#pragma mark - Private -
// 创建所有连接 并为连接添加本地流 发送offer
- (void)createPeerConnectionAddStream{
    [_connectionIdArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //初始化 RTCPeerConnection 连接对象
        RTCPeerConnection *connection = [self createPeerConnection];
        // 为连接添加本地流
        [connection addStream:self.localStream];
        // 设置这个ID对应的 RTCPeerConnection对象
        [_connectionDictionary setObject:connection forKey:obj];
    }];
}
// 为所有连接创建offer
- (void)createOffers{
    [_connectionDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, RTCPeerConnection *obj, BOOL * _Nonnull stop) {
        [self sendSDPOfferToConnection:obj];
    }];
}
- (void)sendSDPOfferToConnection:(RTCPeerConnection *)connection{
    _role = RoleCaller;
    // 生成一个SDP offer
    [connection offerForConstraints:self.offerOranswerConstraint completionHandler:^(RTCSessionDescription * _Nullable sdp, NSError * _Nullable error) {
        if (error) {
            NSLog(@"❌❌❌❌offerForConstraints ERROR❌❌❌❌");
            return;
        }
        if (sdp.type == RTCSdpTypeOffer) {
            __weak typeof(connection) wConnection = connection;
            /**应用提供的RTCSessionDescription作为本地描述。*/
            // A:设置连接本端 SDP
            [connection setLocalDescription:sdp completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"❌❌❌❌setLocalDescription ERROR❌❌❌❌");
                    return;
                }
                [self didSetSessionDescription:wConnection];
            }];
        }
    }];
}
#pragma mark - mark -
/*
 此处是关键点，上面所有的操作都在为此做准备。发送offer的过程如下
 通过 RTCPeerConnection 对象的offerForConstraints:生成 sdp offer
 将拿到的sdp 通过RTCPeerConnection 对象的setLocalDescription:设置为本地sdp
 本地sdp设置成功后需要通过信令将本端sdp发送到对端
 */
- (void)didSetSessionDescription:(RTCPeerConnection *)connection{
    NSLog(@"signalingState:%zd role:%zd", connection.signalingState, _role);
    NSString *connectionID = [self getKeyFromConnectionDic:connection];
    // 新人进入房间就调(远端发起 offer)
    if (connection.signalingState == RTCSignalingStateHaveRemoteOffer){
        /** Generate an SDP answer. */
        [connection answerForConstraints:self.offerOranswerConstraint completionHandler:^(RTCSessionDescription * _Nullable sdp, NSError * _Nullable error) {
            if (error) {
                NSLog(@"❌❌❌❌answerForConstraints ERROR❌❌❌❌");
                return;
            }
            if (sdp.type == RTCSdpTypeAnswer) {
                __weak typeof(connection) wConnection = connection;
                // B:设置连接本端 SDP
                [connection setLocalDescription:sdp completionHandler:^(NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"❌❌❌❌setLocalDescription ERROR❌❌❌❌");
                        return;
                    }
                    [self didSetSessionDescription:wConnection];
                }];
            }
        }];
    }
    // 本地发送 offer
    else if (connection.signalingState == RTCSignalingStateHaveLocalOffer) {
        if (_role == RoleCaller) {
            NSDictionary *dic = @{@"eventName": @"__offer",
                                  @"data": @{@"sdp": @{@"type": @"offer",
                                                       @"sdp": connection.localDescription.sdp},
                                             @"socketId": connectionID}};
            [self sendDic:dic];
        }
    }
    // 本地发送 answer
    else if (connection.signalingState == RTCSignalingStateStable) {
        if (_role == RoleCallee) {
            NSDictionary *dic = @{@"eventName": @"__answer",
                                  @"data": @{@"sdp": @{@"type": @"answer",
                                                       @"sdp": connection.localDescription.sdp},
                                             @"socketId": connectionID}};
            [self sendDic:dic];;
        }
    }
}
#pragma mark - tool -
- (NSString *)getKeyFromConnectionDic:(RTCPeerConnection *)peerConnection{
    static NSString *socketId;
    [_connectionDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, RTCPeerConnection *obj, BOOL * _Nonnull stop) {
        if ([obj isEqual:peerConnection]) {
            NSLog(@"获取到的key：%@",key);
            socketId = key;
        }
    }];
    return socketId;
}
#pragma mark - SRWebSocketDelegate -
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"收到服务器消息：%@", dic);
    [self messageWithMessage:dic];
}

#pragma mark - RTCPeerConnectionDelegate -
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeSignalingState:(RTCSignalingState)stateChanged{
    NSLog(@"信令状态改变 %ld",(long)stateChanged);
}
- (void)peerConnection:(RTCPeerConnection *)peerConnection didAddStream:(RTCMediaStream *)stream{
    NSLog(@"从远程peer收到一个新的流");
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(webRTC:addRemoteStream:userId:)]) {
            NSString *userId = [self getKeyFromConnectionDic:peerConnection];
            [self.delegate webRTC:self addRemoteStream:stream userId:userId];
        }
    });
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
    NSString *socketId = [self getKeyFromConnectionDic:peerConnection];
    NSDictionary *dic = @{@"eventName": @"__ice_candidate", @"data": @{@"id":candidate.sdpMid,@"label": [NSNumber numberWithInteger:candidate.sdpMLineIndex], @"candidate": candidate.sdp, @"socketId": socketId?:@""}};
    [self sendDic:dic];
}
- (void)peerConnection:(RTCPeerConnection *)peerConnection didRemoveIceCandidates:(NSArray<RTCIceCandidate *> *)candidates{
    NSLog(@">>>%s",__func__);
}
- (void)peerConnection:(RTCPeerConnection *)peerConnection didOpenDataChannel:(RTCDataChannel *)dataChannel{
    NSLog(@"New data channel has been opened");
}



@end
