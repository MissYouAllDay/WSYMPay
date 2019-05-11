//
//  FirstRealNameCertificationViewController.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 16/9/21.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "IDUploadSucessController.h"
#import "AddBankCardViewController.h"

@interface IDUploadSucessController ()
{
    UIImageView * iconImgV;
}

@end
//
//0.296
@implementation IDUploadSucessController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.tag = 500;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self initViews];
    // Do any additional setup after loading the view.
}

-(void)setup
{
    self.view.backgroundColor           = VIEWGRAYCOLOR;
    self.navigationItem.title           = @"身份证验证";
    self.navigationItem.hidesBackButton = YES;
}

-(void)initViews
{
    UIImageView * imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"completed"];
    iconImgV = imageView;
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).multipliedBy(0.224);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.25);
        make.height.equalTo(imageView.mas_width);
    }];
    
    UILabel * msgL = [UILabel new];
    msgL.numberOfLines = 0;
    msgL.backgroundColor = [UIColor whiteColor];
    msgL.textColor = FONTDARKCOLOR;
    msgL.font = [UIFont systemFontOfSize:DEFAULTFONT(14)];
    msgL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:msgL];
    
    NSMutableAttributedString * mutableStr = [[NSMutableAttributedString alloc] initWithString:MSG8];
    NSMutableParagraphStyle * style        = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineHeightMultiple               = 1.5;//行间距是多少倍
    style.alignment                        = NSTextAlignmentCenter;//对齐方式
    [mutableStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,mutableStr.length)];
    msgL.attributedText = mutableStr;
    
    [msgL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).multipliedBy(0.485);
        make.height.equalTo(msgL.mas_width).multipliedBy(0.305);
    }];
    
    
    UIButton * nextBtn = [UIButton new];
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login_seclected"] forState:UIControlStateHighlighted];
    [nextBtn setTitle:@"返 回" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    nextBtn.titleLabel.font = [UIFont systemFontOfMutableSize:14];
    nextBtn.layer.cornerRadius = CORNERRADIUS;
    
    [nextBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(msgL.mas_bottom).offset(30);
        make.height.equalTo(nextBtn.mas_width).multipliedBy(0.144);
    }];
    
}
-(void)sure:(UIButton *)sender
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1]animated:YES];
}


@end
