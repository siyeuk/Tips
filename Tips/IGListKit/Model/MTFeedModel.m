//
//  MTFeedModel.m
//  Tips
//
//  Created by lss on 2022/11/11.
//

#import "MTFeedModel.h"

@implementation MTCommentModel



@end

@implementation MTFeedModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"comments":[MTCommentModel class]
             };
}
- (id<NSObject>)diffIdentifier{
    return self;
}
- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object{
    return [self isEqual:object];
}


@end
