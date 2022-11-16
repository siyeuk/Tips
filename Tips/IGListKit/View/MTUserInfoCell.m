//
//  MTUserInfoCell.m
//  Tips
//
//  Created by lss on 2022/11/11.
//

#import "MTUserInfoCell.h"

@interface MTUserInfoCell ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation MTUserInfoCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.width.height.mas_equalTo(24);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(self.avatarView.mas_right).mas_offset(15);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)bindViewModel:(MTUserInfoCellModel *)viewModel{
    self.avatarView.backgroundColor = [UIColor purpleColor];
    self.nameLabel.text = viewModel.userName;
}

- (UIImageView *)avatarView{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.layer.cornerRadius = 12;
        [self.contentView addSubview:_avatarView];
    }
    return _avatarView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

@end

