//
//  MTEditMenuView.m
//  MT_Tips
//
//  Created by lss on 2022/10/11.
//

#import "MTEditMenuV.h"
#import "MTImage.h"
#import "MTImageView.h"

/// 涂鸦子菜单
@interface MTSubmenuGraffitiView : UIView
@property (nonatomic, assign) int currentColorIndex; // 当前画笔颜色索引
@property (nonatomic, strong) UIColor *currentColor; // 当前画笔颜色
@property (nonatomic, copy) void(^selectedLineColor)(UIColor *lineColor); //选中颜色的回调
@property (nonatomic, copy) void(^goBack)(void); //返回上一步
@end
@implementation MTSubmenuGraffitiView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentColorIndex = 0;
        _currentColor = [UIColor whiteColor];
    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _currentColorIndex = 0;
        _currentColor = [UIColor whiteColor];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self createSubmenu];
}
- (void)createSubmenu {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    NSArray *colors = @[[UIColor whiteColor], [UIColor blackColor], [UIColor redColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor], [UIColor clearColor]];
    int count = (int)colors.count;
    CGSize itemSize = CGSizeMake(20, 20);
    CGFloat space = (self.frame.size.width - count * itemSize.width)/(count + 1);
    for (int i = 0; i < count; i++) {
        UIButton * colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(space + (itemSize.width + space)*i, (self.frame.size.height - itemSize.height)/2.0, itemSize.width, itemSize.height)];
        colorBtn.backgroundColor = colors[i];
        colorBtn.tag = 10 + i;
        [self addSubview:colorBtn];
        if (i == count - 1) {
            [colorBtn addTarget:self action:@selector(backToPreviousStep:) forControlEvents:UIControlEventTouchUpInside];
            [colorBtn setImage:[UIImage imageNamed:@"EditMenuGraffitiBack"] forState:UIControlStateNormal];
        }else {
            [colorBtn addTarget:self action:@selector(colorBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            colorBtn.layer.cornerRadius = itemSize.width/2.0;
            colorBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            colorBtn.layer.borderWidth = 3;
            if (i != _currentColorIndex) {
                colorBtn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8f, 0.8f);
                colorBtn.layer.borderWidth = 2;
            }else {
                colorBtn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
                colorBtn.layer.borderWidth = 4;
                _currentColor = colors[i];
                self.selectedLineColor(colors[i]);
            }
        }
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor whiteColor];
    line.alpha = 0.5;
    [self addSubview:line];
}
// 选中当前画笔颜色
- (void)colorBtnClicked:(UIButton *)colorBtn {
    UIButton *previousBtn = (UIButton *)[self viewWithTag:(10 + _currentColorIndex)];
    previousBtn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8f, 0.8f);
    previousBtn.layer.borderWidth = 2;
    colorBtn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    colorBtn.layer.borderWidth = 4;
    _currentColorIndex = (int)colorBtn.tag- 10;
    _currentColor = colorBtn.backgroundColor;
    self.selectedLineColor(colorBtn.backgroundColor);
}
//返回上一步
- (void)backToPreviousStep:(id)sender {
    self.goBack();
}
@end

//贴画CollectionViewCell
@interface MTSubmenuStickingCell : UICollectionViewCell
@property (nonatomic, strong) MTImageView *imageView;
@end
@implementation MTSubmenuStickingCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    _imageView = [[MTImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageView];
}
- (void)setImage:(NSString *)imageName {
    _imageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    _imageView.image = [MTImage imageNamed:imageName];
}
@end
/// 贴画子菜单
@interface MTSubmenuStickingView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void(^selectedImage)(MTImage *image); //选中的图片 贴画
@end
@implementation MTSubmenuStickingView
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self createSubmenu];
}
- (void)createSubmenu {
    [self addSubview:self.collectionView];
}
#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MTSubmenuStickingCell class] forCellWithReuseIdentifier:@"ItemId"];
    }
    return _collectionView;
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            [_dataSource addObject:[NSString stringWithFormat:@"Resources.bundle/StickingImages/stickers_%d",i]];
        }
    }
    return _dataSource;
}
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTSubmenuStickingCell * item = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemId" forIndexPath:indexPath];
    [item setImage:self.dataSource[indexPath.row]];
    return item;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    self.selectedImage([MTImage imageNamed:self.dataSource[indexPath.row]]);
}
#pragma mark -  UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.frame.size.width - 5*10)/4.0, self.frame.size.height);
}
//列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
@end

/// 图片马赛克 子菜单  马赛克类型选择
@interface MTSubmenuMosaicView : UIView
@property (nonatomic, assign) NSInteger currentTypeIndex; //当前马赛克类型索引 默认0
@property (nonatomic, copy) void(^goBack)(void); //返回上一步
@property (nonatomic, copy) void(^selectedMosaicType)(NSInteger currentTypeIndex); // 选择马赛克类型 0：小方块 1：毛笔涂抹
@end
@implementation MTSubmenuMosaicView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self createSubmenu];
}
- (void)createSubmenu {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    NSArray *imageNames = @[@"EditMenuMosaic", @"EditBrushMosaic", @"EditMenuGraffitiBack"];
    NSArray *imageNamesSelected = @[@"EditMenuMosaicSelected", @"EditBrushMosaicSelected", @"EditMenuGraffitiBack"];
    int count = (int)imageNames.count;
    CGSize itemSize = CGSizeMake(50, 50);
    CGFloat space = (self.frame.size.width - count * itemSize.width)/(count + 1);
    for (int i = 0; i < count; i++) {
        UIButton * colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(space + (itemSize.width + space)*i, (self.frame.size.height - itemSize.height)/2.0, itemSize.width, itemSize.height)];
        colorBtn.tag = 10 + i;
        [self addSubview:colorBtn];
        if (i == count - 1) {
            [colorBtn addTarget:self action:@selector(backToPreviousStep:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [colorBtn addTarget:self action:@selector(mosaicTypeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        if(i == _currentTypeIndex) {
            colorBtn.selected = YES;
        }
        [colorBtn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [colorBtn setImage:[UIImage imageNamed:imageNamesSelected[i]] forState:UIControlStateSelected];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor whiteColor];
    line.alpha = 0.5;
    [self addSubview:line];
}
- (void)backToPreviousStep:(id)sender {
    self.goBack();
}
//马赛克类型
- (void)mosaicTypeBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    UIButton *currentView = [self viewWithTag:(_currentTypeIndex + 10)];
    currentView.selected = !currentView.selected;
    _currentTypeIndex = btn.tag - 10;
    self.selectedMosaicType(_currentTypeIndex);
}
@end

/// 编辑主菜单
@interface MTEditMenuV ()

@property (nonatomic, strong) NSArray        *menuTypes; //编辑类型集合
@property (nonatomic, strong) NSArray        *imageNames; //编辑图标名称
@property (nonatomic, strong) NSArray        *imageNamesSelected; //选中的 编辑图标名称
@property (nonatomic, strong) NSMutableArray *menuBtns; //编辑菜单按钮集合

@property (nonatomic, strong) UIView                *currentSubmenu; //当前显示的子菜单
@property (nonatomic, strong) MTSubmenuGraffitiView *submenuGraffiti; //涂鸦子菜单
@property (nonatomic, strong) MTSubmenuStickingView *submenuSticking; //贴图子菜单
@property (nonatomic, strong) MTSubmenuMosaicView   *submenuMosaic;  //图片马赛克

@end

@implementation MTEditMenuV

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

#pragma mark - UI
- (void)createEditMenus {
    for (UIView *subView in self.subviews) {
        if (subView == _submenuGraffiti || subView == _submenuSticking || subView == _submenuMosaic) {
            continue;
        }
        [subView removeFromSuperview];
    }
    int count = (int)_menuTypes.count;
    CGSize itemSize = CGSizeMake(20, 20);
    CGFloat space = (self.frame.size.width - count * itemSize.width)/count;
    _menuBtns = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        UIButton * menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(space/2.0 + (itemSize.width + space)*i, self.frame.size.height - 80, itemSize.width, 80)];
        menuBtn.tag = [_menuTypes[i] intValue];
        [menuBtn setImage:[UIImage imageNamed:_imageNames[i]] forState:UIControlStateNormal];
        [menuBtn setImage:[UIImage imageNamed:_imageNamesSelected[i]] forState:UIControlStateSelected];
        [menuBtn addTarget:self action:@selector(menuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn];
        [_menuBtns addObject:menuBtn];
    }
}
- (void)setEditObject:(MTEditObject)editObject {
    _editObject = editObject;
    if (editObject == MTEditObjectPicture) {
        _menuTypes = @[@(MTEditMenuTypeGraffiti), @(MTEditMenuTypeSticking), @(MTEditMenuTypeText),@(MTEditMenuTypePictureMosaic), @(MTEditMenuTypePictureClipping)];
        _imageNames = @[@"EditMenuGraffiti", @"EditMenuSticker", @"EditMenuText", @"EditMenuMosaic", @"EditMenuClipImage"];
        _imageNamesSelected = @[@"EditMenuGraffitiSelected", @"EditMenuStickerSelected", @"EditMenuText",@"EditMenuMosaicSelected",@"EditMenuClipImage"];
    }else if (editObject == MTEditObjectVideo) {
        _menuTypes = @[@(MTEditMenuTypeGraffiti), @(MTEditMenuTypeSticking), @(MTEditMenuTypeText), @(MTEditMenuTypeVideoClipping)];
        _imageNames = @[@"EditMenuGraffiti", @"EditMenuSticker", @"EditMenuText", @"EditMenuCut"];
        _imageNamesSelected = @[@"EditMenuGraffitiSelected", @"EditMenuStickerSelected", @"EditMenuText", @"EditMenuCut"];
    }
    [self createEditMenus];
}
#pragma mark - Getter
- (MTSubmenuGraffitiView *)submenuGraffiti {
    if (!_submenuGraffiti) {
        _submenuGraffiti = [[MTSubmenuGraffitiView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
        _submenuGraffiti.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _submenuGraffiti.selectedLineColor = ^(UIColor *lineColor) {
            weakSelf.selectEditMenu(MTEditMenuTypeGraffiti, @{@"lineColor":lineColor});
        };
        _submenuGraffiti.goBack = ^{
            weakSelf.selectEditMenu(MTEditMenuTypeGraffiti, @{@"goBack":@(YES)});
        };
    }
    return _submenuGraffiti;
}
- (MTSubmenuStickingView *)submenuSticking {
    if (!_submenuSticking) {
        _submenuSticking = [[MTSubmenuStickingView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
        _submenuSticking.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _submenuSticking.selectedImage = ^(MTImage *image) {
            weakSelf.selectEditMenu(MTEditMenuTypeSticking, @{@"image":image});
        };
    }
    return _submenuSticking;
}
- (MTSubmenuMosaicView *)submenuMosaic {
    if (!_submenuMosaic) {
        _submenuMosaic = [[MTSubmenuMosaicView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
        _submenuMosaic.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _submenuMosaic.selectedMosaicType = ^(NSInteger currentTypeIndex) {
            weakSelf.selectEditMenu(MTEditMenuTypePictureMosaic, @{@"mosaicType":@(currentTypeIndex)});
        };
        _submenuMosaic.goBack = ^{
            weakSelf.selectEditMenu(MTEditMenuTypePictureMosaic, @{@"goBack":@(YES)});
        };
    }
    return _submenuMosaic;
}
#pragma mark - Evenst Handle
- (void)menuBtnClicked:(UIButton *)menuBtn {
    for (UIButton *subView in self.menuBtns) {
        if (subView == menuBtn) {
            subView.selected = !subView.selected;
        } else {
            subView.selected = NO;
        }
    }
    MTEditMenuType editMenuType = menuBtn.tag;
    switch (editMenuType) {
        case MTEditMenuTypeGraffiti:
            [self hiddenView:self.submenuGraffiti];
            self.selectEditMenu(editMenuType, @{@"hidden":@(self.submenuGraffiti.hidden), @"lineColor": self.submenuGraffiti.currentColor});
            break;
        case MTEditMenuTypeSticking:
            [self hiddenView:self.submenuSticking];
            self.selectEditMenu(editMenuType, @{@"hidden":@(self.submenuSticking.hidden)});
            break;
        case MTEditMenuTypeText:
            [self hiddenView:self.currentSubmenu hidden:YES];
            self.selectEditMenu(editMenuType, @{@"hidden":@(self.submenuSticking.hidden)});
            break;
        case MTEditMenuTypeVideoClipping:
            [self hiddenView:self.currentSubmenu hidden:YES];
            self.selectEditMenu(editMenuType, nil);
            break;
        case MTEditMenuTypePictureMosaic:
            [self hiddenView:self.submenuMosaic];
            self.selectEditMenu(editMenuType, @{@"hidden":@(self.submenuMosaic.hidden), @"mosaicType":@(self.submenuMosaic.currentTypeIndex)});
            break;
        case MTEditMenuTypePictureClipping:
            [self hiddenView:self.currentSubmenu hidden:YES];
            self.selectEditMenu(editMenuType, @{@"hidden":@(NO)});
            break;
        default:
            break;
    }
}
#pragma mark - Help Methods
- (void)hiddenView:(UIView *)view {
    if (self.currentSubmenu == view || self.currentSubmenu == nil) {
        [self hiddenView:view hidden:!view.hidden];
    }else {
        [self hiddenView:self.currentSubmenu hidden:YES];
        [self hiddenView:view hidden:NO];
    }
}
- (void)hiddenView:(UIView *)view hidden:(BOOL)hidden{
    if(view == nil || view.hidden == hidden) return;
    if (hidden) {
        view.hidden = YES;
        [view removeFromSuperview];
    }else {
        view.hidden = NO;
        self.currentSubmenu = view;
        [self addSubview:view];
    }
}



@end
