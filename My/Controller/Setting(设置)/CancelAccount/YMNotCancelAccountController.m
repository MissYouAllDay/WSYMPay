//
//  YMNotCancelAccountController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/13.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMNotCancelAccountController.h"
#import "YMUserInfoTool.h"
@interface YMNotCancelAccountController ()

@end

@implementation YMNotCancelAccountController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubviews];
}

-(void)setupSubviews
{
    self.view.backgroundColor = VIEWGRAYCOLOR;
    
    self.navigationItem.title = @"注销账户";
    
    UIView *contentView         = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    
    UILabel *titleLabel  = [[UILabel alloc]init];
    titleLabel.font      = [UIFont systemFontOfMutableSize:17];
    titleLabel.textColor = FONTDARKCOLOR;
    titleLabel.text      = @"由于以下原因,您的账户无法注销:";
    [titleLabel sizeToFit];
    [contentView addSubview:titleLabel];
    
    
    NSString *text = nil;
    
    if ([YMUserInfoTool shareInstance].usrStatus == -1) {
        
        text = @"1.账户注册时间未满15天;\n2.您的账户状态异常,请核对账户状态并处理后再注销账户。";
        
    } else {
    
        text = @"1.账户注册时间未满15天;\n2.您的账户状态异常,请核对账户状态并处理后再注销账户;\n3.您虚拟账户中的可用余额不为0,请将可用余额提现或消费后再注销;\n4.您虚拟账户中的不可用余额不为0,请将您名下的异常交易处理后再注销;\n5.您虚拟账户中的冻结余额不为0,请将您名下的异常交易处理后再注销;\n6.您的交易中有未完成的商品订单,账户无法注销;\n7.您的交易中有未完成的提现订单,账户无法注销;\n8.您的交易中有未完成的充值订单,账户无法注销;\n9.您的交易中有未完成的转账订单,账户无法注销。";
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    
    NSMutableParagraphStyle *paragraphStyle     = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple           = 1.5;//调整行间距
    paragraphStyle.lineBreakMode                = NSLineBreakByCharWrapping;
    paragraphStyle.paragraphSpacing             = 0;//段落后面的间距
    paragraphStyle.paragraphSpacingBefore       = 0;//段落之前的间距
    paragraphStyle.alignment                    = NSTextAlignmentLeft;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfMutableSize:12] range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:FONTCOLOR range:NSMakeRange(0, attributedText.length)];
    UILabel *explainLabel       = [[UILabel alloc]init];
    explainLabel.numberOfLines  = 0;
    explainLabel.attributedText = attributedText;
    CGSize size = [explainLabel sizeThatFits:CGSizeMake(SCREENWIDTH * 0.85, MAXFLOAT)];
    
    [contentView addSubview:explainLabel];
    
    
    
    CGFloat interval = SCREENHEIGHT *0.04;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(explainLabel.mas_left).offset(-5);
        make.top.mas_equalTo(interval);
        
    }];
    
    [explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(titleLabel.mas_bottom).offset(interval * 0.5);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
        make.centerX.equalTo(self.view.mas_centerX);
        
        
        
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(explainLabel.mas_bottom).offset(interval);
        make.width.equalTo(self.view.mas_width);
        
    }];
    

}




@end
