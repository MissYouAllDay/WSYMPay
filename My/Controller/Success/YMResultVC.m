//
//  YMResultVCViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMResultVC.h"
#import "YMRedBackgroundButton.h"
@interface YMResultVC ()
@property (nonatomic, weak) UIView *contentView;
@end

@implementation YMResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}



-(void)setupSubviews
{
    self.view.backgroundColor  = VIEWGRAYCOLOR;
  
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    UIImageView *statusImageView = [[UIImageView alloc]init];
    [contentView addSubview:statusImageView];
    self.statusImageView = statusImageView;
    
    UILabel *mainTitleLabel = [[UILabel alloc]init];
    mainTitleLabel.font = [UIFont systemFontOfMutableSize:20];
    mainTitleLabel.numberOfLines  = 0;
    [contentView addSubview:mainTitleLabel];
    self.mainTitleLabel = mainTitleLabel;
    
    UILabel *subTitleLabel = [[UILabel alloc]init];
    subTitleLabel.textAlignment  = NSTextAlignmentCenter;
    subTitleLabel.textColor = [UIColor blackColor];
    subTitleLabel.font      = [UIFont systemFontOfMutableSize:14];
    subTitleLabel.numberOfLines  = 0;
    [contentView addSubview:subTitleLabel];
    self.subTitleLabel = subTitleLabel;
    
    
    //注册按钮
    YMRedBackgroundButton*finishBtn = [[YMRedBackgroundButton alloc]init];
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
    self.finishBtn = finishBtn;
    
    CGFloat contentViewH = SCREENHEIGHT * 0.35;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentViewH);
        make.width.equalTo(self.view.mas_width);
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
    }];
    
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(SCREENWIDTH*ROWProportion);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.top.equalTo(contentView.mas_bottom).offset(SCREENWIDTH*ROWProportion);
    }];
}

-(void)updateSubviewsUI
{
    [self.statusImageView sizeToFit];
    [self.mainTitleLabel sizeToFit];
    [self.subTitleLabel sizeToFit];
    
    CGFloat interval = (SCREENHEIGHT * 0.35 - self.statusImageView.height - self.mainTitleLabel.height - self.subTitleLabel.height) / 4;
    
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(interval);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusImageView.mas_bottom).offset(interval);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainTitleLabel.mas_bottom).offset(interval/2);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];

}

-(void)finishBtnClick
{

}


@end
