//
//  YMTransferRecentlyCell.m
//  WSYMPay
//
//  Created by pzj on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferRecentlyCell.h"
#import "YMTransferRecentRecodeDataListModel.h"

@interface YMTransferRecentlyCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contactLabel;

@end

@implementation YMTransferRecentlyCell

- (void)setModel:(YMTransferRecentRecodeDataListModel *)model
{
    _model = model;
    if (_model == nil) {
        return;
    }
    [self nameLabel].text = [_model getToAccNameStr];
    [self contactLabel].text = [model getToAccountStr];
}

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
    [self.contentView addSubview:[self nameLabel]];
    [self.contentView addSubview:[self contactLabel]];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(RIGHTSPACE);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(self.height/2-10);
    }];
    [self.contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(RIGHTSPACE);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.height.mas_equalTo(self.nameLabel.mas_height);
    }];
    
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = COMMON_FONT;
        _nameLabel.textColor = FONTDARKCOLOR;
    }
    return _nameLabel;
}

- (UILabel *)contactLabel
{
    if (!_contactLabel) {
        _contactLabel = [[UILabel alloc] init];
        _contactLabel.font = [UIFont systemFontOfMutableSize:11];
        _contactLabel.textColor = FONTCOLOR;
    }
    return _contactLabel;
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
