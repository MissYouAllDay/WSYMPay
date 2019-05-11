//
//  YMAllBillVC.m
//  WSYMPay
//
//  Created by pzj on 2017/7/19.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillVC.h"
#import "YMAllBillListVC.h"
#import "YMBillRecordListVC.h"

@interface YMAllBillVC ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation YMAllBillVC

#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
#pragma mark
- (void)initView{
    self.title = @"账单";
    self.view.backgroundColor = VIEWGRAYCOLOR;
    
    YMBillRecordListVC *vc = [[YMBillRecordListVC alloc] init];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"消费" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        vc.billType = BillConsume;
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"转账" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        vc.billType = BillAccountTransfer;
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"账户提现" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        vc.billType = BillAccountRecharge;
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"账户充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        vc.billType = BillAccountWithDrawal;
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController addAction:action4];
    [alertController addAction:action5];
    [self presentViewController:alertController animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
