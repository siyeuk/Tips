//
//  MTContentCell.m
//  Tips
//
//  Created by lss on 2022/11/11.
//

#import "MTContentCell.h"

@interface MTContentCell ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation MTContentCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 10));
        }];
    }
    return self;
}

- (void)bindViewModel:(NSString *)viewModel{
    self.textLabel.text = viewModel;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.numberOfLines = 0;
        [self.contentView addSubview:_textLabel];
    }
    return _textLabel;
}

+ (CGFloat)lineHeight{
    UIFont *font = [UIFont systemFontOfSize:15];
    return font.lineHeight + font.ascender + font.descender;
}
+ (CGFloat)heightWithText:(NSString *)text width:(CGFloat)width{
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(width - 20, CGFLOAT_MAX);
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    return ceil(rect.size.height) + font.ascender + font.descender;
}
@end
