//
//  YMFindOtherCell.m
//  WSYMPay
//
//  Created by MaKuiying on 2017/7/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMFindOtherCell.h"

@interface YMFindOtherCell()



@end

@implementation YMFindOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.iconLableName.font = [UIFont systemFontOfMutableSize:13];
    _img0.layer.cornerRadius = 4.0;
    _img0.layer.masksToBounds = YES;
    _img0.layer.borderColor = LAYERCOLOR.CGColor;
    _img0.layer.borderWidth = 1.0f;
    _img0.contentMode = UIViewContentModeScaleAspectFit;
    _img0.backgroundColor = COLUMNBACKGROUNDCOLOR;
    
    _img1.layer.cornerRadius = 4.0;
    _img1.layer.masksToBounds = YES;
    _img1.layer.borderColor = LAYERCOLOR.CGColor;
    _img1.layer.borderWidth = 1.0f;
    _img1.contentMode = UIViewContentModeScaleAspectFit;
    _img1.backgroundColor = COLUMNBACKGROUNDCOLOR;
    
    
    _img2.layer.cornerRadius = 4.0;
    _img2.layer.masksToBounds = YES;
    _img2.layer.borderColor = LAYERCOLOR.CGColor;
    _img2.layer.borderWidth = 1.0f;
    _img2.contentMode = UIViewContentModeScaleAspectFit;
    _img2.backgroundColor = COLUMNBACKGROUNDCOLOR;
    
    _img3.layer.cornerRadius = 4.0;
    _img3.layer.masksToBounds = YES;
    _img3.layer.borderColor = LAYERCOLOR.CGColor;
    _img3.layer.borderWidth = 1.0f;
    _img3.contentMode = UIViewContentModeScaleAspectFit;
    _img3.backgroundColor = COLUMNBACKGROUNDCOLOR;
    
    
    self.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer* tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction1:)];
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction1:)];
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction1:)];
    UITapGestureRecognizer* tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction1:)];
    _img0.userInteractionEnabled = YES;
    _img1.userInteractionEnabled = YES;
    _img2.userInteractionEnabled = YES;
    _img3.userInteractionEnabled = YES;
    _img0.tag = 0;
    _img1.tag = 1;
    _img2.tag = 2;
    _img3.tag = 3;
    
    [_img0 addGestureRecognizer:tap0];
    [_img1 addGestureRecognizer:tap1];
    [_img2 addGestureRecognizer:tap2];
    [_img3 addGestureRecognizer:tap3];
    
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(SCALEZOOM(15));
    }];
    
    [_img0 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-10);
        make.left.offset(10);
        make.top.equalTo(self.iconLableName.mas_bottom).offset(10);
        make.height.offset(SCALEZOOM(80));
    }];

    [_img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_img0.mas_centerX);
        make.top.equalTo(_img0.mas_bottom).offset(5);
        make.width.offset((SCREENWIDTH-3*10)/3);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        
    }];
    
    
    [_img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_img0.mas_left);
        make.top.equalTo(_img0.mas_bottom).offset(5);
        make.right.equalTo(_img2.mas_left).offset(-5);
        make.bottom.equalTo(_img2.mas_bottom);

    }];
    
    

    
    [_img3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_img2.mas_right).offset(5);
        make.top.equalTo(_img2.mas_top);
        make.right.equalTo(_img0.mas_right);
        make.bottom.equalTo(_img2.mas_bottom);
        
    }];
    

}
-(void)tapAction1:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(yMFindOtherCellDidSelected:)]) {
        UIImageView * imgV = (UIImageView *)sender.view;
        YMLog(@"%ld",(long)imgV.tag);
        NSArray* iconArr = self.model.C_IMAGE;
        YMColumnImageModel * iconModel = iconArr[imgV.tag];
        
        [self.delegate yMFindOtherCellDidSelected:iconModel];
    }

    
}
-(void)setModel:(YMColumnModel *)model
{
    _model = model;
    
    self.iconLableName.text = model.C_TITLE;

    NSArray* iconArr = model.C_IMAGE;
    self.headerImg.backgroundColor = [UIColor redColor];// NAVIGATIONBARCOLOR;
    
    [iconArr enumerateObjectsUsingBlock:^(YMColumnImageModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * imgUrl = [NSString stringWithFormat:@"%@%@",IP,obj.image];
        switch (idx) {
            case 0:
                [self.img0 sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE] options:SDWebImageRetryFailed];
                
                break;
            case 1:
                [self.img1 sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE] options:SDWebImageRetryFailed];
                
                break;
            case 2:
                [self.img2 sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE] options:SDWebImageRetryFailed];
                
                break;
            case 3:
                [self.img3 sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE] options:SDWebImageRetryFailed];
                
                break;
                
                
            default:
                break;
        }
    }];
    
}
@end
