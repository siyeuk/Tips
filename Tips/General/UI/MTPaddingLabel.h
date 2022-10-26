//
//  MTPaddingLabel.h
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 可以设置内边距的Label
@interface MTPaddingLabel : UILabel

/// 内边距
@property (nonatomic, assign) UIEdgeInsets textPadding;

@end

NS_ASSUME_NONNULL_END
