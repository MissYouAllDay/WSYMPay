//
//  YMMobileCollectionViewCell_money.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/24.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMMobileCollectionViewCell_money.h"
@interface YMMobileCollectionViewCell_money()

@property (strong ,nonatomic) UIView  * backView;
@property (strong ,nonatomic) UILabel * titleL;
@property (strong ,nonatomic) UILabel * detailTitleL;

@end

@implementation YMMobileCollectionViewCell_money
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.backView];
        
        [self.contentView addSubview:self.detailTitleL];
        
        [self.contentView addSubview:self.titleL];
    }
    return self;
}
-(void)layoutSubviews
{
  
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets = UIEdgeInsetsMake(4, 4, 4, 4);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.5);

    }];
    
    [self.detailTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.5).offset(3);
        
    }];
}
-(UIView *)backView
{
    if (!_backView) {
        _backView = [UIView new];
        _backView.layer.borderColor = NAVIGATIONBARCOLOR.CGColor;
        _backView.layer.borderWidth = 1.0;
        _backView.layer.cornerRadius = 6.0;
    }
    return _backView;
}
-(UILabel *)titleL
{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = [UIFont systemFontOfMutableSize:14];
        _titleL.text = @"测试";
        _titleL.backgroundColor = [UIColor clearColor];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.textColor = NAVIGATIONBARCOLOR;
        [_titleL sizeToFit];
    }
    return _titleL;
}
-(UILabel *)detailTitleL
{
    if (!_detailTitleL) {
        _detailTitleL = [UILabel new];
        _detailTitleL.font = [UIFont systemFontOfMutableSize:11];
        _detailTitleL.text = @"测试";
        _detailTitleL.textAlignment = NSTextAlignmentCenter;
        _detailTitleL.backgroundColor = [UIColor clearColor];
        _detailTitleL.textColor = NAVIGATIONBARCOLOR_LIGHT;
        [_detailTitleL sizeToFit];
    }
    return _detailTitleL;
}
-(void)setModel:(YMCollectionModel *)model
{
    _model = model;
    self.titleL.text = [NSString stringWithFormat:@"%@元", model.title];
    self.detailTitleL.text = [NSString stringWithFormat:@"售价:%@元",model.detailTitle];
    if (model.canRech) {
        self.titleL.textColor = NAVIGATIONBARCOLOR;
        self.detailTitleL.textColor = NAVIGATIONBARCOLOR_LIGHT;
        self.backView.layer.borderColor = NAVIGATIONBARCOLOR.CGColor;
    }else
    {
        self.titleL.textColor = FONTCOLOR;
        self.detailTitleL.textColor = FONTCOLOR;
        self.backView.layer.borderColor = LAYERCOLOR.CGColor;
    }
    
}
@end
