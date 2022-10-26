//
//  UIView+MTFrame.h
//  MT_Tips
//
//  Created by lss on 2022/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MTFrame)

@property (nonatomic, assign) CGFloat mt_x;
@property (nonatomic, assign) CGFloat mt_y;
@property (nonatomic, assign) CGFloat mt_width;
@property (nonatomic, assign) CGFloat mt_height;
@property (nonatomic, assign) CGFloat mt_centerX;
@property (nonatomic, assign) CGFloat mt_centerY;

@property (nonatomic, assign) CGSize  mt_size;
@property (nonatomic, assign) CGPoint mt_origin;

@property (nonatomic, assign) CGFloat mt_left;
@property (nonatomic, assign) CGFloat mt_right;
@property (nonatomic, assign) CGFloat mt_top;
@property (nonatomic, assign) CGFloat mt_bottom;

@end

NS_ASSUME_NONNULL_END
