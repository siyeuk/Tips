//
//  MTBlurView.m
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import "MTBlurView.h"

@implementation MTBlurView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        [self addSubview:self.blurView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        [self addSubview:self.blurView];
    }
    return self;
}

- (UIVisualEffectView *)blurView {
    if (_blurView == nil) {
        //高斯模糊
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _blurView.alpha = 0.9;
        _blurView.frame = self.bounds;
    }
    return _blurView;
}

- (void)layoutSubviews {
    [self sendSubviewToBack:self.blurView];
    self.blurView.frame = self.bounds;
}


@end
