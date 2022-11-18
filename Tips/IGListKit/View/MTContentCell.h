//
//  MTContentCell.h
//  Tips
//
//  Created by lss on 2022/11/11.
//

#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTContentCell : UICollectionViewCell <IGListBindable>

+ (CGFloat)lineHeight;
+ (CGFloat)heightWithText:(NSString *)text width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
