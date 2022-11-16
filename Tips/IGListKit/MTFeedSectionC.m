//
//  MTFeedSectionC.m
//  Tips
//
//  Created by lss on 2022/11/11.
//

#import "MTFeedSectionC.h"

#import "MTFeedModel.h"
#import "MTUserInfoCellModel.h"
#import "MTUserInfoCell.h"

#import "MTContentCell.h"

#import "MTImagesCellModel.h"
#import "MTImagesCell.h"


#define KInsetLeft 10

@interface MTFeedSectionC ()<IGListBindingSectionControllerDataSource, IGListBindingSectionControllerSelectionDelegate>

@property (nonatomic) BOOL expanded;

@end

@implementation MTFeedSectionC

- (instancetype)init{
    if (self = [super init]) {
        self.dataSource = self;
        self.selectionDelegate = self;
        self.inset = UIEdgeInsetsMake(5, 0, 0, 0);
    }
    return self;
}
#pragma mark - IGListBindingSectionControllerDataSource -
- (UICollectionViewCell<IGListBindable> *)sectionController:(IGListBindingSectionController *)sectionController cellForViewModel:(id)viewModel atIndex:(NSInteger)index{
    if ([viewModel isKindOfClass:[MTUserInfoCellModel class]]) {
        MTUserInfoCell *cell = [self.collectionContext dequeueReusableCellOfClass:[MTUserInfoCell class] forSectionController:self atIndex:index];
        [cell bindViewModel:viewModel];
        return cell;
    }
    if ([viewModel isKindOfClass:[NSString class]]){
        MTContentCell *cell = [self.collectionContext dequeueReusableCellOfClass:[MTContentCell class] forSectionController:self atIndex:index];
        [cell bindViewModel:viewModel];
        return cell;
    }
    if ([viewModel isKindOfClass:[MTImagesCellModel class]]) {
        MTImagesCell *cell = [self.collectionContext dequeueReusableCellOfClass:[MTImagesCell class] forSectionController:self atIndex:index];
        [cell bindViewModel:viewModel];
        return cell;
    }
   
    return [[UICollectionViewCell<IGListBindable> alloc] init];
}
- (CGSize)sectionController:(nonnull IGListBindingSectionController *)sectionController sizeForViewModel:(nonnull id)viewModel atIndex:(NSInteger)index{
    CGFloat width = self.collectionContext.containerSize.width;
    if ([viewModel isKindOfClass:[MTUserInfoCellModel class]]) {
        return CGSizeMake(width, 25);
    }
    if ([viewModel isKindOfClass:[NSString class]]) {
        CGFloat height = _expanded ? [MTContentCell heightWithText:self.dataObject.content width:width] : [MTContentCell lineHeight];
        return CGSizeMake(width, height);
    }
    if ([viewModel isKindOfClass:[MTImagesCellModel class]]) {
        CGFloat mwidth = (width - KInsetLeft * 4) / 3.0;
        CGFloat height = (self.dataObject.images.count - 1) / 3 * (mwidth + KInsetLeft) + mwidth;
        return CGSizeMake(width, height);
    }
    return CGSizeZero;
}
- (NSArray<id<IGListDiffable>> *)sectionController:(IGListBindingSectionController *)sectionController viewModelsForObject:(MTFeedModel *)object{
    NSMutableArray *viewModels = [NSMutableArray array];
    MTUserInfoCellModel *vm = [[MTUserInfoCellModel alloc] initWithUserName:object.userName];
    [viewModels addObject:vm];
    if (object.content) {
        [viewModels addObject:object.content];
    }
    if (object.images.count > 0) {
        [viewModels addObject:[[MTImagesCellModel alloc] initWithImages:object.images]];
    }
    return viewModels;
}
#pragma mark - IGListBindingSectionControllerSelectionDelegate -
/**
 告诉委托已选中给定索引上的单元格。

 发生选择的section控制器。
 所选单元格的索引。
 绑定到单元格的视图模型。
 */
- (void)sectionController:(IGListBindingSectionController *)sectionController didSelectItemAtIndex:(NSInteger)index viewModel:(id)viewModel{
    if ([viewModel isKindOfClass:[NSString class]]) {
        _expanded = !_expanded;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:UIViewAnimationOptionLayoutSubviews animations:^{
            [self.collectionContext invalidateLayoutForSectionController:self completion:^(BOOL finished) {

            }];
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
 告诉委托，给定索引上的单元格已被取消选中。

 发生取消选择的section控制器。
 去选单元格的索引。
 绑定到单元格的视图模型。
 */
- (void)sectionController:(IGListBindingSectionController *)sectionController didDeselectItemAtIndex:(NSInteger)index viewModel:(id)viewModel{
   
}

/**
 告诉委托突出显示给定索引的单元格。

 发生高亮的section控制器。
 突出显示单元格的索引。
 绑定到单元格的视图模型。
 */
- (void)sectionController:(IGListBindingSectionController *)sectionController didHighlightItemAtIndex:(NSInteger)index viewModel:(id)viewModel{
 
}

/**
 告诉委托，给定索引上的单元格未高亮显示。

 未突出显示的section控制器。
 未突出显示单元格的索引。
 绑定到单元格的视图模型。
 */
- (void)sectionController:(IGListBindingSectionController *)sectionController didUnhighlightItemAtIndex:(NSInteger)index viewModel:(id)viewModel{
 
}



- (MTFeedModel *)dataObject{
    return self.object;
}

@end
