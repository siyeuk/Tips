//
//  MTSignalingClient.m
//  Tips
//
//  Created by lss on 2022/11/9.
//

#import "MTSignalingClient.h"
#import <SRWebSocket.h>

@interface MTSignalingClient ()<SRWebSocketDelegate>{
    NSString *_room;
}

@property (nonatomic, strong) SRWebSocket *socket;

@end

@implementation MTSignalingClient

- (instancetype)initWithUrl:(NSURL *)url{
    if (self = [super init]) {
        [self createClient:url];
    }
    return self;
}
- (void)createClient:(NSURL *)url{
    self.socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10]];
    self.socket.delegate = self;
}

- (void)connect{
    [self.socket open];
}

- (void)sendDic:(NSDictionary *)dic{
    NSError *error = nil;
    if (self.socket.readyState == SR_OPEN) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        if (!error){
            [self.socket sendData:data error:&error];
        }
    }else{
        error = [NSError errorWithDomain:@"socket尚未连接成功" code:-1 userInfo:nil];
    }
    if (!error) return;
    if ([self.delegate respondsToSelector:@selector(signalingClient:error:)]){
        [self.delegate signalingClient:self error:error];
    }
}


#pragma mark - SRWebSocketDelegate -
// socket连接成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    if ([self.delegate respondsToSelector:@selector(signalingClientDidOpen:)]) {
        [self.delegate signalingClientDidOpen:self];
    }
}
// 收到服务器数据
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"收到服务器数据");
    if ([self.delegate respondsToSelector:@selector(signalingClient:receiveMessage:)]) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        [self.delegate signalingClient:self receiveMessage:dic];
    }
}
// 建立连接失败
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(signalingClient:error:)]){
        [self.delegate signalingClient:self error:error];
    }
}
// 连接关闭
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    if ([self.delegate respondsToSelector:@selector(signalingClient:error:)]){
        NSError *error = [NSError errorWithDomain:@"socket连接关闭" code:code userInfo:@{@"reason":reason?:@""}];
        [self.delegate signalingClient:self error:error];
    }
}



@end
