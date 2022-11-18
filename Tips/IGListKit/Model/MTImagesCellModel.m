//
//  MTImagesCellModel.m
//  Tips
//
//  Created by lss on 2022/11/11.
//

#import "MTImagesCellModel.h"
#import "NSArray+MTExtension.h"

@implementation MTImagesCellModel

- (instancetype)initWithImages:(NSArray<NSString *> *)urls{
    if (self = [super init]) {
        _images = [urls map:^id _Nonnull(NSString * _Nonnull element) {
            if([element isEqualToString:@"red"]){
                return [UIImage mt_imageWithColor:[UIColor redColor]];
            }
            if ([element isEqualToString:@"blue"]) {
                return [UIImage mt_imageWithColor:[UIColor blueColor]];
            }
            if ([element isEqualToString:@"purple"]) {
                return [UIImage mt_imageWithColor:[UIColor purpleColor]];
            }
            if ([element isEqualToString:@"orange"]) {
                return [UIImage mt_imageWithColor:[UIColor orangeColor]];
            }
            if ([element isEqualToString:@"green"]) {
                return [UIImage mt_imageWithColor:[UIColor greenColor]];
            }
            if ([element isEqualToString:@"yellow"]) {
                return [UIImage mt_imageWithColor:[UIColor yellowColor]];
            }
            return [UIImage mt_imageWithColor:[UIColor blackColor]];
        }];
    }
    return self;
}
- (id<NSObject>)diffIdentifier{
    return self;
}
- (BOOL)isEqualToDiffableObject:(NSObject<IGListDiffable> *)object{
    if (object == self) {
        return YES;
    }
    if (![object isKindOfClass:[MTImagesCellModel class]]) {
        return NO;
    }
    return [self.images isEqualToArray:((MTImagesCellModel *)object).images];
}

@end
