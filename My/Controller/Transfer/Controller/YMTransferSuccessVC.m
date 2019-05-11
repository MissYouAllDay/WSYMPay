//
//  YMTransferSuccessVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferSuccessVC.h"
#import "YMTransferDetailsVC.h"
#import "YMTransferCheckPayPwdDataModel.h"
#import "YMTransferVC.h"
#import "YMAllBillDetailVC.h"
#import "YMAllBillListDataListModel.h"
#import "YMScanViewController.h"
@interface YMTransferSuccessVC ()

@end

@implementation YMTransferSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title   = @"转账结果";
    self.statusImageView.image  = [UIImage imageNamed:@"success"];
    self.mainTitleLabel.text    = @"转账成功";
    [self.finishBtn setTitle:@"查看账单详情" forState:UIControlStateNormal];
    NSMutableString *str = [NSMutableString stringWithFormat:@"对方已收到您的%@元款项",self.transferMoney];
    self.subTitleLabel.text = str;
    [self updateSubviewsUI];
}

-(void)finishBtnClick
{//查看账单详情
//    YMTransferDetailsVC *orderVC = [[YMTransferDetailsVC alloc]init];
//    orderVC.orderNo              = self.orderNo;
//    [self.navigationController pushViewController:orderVC animated:YES];
//    [self dissmissCurrentViewController:1];
    
    YMAllBillDetailVC *detailVC = [[YMAllBillDetailVC alloc] init];
    detailVC.billDetailType = BillDetailAccountTransfer;//转账(我要收款/ 扫一扫有名收款码)
    [detailVC sendOrderNo:self.orderNo tranType:@"4"];
    [self.navigationController pushViewController:detailVC animated:YES];
    [self dissmissCurrentViewController:1];
}

- (void)setDataModel:(YMTransferCheckPayPwdDataModel *)dataModel
{
    _dataModel = dataModel;
    if (_dataModel == nil) {
        return;
    }
    self.orderNo       = [_dataModel getTraordNoStr];
    self.transferMoney = [_dataModel getTxAmtStr];
}

-(void)backBtnTouchUp
{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[YMTransferVC class]]) {//返回到转账界面。。。
            [self.navigationController popToViewController:controller animated:YES];
        }
        if ([controller isKindOfClass:[YMScanViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }

    }
}

-(void)setupNavigationItem
{
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTouchUp)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigationItem];
}

@end
