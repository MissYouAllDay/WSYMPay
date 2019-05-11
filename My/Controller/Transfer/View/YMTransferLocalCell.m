//
//  YMTransferLocalCell.m
//  WSYMPay
//
//  Created by pzj on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferLocalCell.h"

@interface YMTransferLocalCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YMTransferLocalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    [self.contentView addSubview:[self iconImage]];
    [self.contentView addSubview:[self titleLabel]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(71/2);
        make.height.mas_equalTo(71/2);
        make.left.mas_equalTo(LEFTSPACE);
        make.top.mas_equalTo((self.height-71/2)/2);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(self.iconImage.mas_right).offset(10);
        make.right.mas_equalTo(-RIGHTSPACE);
        make.bottom.mas_equalTo(-5);
    }];
    
}
- (UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
    }
    return _iconImage;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font      = COMMON_FONT;
        _titleLabel.textColor = FONTDARKCOLOR;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (void)setIndexPathRow:(NSInteger)indexPathRow
{
    switch (indexPathRow) {
        case 0:
        {
            [self iconImage].image = [UIImage imageNamed:@"purse"];
            [self titleLabel].text = @"转到有名钱包账户";
        }
            break;
        case 1:
        {
            [self iconImage].image = [UIImage imageNamed:@"transferbankcard"];
            [self titleLabel].text = @"转到银行卡";
        }
            break;
        default:
            break;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
