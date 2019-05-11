//
//  FirstRealNameCertificationViewController.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 16/9/21.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "FirstRealNameCertificationViewController.h"
#import "AddBankCardViewController.h"

@interface FirstRealNameCertificationViewController ()
{
    UIImageView * iconImgV;
}

@end
//
//0.296
@implementation FirstRealNameCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEWGRAYCOLOR;
    self.title                = @"身份认证";
    [self initViews];
    // Do any additional setup after loading the view.
}
-(void)initViews
{
    UIImageView * imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"weirenz"];
    iconImgV = imageView;
    [self.view addSubview:imageView];
    
    UILabel * msgL = [UILabel new];
    msgL.numberOfLines = 0;
    msgL.backgroundColor = [UIColor whiteColor];
    msgL.textColor = FONTDARKCOLOR;
    msgL.font = [UIFont systemFontOfSize:DEFAULTFONT(15)];
    msgL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:msgL];
    
    NSMutableAttributedString * mutableStr = [[NSMutableAttributedString alloc] initWithString:MSG6];
    NSMutableParagraphStyle * style        = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineHeightMultiple               = 1.5;//行间距是多少倍
    style.alignment                        = NSTextAlignmentCenter;//对齐方式
    [mutableStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,mutableStr.length)];
    msgL.attributedText = mutableStr;
    
    UIButton * nextBtn = [UIButton new];
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login_seclected"] forState:UIControlStateHighlighted];
    [nextBtn setTitle:@"立即实名认证" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    nextBtn.titleLabel.font = [UIFont systemFontOfMutableSize:14];
    nextBtn.layer.cornerRadius = CORNERRADIUS;
    
    [nextBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).multipliedBy(0.224);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.25);
        make.height.equalTo(imageView.mas_width);
    }];
    
    [msgL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).multipliedBy(0.485);
        make.height.equalTo(msgL.mas_width).multipliedBy(0.305);
    }];
    
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.equalTo(msgL.mas_bottom).offset(30);
        make.height.equalTo(nextBtn.mas_width).multipliedBy(0.144);
    }];
    
    
}
-(void)sure:(UIButton *)sender
{
    AddBankCardViewController* addBankCardVC = [[AddBankCardViewController alloc]init];
    [self.navigationController pushViewController:addBankCardVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
