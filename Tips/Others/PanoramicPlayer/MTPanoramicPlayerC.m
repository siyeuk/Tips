//
//  MTPanoramicPlayerC.m
//  Tips
//
//  Created by lss on 2022/10/26.
//

#import "MTPanoramicPlayerC.h"
#import <SceneKit/SceneKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

#define SHPERE_RADIUS 10
#define CAMERA_FOX 1.0
#define CAMERA_HEIGHT 1.0
#define VEDIO_WIDHT 1
#define VEDIO_HEIGHT 1

@interface MTPanoramicPlayerC ()
// 3D场景
@property (nonatomic, strong) SCNScene *scene;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) SKVideoNode *vedioNode;
@property (nonatomic, strong) SKScene *skScene;

@property (nonatomic, strong) id observerPlayerTime;

@end

@implementation MTPanoramicPlayerC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建一个3D场景
    self.scene = [SCNScene scene];
    
    // 创建球体
    SCNNode *sphereNode = [SCNNode node];
    sphereNode.geometry = [SCNSphere sphereWithRadius:SHPERE_RADIUS];
    sphereNode.rotation = SCNVector4Make(1, 0, 0, -M_PI/2);
    sphereNode.geometry.firstMaterial.cullMode = SCNCullModeFront;// 设置剔除外表面
    sphereNode.geometry.firstMaterial.doubleSided = false; // 设置只渲染一个表面
    [self.scene.rootNode addChildNode:sphereNode];
    
    // 创建一个眼睛节点,放入场景的中心点
    SCNNode *eyeNode = [SCNNode node];
    eyeNode = [SCNNode node];
    eyeNode.camera = [SCNCamera camera];
    // 创建照相机对象 就是眼睛
    eyeNode.camera.automaticallyAdjustsZRange = true; // 自动添加可视距离
    eyeNode.camera.xFov = CAMERA_FOX;
    eyeNode.camera.yFov = CAMERA_HEIGHT;
    eyeNode.camera.focalBlurRadius = 0;
    
   
    // 创建player
    _player = [[AVPlayer alloc] init];
    
    // 创建一个SCNVedioNode 对象
    self.vedioNode = [[SKVideoNode alloc] initWithAVPlayer:_player];
    self.vedioNode.size = CGSizeMake(VEDIO_WIDHT, VEDIO_HEIGHT);
   
    // 创建一个SKScene 对象
    _skScene = [SKScene sceneWithSize:self.vedioNode.size];
    self.skScene.scaleMode = SKSceneScaleModeAspectFit;
    
    // 让球体去渲染这个SKScene 对象
    [self.skScene addChild:self.vedioNode];
    self.vedioNode.position = CGPointMake(VEDIO_WIDHT/2, VEDIO_HEIGHT/2);
    
    // 将skscene对象设置为球体渲染的内容
    sphereNode.geometry.firstMaterial.diffuse.contents =self.skScene;
    
    self.observerPlayerTime = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {       // 处理逻辑代码
        
    }];
    
    [self.player reasonForWaitingToPlay];
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
