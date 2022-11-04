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
#define CAMERA_FOX 45
#define CAMERA_HEIGHT 45
#define VEDIO_WIDHT 1280
#define VEDIO_HEIGHT 720

@interface MTPanoramicPlayerC ()
// 3D场景
@property (nonatomic, strong) SCNScene *scene;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) SKVideoNode *vedioNode;
@property (nonatomic, strong) SKScene *skScene;

@property (nonatomic, strong) id observerPlayerTime;
//@property (nonatomic, strong) SCNView *scnView;
//@property (nonatomic, strong) SCNNode *cameraNode;
//@property (nonatomic, strong) SCNNode *ballNode;

@end

@implementation MTPanoramicPlayerC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    // 创建一个3D场景
    //    self.scnView = [[SCNView alloc] initWithFrame:self.view.bounds];
    //    self.scnView.scene = [SCNScene scene];
    //    [self.view addSubview:self.scnView];
    //
    //    // 创建一个camera节点,用来观察球体
    //    /*
    //     摄像机（SCNCamera）
    //     几何结构 (SCNGeometry)
    //     光源 （SCNLight）
    //     材质（SCNMaterial）
    //     */
    //    self.cameraNode = [SCNNode node];
    //    self.cameraNode.camera = [SCNCamera camera];
    //    self.cameraNode.camera.automaticallyAdjustsZRange = YES; //自动添加可视距离
    //    self.cameraNode.position = SCNVector3Make(0, 0, 0);
    //    self.cameraNode.camera.xFov = 45;
    //    self.cameraNode.camera.yFov = 45;
    //    self.cameraNode.camera.focalBlurRadius = 0; // 决定接收器的焦点半径。可以做成动画。
    //    [self.scnView.scene.rootNode addChildNode:self.cameraNode];
    //
    //    // 创建一个球体（视觉对象）
    //    self.ballNode = [SCNNode node];
    //    SCNSphere *ball = [SCNSphere sphereWithRadius:100];//半径不要设置太小
    //    self.ballNode.geometry = ball;
    //    /* 球体有两个表面
    //     * 一个外表面一个内表面,在vr模式下,我们的眼睛是在球体中间的,所以让球体只需渲染内表面，提高性能
    //     */
    //    self.ballNode.geometry.firstMaterial.doubleSided = NO; //设置只渲染一个表面
    //    self.ballNode.geometry.firstMaterial.cullMode = SCNCullModeFront; //设置剔除外表面
    //    self.ballNode.position = SCNVector3Make(0, 0, 0);
    //    [self.scnView.scene.rootNode addChildNode:self.ballNode];
    //
    //
    //    // 设置场景内容
    //    //image这里是一张3D图片（UIImage）
    //    self.ballNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"quanjingpic.png"];
    //
    //    /*设置纹理滤波，纹理过滤决定了材料属性的内容的外观
    //     *SCNFilterModeNone
    //     *SCNFilterModeNearest  当这个位置没有纹理颜色时，会采样离他最近的颜色值
    //     *SCNFilterModeLinear  当这个位置没有纹理颜色时,线性插值颜色作为自己的颜色
    //     */
    //    self.ballNode.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    //
    //    //设置contentsTransform，否则渲染出来的画面会反置，因为我们是在球体中观察的，好比看镜中的自己
    //    self.ballNode.geometry.firstMaterial.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(-1, 1, 1), 1, 0, 0);
    //
    //
    //    // 添加光源,光源的类型-环境光源
    //    /*
    //     1.环境光源，它在整个场景内投射均匀光
    //     2.泛光源，这是用的最多的，就是点光源，向各个方向投射光
    //     3.平行光源，在单个方向投射光
    //     4.聚光源，在给定方向从单个位置投射光
    //     */
    //    SCNLight *ambientLight = [SCNLight light];
    //    ambientLight.type = SCNLightTypeAmbient;
    //    ambientLight.color = [UIColor colorWithRed:0 green:.2 blue:0 alpha:.1];
    //    self.ballNode.light = ambientLight;
    
    
    // 创建一个3D场景
    self.scene = [SCNScene scene];
    
    // 创建球体
    SCNNode *sphereNode = [SCNNode node];
    sphereNode.geometry = [SCNSphere sphereWithRadius:SHPERE_RADIUS];
    sphereNode.rotation = SCNVector4Make(1, 0, 0, -M_PI_2);
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
    _player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:@"http://d8d913s460fub.cloudfront.net/krpanocloud/video/airpano/video-1920x960a.mp4"]];
    
    // 创建一个SCNVedioNode 对象
    self.vedioNode = [[SKVideoNode alloc] initWithAVPlayer:_player];
    self.vedioNode.size = CGSizeMake(VEDIO_WIDHT, VEDIO_HEIGHT);
    
    // 创建一个SKScene 对象
    _skScene = [SKScene sceneWithSize:self.vedioNode.size];
    self.skScene.scaleMode = SKSceneScaleModeAspectFit;
    
    // 让球体去渲染这个SKScene 对象
    [self.skScene addChild:self.vedioNode];
    self.vedioNode.position = CGPointMake(VEDIO_WIDHT/2, VEDIO_HEIGHT/2);
    
    sphereNode.geometry.firstMaterial.diffuse.contents = self.skScene;
    
    // 将skscene对象设置为球体渲染的内容
    sphereNode.geometry.firstMaterial.diffuse.contents =self.skScene;
    
    self.observerPlayerTime = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {       // 处理逻辑代码
        
    }];
    
    
//    [self.player reasonForWaitingToPlay];
    [self.player play];
}


/*
 SceneNode提供8种属性用来设置模型材质

 Diffuse 漫发射属性表示光和颜色在各个方向上的反射量
 Ambient 环境光以固定的强度和固定的颜色从表面上的所有点反射出来。如果场景中没有环境光对象，这个属性对节点没有影响
 Specular 镜面反射是直接反射到使用者身上的光线，类似于镜子反射光线的方式。此属性默认为黑色，这将导致材料显得呆滞
 Normal 正常照明是一种用于制造材料表面光反射的技术，基本上，它试图找出材料的颠簸和凹痕，以提供更现实发光效果
 Reflective 反射光属性是一个镜像表面反射环境。表面不会真实地反映场景中的其他物体
 Emission 该属性是由模型表面发出的颜色。默认情况下，此属性设置为黑色。如果你提供了一个颜色，这个颜色就会体现出来，你可以提供一个图像。SceneKit将使用此图像提供“基于材料的发光效应”。
 Transparent 用来设置材质的透明度
 Multiply 通过计算其他所有属性的因素生成最终的合成的颜色
 
 */

@end
