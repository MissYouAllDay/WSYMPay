//
//  YMEasyPayTableViewCell.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/18.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMEasyPayTableViewCell.h"

@implementation YMEasyPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.detailL];
        [self.contentView addSubview:self.indicatorImg];
    }
    
    return self;
}
-(void)layoutSubviews
{
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(LEFTSPACE);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
//        make.width.mas_equalTo(self.iconImg.image.size.width);
//        make.height.mas_equalTo(self.iconImg.mas_width).multipliedBy(1.4);
        
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImg.mas_right).offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.indicatorImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-LEFTSPACE);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
//        make.width.mas_equalTo(self.indicatorImg.image.size.width);
//        make.height.mas_equalTo(self.indicatorImg.mas_width).multipliedBy(1.5);

    }];
    [self.detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.indicatorImg.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
       
    }];
}
-(UIImageView *)iconImg
{
    if (!_iconImg) {
        _iconImg = [UIImageView new];
        [_iconImg sizeToFit];
    }
    
    return _iconImg;
}
-(UILabel *)titleL
{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = COMMON_FONT;
        [_titleL sizeToFit];
       
    }
    
    return _titleL;
}
-(UILabel *)detailL
{
    if (!_detailL) {
        _detailL = [UILabel new];
        _detailL.font = [UIFont systemFontOfMutableSize:13];
        _detailL.textColor = FONTCOLOR;
        [_detailL sizeToFit];
        
    }
    
    return _detailL;
    
}
-(UIImageView *)indicatorImg
{
    if (!_indicatorImg) {
        _indicatorImg = [UIImageView new];
        _indicatorImg.image = [UIImage imageNamed:@"arrow"];
        [_indicatorImg sizeToFit];
    }
    
    return _indicatorImg;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
