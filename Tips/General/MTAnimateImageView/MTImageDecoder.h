//
//  MTImageDecoder.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//存储每一帧图片信息的对象
@interface MTImageFrame : NSObject
@property (nonatomic, assign) NSUInteger         index;    //索引
@property (nonatomic, assign) CGFloat            width;    //每一帧的图像宽 像素
@property (nonatomic, assign) CGFloat            height;   //每一帧的图像高 像素
@property (nonatomic, assign) NSUInteger         offsetX;  // 每一帧在画布上的偏移量X (left-bottom based)
@property (nonatomic, assign) NSUInteger         offsetY;  // 每一帧在画布上的偏移量Y (left-bottom based)
@property (nonatomic, assign) NSTimeInterval     duration;  //持续时长
@property (nonatomic, assign) UIImageOrientation imageOrientation; //图像方向
@property (nullable, nonatomic, strong) UIImage  *image; //解码后的image
@end

typedef NS_ENUM(NSUInteger, MTImageType) {
    MTImageTypeUnknown = 0, ///< unknown
    MTImageTypeJPEG,        ///< jpeg, jpg
    MTImageTypeJPEG2000,    ///< jp2
    MTImageTypeTIFF,        ///< tiff, tif
    MTImageTypeBMP,         ///< bmp
    MTImageTypeICO,         ///< ico
    MTImageTypeICNS,        ///< icns
    MTImageTypeGIF,         ///< gif
    MTImageTypePNG,         ///< png
    MTImageTypeWebP,        ///< webp
    MTImageTypeOther,       ///< other image format
};

///  图片解码工具
@interface MTImageDecoder : NSObject

/**
 解码的数据
 */
@property (nullable, nonatomic, readonly) NSData *data;
/**
 图像比例系数
 */
@property (nonatomic, assign) CGFloat scale;
/**
 图片类型
 */
@property (nonatomic, assign, readonly) MTImageType imageType;
/**
 图像帧总个数
 */
@property (nonatomic, assign, readonly) NSInteger frameCount;
/**
 循环次数
 */
@property (nonatomic, assign, readonly) NSInteger loopCount;
/**
 循环一次的时长
 */
@property (nonatomic, assign) NSTimeInterval totalTime;
/**
 画布的大小 宽*高
 */
@property (nonatomic, readonly) CGSize canvasSize;

/**
 配置图片解码器
 @param data 图片数据
 @param scale 图像比例系数 一般情况下为[UIScreen mainScreen].scale]
 */
- (void)decoderWithData:(NSData *)data scale:(CGFloat)scale;

/**
 获取某一帧的图片信息：索引、持续时长、宽高、方向、解码后的image
 index >= 0
 */
- (MTImageFrame *)imageFrameAtIndex:(NSInteger)index;

/**
 获取解码后的第index帧image
 */
- (UIImage *)imageAtIndex:(NSInteger)index;

/**
 某一帧持续时长
 */
- (NSTimeInterval)imageDurationAtIndex:(NSUInteger)index;


@end

NS_ASSUME_NONNULL_END
