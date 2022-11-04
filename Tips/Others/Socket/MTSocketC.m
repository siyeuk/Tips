//
//  MTSocketC.m
//  Tips
//
//  Created by lss on 2022/11/2.
//

#import "MTSocketC.h"



@interface MTSocketC ()<NSURLSessionDelegate, NSURLSessionWebSocketDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLSessionWebSocketTask *socket;
@property (nonatomic, strong) NSURLSession *urlSession;

@end

@implementation MTSocketC

- (void)viewDidLoad {
    [super viewDidLoad];
    // iOS 13可用
    self.url = [NSURL URLWithString:@""];
    self.urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    [self.urlSession downloadTaskWithURL:self.url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    
    // Do any additional setup after loading the view.
}

- (void)connect{
    /**maximumMessageSize
     *在接收消息失败之前缓冲的最大字节数
     * 该值包括连续帧中所有字节的总和，一旦任务达到这个限制，receive 就会失败。
     */
    self.socket = [self.urlSession webSocketTaskWithURL:self.url];
    [self.socket resume];
}
- (void)disconnect{
    [self.socket cancel];
    self.socket = nil;
}
- (void)sendData:(NSData *)data{
    /** 发送一个WebSocket消息
     * @param message 待发送的WebSocket消息
     * @param completionHandler 接收发送结果，发送失败返回 error ；发送成功则error=nil
     *        如果出现错误，任何未完成的工作也将失败；
     * @note completionHandler的调用并不保证远程端已经接收到所有字节，只是它们已经被写入到内核。
     */
    [self.socket sendMessage:[[NSURLSessionWebSocketMessage alloc] initWithData:data] completionHandler:^(NSError * _Nullable error) {
        if (error) {
//            NSErrorDomain *domain = [NSCocoaErrorDomain dealloc];
            NSError *e = [NSError errorWithDomain:NSMachErrorDomain code:-1 userInfo:@{}];
            
        }
    }];
}
- (void)readMessage{
    
    /** 一旦消息的所有frames可用，读取一个WebSocket消息
     * @param completionHandler 读取结果，成功获取message，失败返回 error；
     * @note 在缓冲frames时，如果达到了 maximumMessage ，则receiveMessage调用将出错，所有未完成的工作也将失败，导致任务结束。
     */
    [self.socket receiveMessageWithCompletionHandler:^(NSURLSessionWebSocketMessage * _Nullable message, NSError * _Nullable error) {
        if (error) {
            
        }else {
            NSLog(@"获取到的数据 :%@",[[NSString alloc] initWithData:message.data encoding:NSUTF8StringEncoding]);
        }
    }];
}
/** 从客户端发送一个ping帧，带有一个从服务器端点接收pong的闭包。
 * * @param pongReceiveHandler 当客户端收到来自服务器端点的pong时，该Block被调用；
 *          如果在接收服务器端点pong之前连接丢失或发生错误，该Block被调用返回错误信息
 *      当发送多个ping时 ，pongReceiveHandler 将总是按照客户端发送 ping 的顺序被调用；
 *
 * @discussion Ping-pong  是一种数据传输技术，本质是一种数据缓冲的手段；同时利用客户端、服务器两个数据缓冲区达到数据连续传输的目的：
 *   客户端不必等待服务器的处理结果，继续执行并将结果保存在ping路的缓存中；客户端执行到一定时刻，服务端处理完成将结果 保存在pong路中；
 *  这样服务端模块无需等待继续执行，客户端也无需等待继续执行，转而将结果存储在ping路；提高了处理效率。
 *
 * 单个缓冲区得到的数据在传输和处理中很容易被覆盖，而 Ping-pong  缓冲区的方式能够总是保持一个缓冲区的数据被利用，另一个缓冲去用于存储数据；即两个相同的对象作为缓冲区交替地被读和 被写。
 */
- (void)sendPing{
    [self.socket sendPingWithPongReceiveHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"error: %@",error.debugDescription);
            NSLog(@"error userInfo: %@",error.userInfo);
        }
    }];
}
- (void)cancelWithCloseCode{
    /** 使用指定的 closeCode 发送一个关闭帧，同时可以提供关闭的原因
     * @param closeCode 关闭连接的原因
     * @param reason 进一步解释为何关闭，由客户端自定义，可传 nil；
     * @note 如果调用 [NSURLSessionTask cancel] 而非该方法，它会发送一个没有closeCode或reason的关闭帧；
    */
//    self.socket cancelWithCloseCode:<#(NSURLSessionWebSocketCloseCode)#> reason:<#(nullable NSData *)#>
}
#pragma mark - NSURLSessionWebSocketDelegate -
// 表示WebSocket握手成功，连接已经升级到WebSocket。它还将提供在握手中选择的协议。如果握手失败，将不会调用此委托。
- (void)URLSession:(NSURLSession *)session webSocketTask:(NSURLSessionWebSocketTask *)webSocketTask didOpenWithProtocol:(nullable NSString *) protocol{
    
}
// 表示 WebSocket 已收到来自服务器端点的关闭帧。如果服务器选择在关闭帧中发送此信息，则委托可以提供关闭代码和关闭原因。
- (void)URLSession:(NSURLSession *)session webSocketTask:(NSURLSessionWebSocketTask *)webSocketTask didCloseWithCode:(NSURLSessionWebSocketCloseCode)closeCode reason:(nullable NSData *)reason{
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
