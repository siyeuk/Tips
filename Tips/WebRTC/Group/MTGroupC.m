//
//  MTGroupC.m
//  Tips
//
//  Created by lss on 2022/11/10.
//

#import "MTGroupC.h"
#import "MTGroupWebRTC.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#define KVideoWidth KScreenWidth/3.0
#define KVideoHeight KVideoWidth*320/240

@interface MTGroupC ()<MTGroupWebRTCDelegate>{
    NSMutableDictionary *_remoteVideoTracks;
}

@property (nonatomic, strong) MTGroupWebRTC *groupWebRTC;

@end

@implementation MTGroupC

- (void)viewDidLoad {
    [super viewDidLoad];
    _remoteVideoTracks = [NSMutableDictionary dictionary];
    
    self.groupWebRTC = [[MTGroupWebRTC alloc] init];
    self.groupWebRTC.delegate = self;
    [self.groupWebRTC connectServer:@"10.32.99.68" room:@"100"];
    
}
#pragma mark - MTGroupWebRTCDelegate -
- (void)webRTC:(MTGroupWebRTC *)webRTC setLocalStream:(RTCMediaStream *_Nullable)stream userId:(NSString *)userId{
    if (stream) {
        RTCMTLVideoView *videoView = [[RTCMTLVideoView alloc] initWithFrame:CGRectMake(0, 200, KVideoWidth, KVideoHeight)];
        videoView.tag = 100;
        [stream.videoTracks.firstObject addRenderer:videoView];
        [self.view addSubview:videoView];
    }
}
- (void)webRTC:(MTWebRTC *)webRTC addRemoteStream:(RTCMediaStream *_Nullable)stream userId:(NSString *)userId{
    [_remoteVideoTracks removeAllObjects];
    [_remoteVideoTracks setObject:stream.videoTracks.firstObject forKey:userId];
    [self refreshRemoterView];
}
- (void)webRTC:(MTWebRTC *)webRTC closeWithUserId:(NSString *)userId{
    [_remoteVideoTracks removeObjectForKey:userId];
    [self refreshRemoterView];
}
- (void)refreshRemoterView{
    for (RTCEAGLVideoView *videoView in self.view.subviews) {
        //本地的视频View和关闭按钮不做处理
        if (videoView.tag == 100 ||videoView.tag == 123) {
            continue;
        }
        //其他的移除
        [videoView removeFromSuperview];
    }
    __block int column = 1;
    __block int row = 0;
    //再去添加
    [_remoteVideoTracks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, RTCVideoTrack *remoteTrack, BOOL * _Nonnull stop) {
        RTCEAGLVideoView *remoteVideoView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(column * KVideoWidth, 0, KVideoWidth, KVideoHeight)];
        [remoteTrack addRenderer:remoteVideoView];
        [self.view addSubview:remoteVideoView];
        //列加1
        column++;
        //一行多余3个在起一行
        if (column > 3) {
            row++;
            column = 0;
        }
    }];
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
