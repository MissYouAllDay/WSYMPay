//
//  YMAddGetVCodeController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/5.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMAddGetVCodeController.h"
#import "VerificationView.h"
#import "YMRedBackgroundButton.h"
#import "UIView+Extension.h"
@interface YMAddGetVCodeController ()<VerificationViewDelegate>

@end

@implementation YMAddGetVCodeController

-(VerificationView *)verificationView{
    if (!_verificationView) {
        VerificationView *verificationView    = [[VerificationView alloc]init];
        verificationView.delegate             = self;
        verificationView.countdownButtonTitle = @"发送验证码";
        _verificationView = verificationView;
        
    }
    return _verificationView;
}

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

-(YMRedBackgroundButton *)nextBtn
{
    if (!_nextBtn) {
        
        //注册按钮
        YMRedBackgroundButton*nextBtn = [[YMRedBackgroundButton alloc]init];
        nextBtn.enabled               = NO;
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:nextBtn];
        _nextBtn = nextBtn;
    }
    
    return _nextBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NotFirstLoad = NO;
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (self.isNotFirstLoad && _verificationView.verificationCode.length == 0) {
        
        [MBProgressHUD showText:MSG2];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:self.verificationView];
    
    self.verificationView.x      = LEFTSPACE;
    self.verificationView.y      = 0;
    self.verificationView.height = (SCREENWIDTH * ROWProportion);
    self.verificationView.width  = self.view.width - LEFTSPACE * 2;
    
    CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
    
    self.nextBtn.x      = LEFTSPACE;
    self.nextBtn.y      = rect.origin.y + rect.size.height + LEFTSPACE *1.5;
    self.nextBtn.height = rect.size.height;
    self.nextBtn.width  = rect.size.width - LEFTSPACE *2;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERSECTION_HEIGHT;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return (SCREENWIDTH * ROWProportion);
    
}

//倒计时按钮点击
-(void)verificationViewCountdownButtonDidClick:(VerificationView *)verificationView
{
    [self loadCerCode];
    
    
}

-(void)nextBtnClick
{
    [self.view endEditing:YES];
}

-(void)loadCerCode
{
    [self.view endEditing:YES];

}

- (void)verificationViewTextDidEditingChange:(NSString *)text
{
    if (text.length == 5) {
        self.textFieldStr = text;
        self.nextBtn.enabled = YES;
    } else {
        self.nextBtn.enabled = NO;
    }
    
}

@end
