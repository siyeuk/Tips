//
//  MTUserInfoCellModel.h
//  Tips
//
//  Created by lss on 2022/11/11.
//

#import <Foundation/Foundation.h>
#import <IGListDiffable.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTUserInfoCellModel : NSObject <IGListDiffable>

@property (nonatomic, copy) NSURL *avatar;
@property (nonatomic, copy) NSString *userName;

- (instancetype)initWithUserName:(NSString *)userName;

@end

NS_ASSUME_NONNULL_END
