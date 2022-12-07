//
//  SceneDelegate.m
//  MT_Tips
//
//  Created by lss on 2022/10/10.
//

#import "SceneDelegate.h"
//#import "MTAVPlayer.h"

@interface SceneDelegate ()

//@property (nonatomic, strong) MTAVPlayer *player;

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
//   self.player = [MTAVPlayer sharedAVPlayer];
//
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
//        view.backgroundColor = [UIColor orangeColor];
//        [self.window addSubview:view];
//        self.player.monitor = view;
//        self.player.url = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
//        [self.player play];
//    });
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
