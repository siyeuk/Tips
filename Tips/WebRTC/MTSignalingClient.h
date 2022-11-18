//
//  MTSignalingClient.h
//  Tips
//
//  Created by lss on 2022/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MTSignalingClient;
@protocol MTSignalingClientDelegate <NSObject>

@optional
- (void)signalingClient:(MTSignalingClient *)client error:(NSError *)error;
- (void)signalingClient:(MTSignalingClient *)client receiveMessage:(NSDictionary *)message;
- (void)signalingClientDidOpen:(MTSignalingClient *)client;


@end

@interface MTSignalingClient : NSObject

@property (nonatomic, weak) id<MTSignalingClientDelegate> delegate;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithUrl:(NSURL *)url;

- (void)connect;



- (void)sendDic:(NSDictionary *)dic;


@end

NS_ASSUME_NONNULL_END
