//
//  YMTransferMoneyLimitCell.m
//  WSYMPay
//
//  Created by pzj on 2017/5/3.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferMoneyLimitCell.h"
#import "YMTransferRecentRecodeDataListModel.h"

@interface YMTransferMoneyLimitCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation YMTransferMoneyLimitCell
- (void)setListModel:(YMTransferRecentRecodeDataListModel *)listModel
{
    _listModel = listModel;
    if (_listModel == nil) {
        return;
    }
    [self titleLabel].text = [_listModel getBankNameStr];
    [self descLabel].text = [_listModel getLmitMaxAmtStr];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = COMMON_FONT;
        _titleLabel.textColor = FONTDARKCOLOR;
        _titleLabel.text = @"余额";
         [self.contentView addSubview:_titleLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(LEFTSPACE);
            make.right.mas_equalTo(-RIGHTSPACE);
            make.height.mas_equalTo(35);
        }];
    }
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfMutableSize:12];
        _descLabel.textColor = FONTCOLOR;
        _descLabel.numberOfLines = 0;
        _descLabel.text = @"单笔5000.00元。。。";
        [self.contentView addSubview:_descLabel];

        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.left.mas_equalTo(LEFTSPACE);
            make.right.mas_equalTo(-RIGHTSPACE);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _descLabel;
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
