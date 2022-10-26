//
//  MTEditTextV.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 文本水印编辑 工具
@interface MTEditTextV : UIView

/// 编辑文本完成
@property (nonatomic, copy) void(^editTextCompleted)(UILabel * _Nullable label);
/// 配置编辑参数 文本颜色textColor、背景颜色backgroundColor、文本text
@property (nonatomic, copy) void(^configureEditParameters)(NSDictionary *parameters);


@end

NS_ASSUME_NONNULL_END
