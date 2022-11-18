//
//  MTUserInfoCellModel.m
//  Tips
//
//  Created by lss on 2022/11/11.
//

#import "MTUserInfoCellModel.h"

@implementation MTUserInfoCellModel

- (instancetype)initWithUserName:(NSString *)userName{
    if (self = [super init]) {
        _userName = userName;
    }
    return self;
}
-(id<NSObject>)diffIdentifier{
    return self.userName;
}

-(BOOL)isEqualToDiffableObject:(NSObject<IGListDiffable> *)object{
    if (object == self) {
        return YES;
    } else if (![object isKindOfClass:[MTUserInfoCellModel class]]) {
        return NO;
    } else {
        return [self.userName isEqualToString:((MTUserInfoCellModel *)object).userName];
    }
}

@end
