//
//  YMTravelTicketTableViewCell.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/18.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTravelTicketTableViewCell.h"



@implementation YMTravelTicketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.but_left];
        [self.contentView addSubview:self.but_middle1];
        [self.contentView addSubview:self.but_middle2];
        [self.contentView addSubview:self.but_right1];
        [self.contentView addSubview:self.but_right2];
    }
    
    return self;
}
-(UIButton *)but_left
{
    if (!_but_left) {
        _but_left = [UIButton buttonWithType:UIButtonTypeCustom];
        _but_left.layer.borderWidth = 0.5;
        _but_left.layer.borderColor = VIEWGRAYCOLOR.CGColor;
        _but_left.tag = 0;
        [_but_left addTarget:self action:@selector(pushToNextVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _but_left;
}
-(UIButton *)but_middle1
{
    if (!_but_middle1) {
        _but_middle1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _but_middle1.layer.borderWidth = 0.5;
        _but_middle1.layer.borderColor = VIEWGRAYCOLOR.CGColor;
        _but_middle1.tag = 1;
         [_but_middle1 addTarget:self action:@selector(pushToNextVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _but_middle1;
}
-(UIButton *)but_middle2
{
    if (!_but_middle2) {
        _but_middle2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _but_middle2.layer.borderWidth = 0.5;
        _but_middle2.layer.borderColor = VIEWGRAYCOLOR.CGColor;
        _but_middle2.tag = 2;
         [_but_middle2 addTarget:self action:@selector(pushToNextVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _but_middle2;
}
-(UIButton *)but_right1
{
    if (!_but_right1) {
        _but_right1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _but_right1.layer.borderWidth = 0.5;
        _but_right1.layer.borderColor = VIEWGRAYCOLOR.CGColor;
        _but_right1.tag = 3;
         [_but_right1 addTarget:self action:@selector(pushToNextVC:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _but_right1;
}
-(UIButton *)but_right2
{
    if (!_but_right2) {
        _but_right2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _but_right2.layer.borderWidth = 0.5;
        _but_right2.layer.borderColor = VIEWGRAYCOLOR.CGColor;
        _but_right2.tag = 4;
         [_but_right2 addTarget:self action:@selector(pushToNextVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _but_right2;
}
-(void)setDicArr:(NSArray *)dicArr
{
    
    _dicArr = dicArr;
//
    [self.but_left setImage:[UIImage imageNamed:dicArr[0][@"imgName"]] forState:UIControlStateNormal];
    [self.but_middle1 setImage:[UIImage imageNamed:dicArr[1][@"imgName"]] forState:UIControlStateNormal];
    [self.but_middle2 setImage:[UIImage imageNamed:dicArr[2][@"imgName"]] forState:UIControlStateNormal];
    [self.but_right1 setImage:[UIImage imageNamed:dicArr[3][@"imgName"]] forState:UIControlStateNormal];
    [self.but_right2 setImage:[UIImage imageNamed:dicArr[4][@"imgName"]] forState:UIControlStateNormal];
//
    
}
-(void)pushToNextVC:(UIButton *)sender
{
    NSDictionary * dic = self.dicArr[sender.tag];
    if ([self.delegate respondsToSelector:@selector(didSelectTicketFunctionItem:)]) {
        [self.delegate didSelectTicketFunctionItem:dic];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.but_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2);
        make.top.mas_equalTo(2);
        make.bottom.mas_equalTo(-2);
    }];
    
    [self.but_middle1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.but_left.mas_right);
        make.top.mas_equalTo(2);
        make.width.mas_equalTo(self.but_left.mas_width);
    }];
    
    [self.but_middle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.but_left.mas_right);
        make.top.mas_equalTo(self.but_middle1.mas_bottom);
        make.width.mas_equalTo(self.but_left.mas_width);
        make.bottom.mas_equalTo(-2);
        make.height.mas_equalTo(self.but_middle1.mas_height);
    }];
    
    [self.but_right1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.but_middle1.mas_right);
        make.top.mas_equalTo(2);
        make.width.mas_equalTo(self.but_left.mas_width);
        make.right.mas_equalTo(-2);
    }];
    
    [self.but_right2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.but_middle1.mas_right);
        make.top.mas_equalTo(self.but_right1.mas_bottom);
        make.width.mas_equalTo(self.but_left.mas_width);
        make.right.mas_equalTo(-2);
        make.bottom.mas_equalTo(-2);
        make.height.mas_equalTo(self.but_right1.mas_height);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
