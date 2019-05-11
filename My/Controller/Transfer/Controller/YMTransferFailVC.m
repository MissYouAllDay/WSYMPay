//
//  YMTransferFailVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferFailVC.h"
#import "YMTransferDetailsVC.h"
#import "YMTransferCheckPayPwdDataModel.h"
#import "YMTransferVC.h"
#import "YMScanViewController.h"
#import "YMAllBillDetailVC.h"

@interface YMTransferFailVC ()

@end

@implementation YMTransferFailVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"转账结果";
    
    self.statusImageView.image  = [UIImage imageNamed:@"fail"];
    self.mainTitleLabel.text    = @"转账失败";
    [self.finishBtn setTitle:@"查看账单详情" forState:UIControlStateNormal];
    self.subTitleLabel.text = self.errorCode;
    
    [self updateSubviewsUI];
    
}

-(void)finishBtnClick
{

    YMAllBillDetailVC *detailVC = [[YMAllBillDetailVC alloc] init];
    detailVC.billDetailType = BillDetailAccountTransfer;//转账(我要收款/ 扫一扫有名收款码)
    detailVC.hiddenFooterView = YES;
    [detailVC sendOrderNo:self.orderNo tranType:@"4"];
    [self.navigationController pushViewController:detailVC animated:YES];

}

-(void)backBtnTouchUp
{
    //返回到转账界面。。。
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[YMTransferVC class]]) {
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

- (void)setDataModel:(YMTransferCheckPayPwdDataModel *)dataModel
{
    _dataModel = dataModel;
    if (_dataModel == nil) {
        return;
    }
    self.orderNo   = [_dataModel getTraordNoStr];
    self.errorCode = [_dataModel getBackErrorStr];
}

@end
