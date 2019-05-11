//
//  YMAddBankCardController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/11/30.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMAddBankCardController.h"
#import "YMGetUserInputCell.h"
#import "YMUserInfoTool.h"
#import "YMRedBackgroundButton.h"
#import "UIView+Extension.h"
#import "YMCardholderInfoController.h"
#import "YMMyHttpRequestApi.h"
#import "YMBankCardModel.h"
#import "UITextField+Extension.h"
@interface YMAddBankCardController ()<UITextFieldDelegate>

@property (nonatomic, weak) YMRedBackgroundButton *nextBtn;

@property (nonatomic, weak) UILabel *warningLabel;

@property (nonatomic, copy) NSString *bankCardNo;

@end

@implementation YMAddBankCardController

- (instancetype)init
{
   
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];

}

-(void)setupSubviews
{
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.navigationItem.title = @"添加银行卡";
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, SCREENWIDTH * 0.2, 0, 0)];
    
    //注册按钮
    YMRedBackgroundButton*nextBtn = [[YMRedBackgroundButton alloc]init];
    nextBtn.enabled               = NO;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    UILabel *warningLabel = [[UILabel alloc]init];
    warningLabel.text      = @"信息加密处理,仅用于银行验证";
    warningLabel.font      = [UIFont systemFontOfSize:[VUtilsTool fontWithString:12]];
    warningLabel.textColor = RGBColor(150, 150, 150);
    [self.tableView addSubview:warningLabel];
    self.warningLabel = warningLabel;
    
}

-(void)nextBtnClick
{
    [self.view endEditing:YES];
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetBankType:self.bankCardNo success:^(YMBankCardModel *bankCard) {
        YMCardholderInfoController *cardInfoVC = [[YMCardholderInfoController alloc]init];
        cardInfoVC.bankCardModel               = bankCard;
        cardInfoVC.bankCardModel.bankAcNo      = weakSelf.bankCardNo;
        
        [self.navigationController pushViewController:cardInfoVC animated:YES];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"cell";
    
    YMGetUserInputCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[YMGetUserInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.row == 0) {
        
        cell.leftTitle = @"姓名";
        cell.userInputTF.text = [YMUserInfoTool shareInstance].custName;
        cell.userInputTF.enabled = NO;
        
    } else {
    
        cell.leftTitle = @"卡号";
        cell.userInputTF.placeholder  = @"请输入卡号";
        cell.userInputTF.keyboardType = UIKeyboardTypeNumberPad;
        cell.userInputTF.delegate     = self;
        [cell.userInputTF addTarget:self action:@selector(textFieldDidEditingChange:) forControlEvents:UIControlEventEditingChanged];
        // 获取对应cell的rect值（其值针对于UITableView而言）
        CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
        
        self.warningLabel.x      = LEFTSPACE *2;
        self.warningLabel.height = LEFTSPACE;
        self.warningLabel.width  = SCREENWIDTH - LEFTSPACE *2;
        self.warningLabel.y      = rect.origin.y + rect.size.height + LEFTSPACE;
        
        self.nextBtn.height = SCREENWIDTH*ROWProportion;
        self.nextBtn.width  = SCREENWIDTH - LEFTSPACE * 2;
        self.nextBtn.x      = LEFTSPACE;
        self.nextBtn.y      = self.warningLabel.bottom + LEFTSPACE;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return LEFTSPACE;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

   return (SCREENWIDTH * ROWProportion);

}

-(void)textFieldDidEditingChange:(UITextField *)textField
{
    self.bankCardNo = [textField.text clearSpace];
    if ([textField.text clearSpace].length >= 16) {
        self.nextBtn.enabled = YES;
    } else {
        self.nextBtn.enabled = NO;
    }
}

#pragma mark - UITextField的输入规则
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  return [UITextField textFieldWithBankCardFormat:textField shouldChangeCharactersInRange:range replacementString:string];
}

@end
