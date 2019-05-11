//
//  YMAllCollectionViewCell.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/19.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllCollectionViewCell.h"
@interface YMAllCollectionViewCell()
@property (strong ,nonatomic) UILabel * titleL;
@property (strong ,nonatomic) UIImageView * imgView;
@end

@implementation YMAllCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.imgView];
        
        [self.contentView addSubview:self.titleL];
    }
    return self;
}
-(void)layoutSubviews
{
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(-12);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(self.imgView.mas_width);

    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.imgView.mas_bottom).offset(8);
    }];
}
-(UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.backgroundColor = [UIColor clearColor];
    }
    return _imgView;
}
-(UILabel *)titleL
{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = [UIFont systemFontOfMutableSize:13];
        _titleL.text = @"测试";
        _titleL.backgroundColor = [UIColor clearColor];
        [_titleL sizeToFit];
    }
    return _titleL;
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleL.text = title;
}
-(void)setImgName:(NSString *)imgName
{
    _imgName = imgName;
    self.imgView.image = [UIImage imageNamed:imgName];
}
-(void)setModel:(YMCollectionModel *)model
{
    _model = model;
    _title = model.title;
    self.titleL.text = model.title;
    _imgName = model.imgName;
    self.imgView.image = [UIImage imageNamed:model.imgName];
    
}
@end
