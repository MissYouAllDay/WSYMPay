//
//  YMTransferProcessVC.m
//  WSYMPay
//
//  Created by pzj on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferProcessVC.h"
#import "YMTransferProcessTool.h"
#import "YMTransferVC.h"
#import "YMTransferCheckPayPwdDataModel.h"
#import "YMTransferDetailsVC.h"
#import "YMAllBillDetailVC.h"
#import "YMScanViewController.h"

@interface YMTransferProcessVC ()<YMTransferProcessToolDelegate>
@property (nonatomic, strong) YMTransferProcessTool *tableViewTool;
@property (nonatomic, copy) NSString *orderNo;
@end

@implementation YMTransferProcessVC

#pragma mark - lifeCycle                    - Method -

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - privateMethods               - Method -
- (void) initViews
{
    self.view.backgroundColor = VIEWGRAYCOLOR;
    self.title = @"转账结果";
    
    self.tableView.delegate = [self tableViewTool];
    self.tableView.dataSource = [self tableViewTool];
}

#pragma mark - eventResponse                - Method -
- (void)leftBarClick
{//返回到转账界面。。。
    [WSYMNSNotification postNotificationName:WSYMRefreshTransferNotification object:nil];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[YMTransferVC class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
        if ([controller isKindOfClass:[YMScanViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void)selectCheckDetailBtn
{//进入订单详情界面。。。
//    YMTransferDetailsVC *orderVC = [[YMTransferDetailsVC alloc]init];
//    orderVC.orderNo = self.orderNo;
//    [self.navigationController pushViewController:orderVC animated:YES];
    
    YMAllBillDetailVC *detailVC = [[YMAllBillDetailVC alloc] init];
    detailVC.billDetailType = BillDetailAccountTransfer;//转账(我要收款/ 扫一扫有名收款码)
    [detailVC sendOrderNo:self.orderNo tranType:@"4"];
    [self.navigationController pushViewController:detailVC animated:YES];
    [self dissmissCurrentViewController:1];
}

#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -
- (YMTransferProcessTool *)tableViewTool
{
    if (!_tableViewTool) {
        _tableViewTool = [[YMTransferProcessTool alloc] initWithTableView];
        _tableViewTool.tableView = self.tableView;
        _tableViewTool.delegate = self;
    }
    return _tableViewTool;
}
- (void)setDataModel:(YMTransferCheckPayPwdDataModel *)dataModel
{
    _dataModel = dataModel;
    if (_dataModel == nil) {
        return;
    }
    [self tableViewTool].dataModel = _dataModel;
    self.orderNo = [_dataModel getTraordNoStr];
    [self.tableView reloadData];

}
@end
