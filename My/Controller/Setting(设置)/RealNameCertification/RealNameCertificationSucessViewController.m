//
//  RealNameCertificationSucessViewController.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 16/9/21.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "RealNameCertificationSucessViewController.h"
#import "IDVerificationViewController.h"


@interface RealNameCertificationSucessViewController ()
{
    UIImageView * iconImgV;
}

@end

@implementation RealNameCertificationSucessViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEWGRAYCOLOR;
    self.title = @"身份认证";
    [self initViews];

}
-(void)initViews
{
    UIImageView * imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"yirenz"];
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
    
    NSMutableAttributedString * mutableStr = [[NSMutableAttributedString alloc] initWithString:MSG7];
    NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    style.headIndent = 15;//头部缩进，相当于左padding
//    style.tailIndent = -15;//相当于右padding
    style.lineHeightMultiple = 1.5;//行间距是多少倍
    style.alignment = NSTextAlignmentCenter;//对齐方式
    [mutableStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,mutableStr.length)];
    msgL.attributedText = mutableStr;
    
    [msgL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).multipliedBy(0.485);
        make.height.equalTo(msgL.mas_width).multipliedBy(0.305);
    }];
    
    UIButton * cancleBtn = [UIButton new];
    [cancleBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"code_selected"] forState:UIControlStateNormal];
    [cancleBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"code_focus"] forState:UIControlStateHighlighted];
    [cancleBtn setTitle:@"以后再说" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:LoginButtonBackgroundColor forState:UIControlStateNormal];
    [cancleBtn setTitleColor:LoginButtonBackgroundColor forState:UIControlStateHighlighted];
    
    cancleBtn.titleLabel.font = [UIFont systemFontOfMutableSize:14];
    cancleBtn.layer.cornerRadius = CORNERRADIUS;
    
    [cancleBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.top.equalTo(msgL.mas_bottom).offset(30);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.15).offset(-5.5);
    }];
    
    UIButton * nextBtn = [UIButton new];
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login_seclected"] forState:UIControlStateHighlighted];
    [nextBtn setTitle:@"升级账户" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    nextBtn.titleLabel.font = [UIFont systemFontOfMutableSize:14];
    nextBtn.layer.cornerRadius = CORNERRADIUS;
    
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancleBtn.mas_right).offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(msgL.mas_bottom).offset(30);
        make.height.equalTo(cancleBtn.mas_height);
        make.width.equalTo(cancleBtn.mas_width);
    }];
    
}

-(void)back:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    YMLog(@"以后再说");
    
}
-(void)next:(UIButton *)sender
{
    IDVerificationViewController * idVC = [[IDVerificationViewController alloc] init];
    idVC.verificationStatus             = IDVerificationStatusNotStart;
    [self.navigationController pushViewController:idVC animated:YES];
    [self dissmissCurrentViewController:1];
}


@end
