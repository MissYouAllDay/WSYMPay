//
//  YMScanPayFailVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMScanPayFailVC.h"
#import "YMScanDetailsVC.h"
#import "YMAllBillDetailVC.h"

@interface YMScanPayFailVC ()

@end

@implementation YMScanPayFailVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.errorCode = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付结果";
    self.statusImageView.image  = [UIImage imageNamed:@"fail"];
    self.mainTitleLabel.text    = @"支付失败";
    self.subTitleLabel.text     = self.errorCode;
    [self.finishBtn setTitle:@"查看账单详情" forState:UIControlStateNormal];
    [self updateSubviewsUI];
}

-(void)finishBtnClick
{
    YMAllBillDetailVC *detailVC = [[YMAllBillDetailVC alloc] init];
    detailVC.billDetailType = BillDetailPCScan;
    [detailVC sendOrderNo:self.orderNo tranType:@"1"];
    [self.navigationController pushViewController:detailVC animated:YES];
    [self dissmissCurrentViewController:1];
    
//    YMScanDetailsVC *orderVC = [[YMScanDetailsVC alloc]init];
//    orderVC.orderNO = self.orderNo;
//    orderVC.isPay   = NO;
//    [self.navigationController pushViewController:orderVC animated:YES];
//    [self dissmissCurrentViewController:1];
}


@end
