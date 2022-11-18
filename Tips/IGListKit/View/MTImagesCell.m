//
//  MTImagesCell.m
//  Tips
//
//  Created by lss on 2022/11/11.
//

#import "MTImagesCell.h"

@interface MTImageCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation MTImageCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

@end

@interface MTImagesCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MTImagesCellModel *viewModel;

@end

@implementation MTImagesCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)bindViewModel:(MTImagesCellModel *)viewModel{
    self.viewModel = viewModel;
    [self.collectionView reloadData];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MTImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MTImageCellId" forIndexPath:indexPath];
    cell.imageView.image = self.viewModel.images[indexPath.row];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.images.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = floor((collectionView.bounds.size.width - 40 ) / 3.f);
    return CGSizeMake(width, width);
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor systemGroupedBackgroundColor];
        [_collectionView registerClass:[MTImageCell class] forCellWithReuseIdentifier:@"MTImageCellId"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}


@end
