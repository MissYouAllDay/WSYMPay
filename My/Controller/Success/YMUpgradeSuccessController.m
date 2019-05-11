//
//  YMUpgradeSuccessController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/12.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMUpgradeSuccessController.h"
#import "YMRedBackgroundButton.h"
#import "UIView+Extension.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface YMUpgradeSuccessController ()
@end

@implementation YMUpgradeSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}


-(void)setupSubviews
{
    self.view.backgroundColor  = VIEWGRAYCOLOR;
    self.navigationItem.title  = @"升级完成";
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    UIImageView *successImage = [[UIImageView alloc]init];
    successImage.image        = [UIImage imageNamed:@"success"];
    [successImage sizeToFit];
    [contentView addSubview:successImage];
    
    UILabel *successLabel = [[UILabel alloc]init];
    
    NSString *text =  @"成功升级为III类账户\n余额支付额度为20万元/年";
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedText addAttributes:[NSDictionary attributesForUserTextWithlineHeightMultiple:1.5] range:NSMakeRange(0, text.length)];
    [attributedText addAttribute:NSFontAttributeName value:COMMON_FONT range:NSMakeRange(0, text.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:FONTDARKCOLOR range:NSMakeRange(0, text.length)];
    successLabel.textAlignment  = NSTextAlignmentCenter;
    successLabel.attributedText = attributedText;
    successLabel.numberOfLines  = 0;
    [successLabel sizeToFit];
    [contentView addSubview:successLabel];
    
    
    //注册按钮
    YMRedBackgroundButton*finishBtn = [[YMRedBackgroundButton alloc]init];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
    
    
    CGFloat contentViewH = SCREENHEIGHT * 0.35;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(contentViewH);
        make.width.equalTo(self.view.mas_width);
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        
    }];
    
    CGFloat interval = (contentViewH - successImage.height - successLabel.height) / 3;
    
    [successImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contentView.mas_top).offset(interval);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(successImage.mas_bottom).offset(interval);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(SCREENWIDTH*ROWProportion);
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.top.equalTo(contentView.mas_bottom).offset(SCREENWIDTH*ROWProportion);
    }];

}

-(void)finishBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
