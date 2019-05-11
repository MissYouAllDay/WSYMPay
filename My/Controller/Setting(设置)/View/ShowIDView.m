//
//  ShowIDView.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/28.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "ShowIDView.h"

@interface ShowIDView ()

@property (nonatomic, weak)UIImageView *imageView;

@end

@implementation ShowIDView


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
    self.backgroundColor = RGBAlphaColor(0, 0, 0, 0.7);
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode  = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    self.imageView = imageView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.mas_width);
        make.centerX .equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(SCREENHEIGHT *0.3);
        
    }];
}

-(void)showImage:(UIImage *)image
{
    self.imageView.image = image;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(SCREENHEIGHT);
        make.centerY.equalTo(keyWindow.mas_centerY);
        make.centerX.equalTo(keyWindow.mas_centerX);
        
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
@end
