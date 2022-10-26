//
//  MTEditMenuView.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
///编辑对象类型 视频 或者 图片
typedef NS_ENUM(NSUInteger, MTEditObject) {
    ///没有编辑对象
    MTEditObjectUnknow = 0,
    /// 图片编辑
    MTEditObjectPicture = 1,
    /// 视频编辑
    MTEditObjectVideo
};
///视频和图片的编辑类型
typedef NS_ENUM(NSUInteger, MTEditMenuType) {
    /// 无类型
    MTEditMenuTypeUnknown = 0,
    /// 涂鸦
    MTEditMenuTypeGraffiti = 1,
    /// 文字
    MTEditMenuTypeText,
    /// 贴画
    MTEditMenuTypeSticking,
    /// 视频裁剪
    MTEditMenuTypeVideoClipping,
    /// 图片马赛克
    MTEditMenuTypePictureMosaic,
    /// 图片裁剪
    MTEditMenuTypePictureClipping
};

/// 底部音视频、图片编辑主菜单栏
@interface MTEditMenuV : UIView

/// 编辑对象
@property (nonatomic, assign) MTEditObject editObject;
/// 选择编辑的子菜单回调
@property (nonatomic, copy) void(^selectEditMenu)(MTEditMenuType editMenuType,  NSDictionary * _Nullable setting);


@end

NS_ASSUME_NONNULL_END
