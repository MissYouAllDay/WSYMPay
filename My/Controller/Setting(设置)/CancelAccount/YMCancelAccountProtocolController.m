//
//  YMCancelAccountProtocolController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/13.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMCancelAccountProtocolController.h"
#import "YMProtocolButton.h"
#import "YMRedBackgroundButton.h"
#import "ProtocolViewController.h"
#import "YMCancelAccountGetVCodeController.h"
#import "YMUserInfoTool.h"
#import "YMCancelAccountVPasswordVController.h"
#import "YMResponseModel.h"

@interface YMCancelAccountProtocolController ()<YMProtocolButtonDelegate>

@property (nonatomic, weak) YMRedBackgroundButton *registerBtn;

@property (nonatomic, strong) YMCancelAccountGetVCodeController *getVCodeVC;

@property (nonatomic, copy) NSString *resMsgTitleStr;

@property (nonatomic, copy) NSString *resMsgStr;

@property (nonatomic, weak) YMProtocolButton *agreementButton;

@end

@implementation YMCancelAccountProtocolController
#pragma mark - getters and setters          - Method -
-(YMCancelAccountGetVCodeController *)getVCodeVC
{
    if (!_getVCodeVC) {
        _getVCodeVC = [[YMCancelAccountGetVCodeController alloc]init];
    }
    return _getVCodeVC;
}
- (void)setModel:(YMResponseModel *)model
{
    _model = model;
    if (_model == nil) {
        return;
    }
    if ([_model getResCode] == 1) {//账户校验成功，显示固定文字
        self.resMsgTitleStr = @"注销通过后,将有如下变更:";
        self.resMsgStr = @"1.个人身份信息、账户信息、其他优惠积分或资金等权益信息将被清空且不可恢复;\n2.所有的交易记录将被删除，请确认当前您的所有交易记录已完成且无纠纷;\n3.账户注销后的订单记录可能产生的资金退回权益将视作自动放弃。";
    }else{//校验失败，显示返回的resMsg，需要将 。替换成 \n 实现换行
        self.resMsgTitleStr = @"由于以下原因，您的账户无法注销:";
        NSString *resMsg = [[_model getResMsg] stringByReplacingOccurrencesOfString:@"。" withString:@"\n"];
        self.resMsgStr = resMsg;
    }
}
#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupSubviews];
}

#pragma mark - privateMethods               - Method -
-(void)setupSubviews
{
    self.view.backgroundColor = VIEWGRAYCOLOR;
    self.navigationItem.title = @"注销账户";
    
    NSString *text = self.resMsgStr;
    
    if ((![text isEmptyStr])&&(text != nil)) {
        
        UIView *contentView         = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:contentView];
        
        UILabel *titleLabel  = [[UILabel alloc]init];
        titleLabel.font      = [UIFont systemFontOfMutableSize:17];
        titleLabel.textColor = FONTDARKCOLOR;
        titleLabel.text      = self.resMsgTitleStr;
        [titleLabel sizeToFit];
        [contentView addSubview:titleLabel];
        
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
        [explainLabel sizeToFit];
        [contentView addSubview:explainLabel];
    
        CGFloat interval = SCREENHEIGHT *0.04;
    
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(interval);
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
        }];
        
        [explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(interval * 0.5);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
        }];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.bottom.equalTo(explainLabel.mas_bottom).offset(interval);
            make.width.equalTo(self.view.mas_width);
        }];
        
        //协议按钮
        YMProtocolButton *agreementButton = [[YMProtocolButton alloc]init];
        agreementButton.delegate         = self;
        agreementButton.selected         = NO;
        agreementButton.title            = @"同意《网上有名服务协议》";
        self.agreementButton = agreementButton;
        //下一步按钮
        YMRedBackgroundButton*registerBtn = [[YMRedBackgroundButton alloc]init];
        registerBtn.enabled               = NO;
        [registerBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [registerBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.registerBtn = registerBtn;
        
        if ([_model getResCode] == 1) {//校验通过时显示
            [self.view addSubview:agreementButton];
            [self.view addSubview:registerBtn];
            
            [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(interval);
                make.top.equalTo(contentView.mas_bottom).offset(interval);
                make.height.mas_equalTo(23);
                make.width.equalTo(self.view.mas_width).multipliedBy(.6);
            }];
            
            [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.mas_centerX);
                make.top.equalTo(agreementButton.mas_bottom).with.offset(interval *1.3);
                make.height.mas_equalTo(SCREENWIDTH*ROWProportion);
                make.width.equalTo(self.view.mas_width).multipliedBy(.9);
            }];
        }
    }
    
}
#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -（AgreementButtonDelegate）
-(void)protocolButtonTitleBtnDidClick:(YMProtocolButton *)agBtn
{
    ProtocolViewController *protocolVC = [[ProtocolViewController alloc]init];
    WEAK_SELF;
    protocolVC.block = ^(){
        weakSelf.agreementButton.selected = YES;
        [weakSelf protocolButtonImageBtnSelected:nil];
    };
    [self.navigationController pushViewController:protocolVC animated:YES];
}

-(void)protocolButtonImageBtnSelected:(YMProtocolButton *)agBtn
{
    if (agBtn.isSelected) {
        
        self.registerBtn.enabled = YES;
    } else {
    
        self.registerBtn.enabled = NO;
    }
}

-(void)nextBtnClick
{
    if ([_model getUsrStatus] == -1) {//未实名
        [self.navigationController pushViewController:self.getVCodeVC animated:YES];
    }else{
        YMCancelAccountVPasswordVController *vPasswordVC = [[YMCancelAccountVPasswordVController alloc]init];
        [self.navigationController pushViewController:vPasswordVC animated:YES];
    }
}

@end
