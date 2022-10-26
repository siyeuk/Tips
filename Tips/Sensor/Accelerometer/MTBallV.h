//
//  MTBallV.h
//  Tips
//
//  Created by lss on 2022/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTBallV : UIImageView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

- (void)starMotion;

- (void)stopMotion;

@end

NS_ASSUME_NONNULL_END
