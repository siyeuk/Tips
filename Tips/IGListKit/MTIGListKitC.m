//
//  MTIGListKitC.m
//  Tips
//
//  Created by lss on 2022/11/11.
//

#import "MTIGListKitC.h"
#import <IGListKit/IGListKit.h>
#import "MTFeedSectionC.h"

@interface MTIGListKitC ()<IGListAdapterDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) NSArray *dataArrays;

@end

@implementation MTIGListKitC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adapter.collectionView = self.collectionView;
     
}

#pragma mark - IGListAdapterDataSource -
- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter{
    return nil;
}
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter{
    return self.dataArrays;
}
- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object{
    MTFeedSectionC<MTFeedModel *> *section = [[MTFeedSectionC<MTFeedModel *> alloc] init];
    return section;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}
- (IGListAdapter *)adapter{
    if (!_adapter) {
        _adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self workingRangeSize:0];
        _adapter.dataSource = self;
    }
    return _adapter;
}
- (NSArray *)dataArrays{
    if (!_dataArrays) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"ListData" withExtension:@"json"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (!data){
            return nil;
        }
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        _dataArrays = [MTFeedModel mj_objectArrayWithKeyValuesArray:array];
    }
    return _dataArrays;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _collectionView.backgroundColor = [UIColor systemGroupedBackgroundColor];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
