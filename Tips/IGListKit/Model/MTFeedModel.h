//
//  MTFeedModel.h
//  Tips
//
//  Created by lss on 2022/11/11.
//

#import <Foundation/Foundation.h>
#import <IGListDiff.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTCommentModel : NSObject

@property (nonatomic,copy) NSString *person;
@property (nonatomic,copy) NSString *comment;

@end

@interface MTFeedModel : NSObject <IGListDiffable>

@property (nonatomic,copy) NSNumber *feedId;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSArray<NSString *> *images;
@property (nonatomic,copy) NSNumber *favor;
@property (nonatomic,assign) BOOL isFavor;
@property (nonatomic,copy) NSArray<MTCommentModel *> *comments;

@end

NS_ASSUME_NONNULL_END
