//
//  MTImagesCellModel.h
//  Tips
//
//  Created by lss on 2022/11/11.
//

#import <Foundation/Foundation.h>
#import <IGListDiffable.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTImagesCellModel : NSObject <IGListDiffable>

@property (nonatomic, strong) NSArray<UIImage *>*images;

- (instancetype)initWithImages:(NSArray <NSString *> *)urls;

@end

NS_ASSUME_NONNULL_END
