//
//  NSArray+MTExtension.h
//  Tips
//
//  Created by lss on 2022/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (MTExtension)

/*
NS_NOESCAPE用于修饰方法中的block类型参数，例如：
@interface NSArray: NSObject
- (NSArray *)sortedArrayUsingComparator:(NSComparator NS_NOESCAPE)cmptr
@end
作用是告诉编译器，cmptr这个block在sortedArrayUsingComparator:方法返回之前就会执行完毕，而不是被保存起来在之后的某个时候再执行。 类似于这样的实现：
 */
- (NSArray *)map:(id(NS_NOESCAPE ^)(ObjectType element))block;
- (NSMutableArray *)mutableMap:(id(NS_NOESCAPE ^)(ObjectType element))block;

///数组展开 element的类型是数组元素的元素类型
- (NSArray *)flatMap:(id(NS_NOESCAPE ^)(id element))block;

- (NSArray<ObjectType> *)filter:(BOOL(NS_NOESCAPE ^)(ObjectType element))block;

///去除重复元素
- (NSArray<ObjectType> *)filterRepeat;

///相当于swift的reduce函数
- (id)reduceWithInitialResult:(id)initialResult nextPartialResult:(id (^)(id result, ObjectType element))nextPartialResult;

- (NSArray<ObjectType> *)dropFirst;


@end

NS_ASSUME_NONNULL_END
