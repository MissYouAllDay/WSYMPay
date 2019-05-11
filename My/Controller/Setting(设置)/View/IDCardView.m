//
//  IDCardView.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/27.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "IDCardView.h"

@interface IDCardView ()

@property (nonatomic, weak)UIButton *frontPhotoButton;

@property (nonatomic, weak)UIButton *backPhotoButton;

@end

@implementation IDCardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews
{
    self.backgroundColor = [UIColor whiteColor];

    UIButton *frontPhotoButton = [[UIButton alloc]init];
    [frontPhotoButton setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    frontPhotoButton.contentMode = UIViewContentModeScaleAspectFill;
    [frontPhotoButton addTarget:self action:@selector(frontPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:frontPhotoButton];
    self.frontPhotoButton = frontPhotoButton;
    
    UIButton *backPhotoButton = [[UIButton alloc]init];
    [backPhotoButton setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    backPhotoButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [backPhotoButton addTarget:self action:@selector(backPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backPhotoButton];
    self.backPhotoButton = backPhotoButton;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.frontPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(LEFTSPACE);
        make.left.equalTo(self.mas_left).offset(LEFTSPACE);
        make.right.equalTo(self.mas_centerX).offset(-LEFTSPACE/2);
        make.bottom.equalTo(self.mas_bottom).offset(-LEFTSPACE);
    }];
    
    [self.backPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(LEFTSPACE);
        make.left.equalTo(self.mas_centerX).offset(LEFTSPACE/2);
        make.right.equalTo(self.mas_right).offset(-LEFTSPACE);
        make.bottom.equalTo(self.mas_bottom).offset(-LEFTSPACE);
    }];
}

#pragma mark - 正面照片点击
-(void)frontPhotoButtonClick
{
    if ([self.delegate respondsToSelector:@selector(idCardViewFrontPhotoButtonDidClick:)]) {
        
        [self.delegate idCardViewFrontPhotoButtonDidClick:self];
    }
    
}
#pragma mark - 反面照片点击
-(void)backPhotoButtonClick
{
    if ([self.delegate respondsToSelector:@selector(idCardViewBackPhotoButtonDidClick:)]) {
        [self.delegate idCardViewBackPhotoButtonDidClick:self];
    }
    
}
#pragma mark - 手持照片点击

-(void)setFrontImage:(UIImage *)frontImage
{
    _frontImage = frontImage;
    [self.frontPhotoButton setImage:_frontImage forState:UIControlStateNormal];

}

-(void)setBackImage:(UIImage *)backImage
{
    _backImage = backImage;
    [self.backPhotoButton setImage:_backImage forState:UIControlStateNormal];
    
}

@end
