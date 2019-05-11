//
//  YMScanDetailsVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/10.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMScanDetailsVC.h"
#import "YMMoneyView.h"
#import "YMGetUserInputCell.h"
#import "YMScanDetailsModel.h"
#import "YMMyHttpRequestApi.h"
#import "YMRedBackgroundButton.h"
#import "YMScanModel.h"
#import "YMPublicHUD.h"
#import "YMScanPaySuccessVC.h"
#import "YMScanPayFailVC.h"
#import "YMScanPayTool.h"

@interface YMScanDetailsVC ()
@property (nonatomic, strong) YMScanDetailsModel *details;
@property (nonatomic, strong) YMScanPayTool *payTool;
@property (nonatomic, assign) BOOL isLoad;

@end

@implementation YMScanDetailsVC

-(YMScanPayTool *)payTool
{
    if (!_payTool) {
        _payTool = [[YMScanPayTool alloc]init];
        [_payTool setNavigationVC:self.navigationController];
        WEAK_SELF;
        self.payTool.payResultBlock = ^(BOOL status, NSString *error) {
            if (status) {
                YMScanPaySuccessVC *successVC = [[YMScanPaySuccessVC alloc]init];
                successVC.transferMoney = weakSelf.details.txAmt;
                successVC.orderNo       = weakSelf.details.prdOrdNo;
                [weakSelf.navigationController pushViewController:successVC animated:YES];
                [weakSelf dissmissCurrentViewController:1];
                [WSYMNSNotification postNotificationName:WSYMRefreshTransferNotification object:nil];
            } else {
                YMScanPayFailVC  *failVC = [[YMScanPayFailVC alloc]init];
                failVC.errorCode = error;
                failVC.orderNo   = weakSelf.details.prdOrdNo;
                [weakSelf.navigationController pushViewController:failVC animated:YES];
                [weakSelf dissmissCurrentViewController:1];
            }
        };
        
    }
    return _payTool;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"账单详情";
    self.moneyView.hidden = YES;
    [self loadData];
}

-(void)loadData
{
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetScanDetailsParameters:self.orderNO success:^(id model) {
        
        weakSelf.details = model;
        weakSelf.moneyView.mainTtitle  = weakSelf.details.prdName;
        weakSelf.moneyView.money       = weakSelf.details.txAmt;
        weakSelf.moneyView.bottomTitle = weakSelf.details.ordStatus;
        weakSelf.isLoad = YES;
        weakSelf.moneyView.hidden = NO;
        [weakSelf.tableView reloadData];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isLoad ? 1:0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.details.payOrdNo?5:4;
}

-(YMGetUserInputCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"YMScanDetailsCell";
    
    YMGetUserInputCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[YMGetUserInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.userInputTF.enabled = NO;
        cell.userInputTF.placeholder = nil;
        cell.userInputTF.textColor  = RGBColor(79, 79, 79);
    }
    switch (indexPath.row) {
        case 0:
            cell.leftTitle = @"付款方式　";
            cell.userInputTF.text = self.details.payType;
            break;
            
        case 1:
            cell.leftTitle = @"商品信息　";
            cell.userInputTF.text = [NSString stringWithFormat:@"%@-%@",self.details.prdName,self.details.orderType];
            break;
            
        case 2:
            cell.leftTitle = @"创建时间　";
            cell.userInputTF.text = self.details.orderTime;
            break;
            
        case 3:
            cell.leftTitle = @"订单号　　";
            cell.userInputTF.text = self.details.prdOrdNo;
            if (!self.details.payOrdNo && self.isPay) {
                    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
                    self.nextBtn.width   = SCREENWIDTH * 0.9;
                    self.nextBtn.height  = rect.size.height;
                    self.nextBtn.centerX = SCREENWIDTH * 0.5;
                    self.nextBtn.y       = CGRectGetMaxY(rect) + rect.size.height;
                    [self.nextBtn setTitle:@"确认支付" forState:UIControlStateNormal];
            }
            break;
        case 4:
            cell.leftTitle = @"支付流水号";
            cell.userInputTF.text = self.details.payOrdNo;
            break;
        default:
            break;
    }
    return cell;
}

-(void)nextBtnClick
{
    [MBProgressHUD show];
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithScanCreatOrderParameters:self.details.prdOrdNo merNo:self.details.merNo success:^(YMScanModel *model, NSInteger resCode, NSString *resMsg) {
        [MBProgressHUD hideHUD];
        
        if (resCode == 1) {
            if (![model getCanPayCard] && ![model getCanAcbalUse]) {
                [YMPublicHUD showAlertView:nil message:@"请充值余额后再支付" cancelTitle:@"确定" handler:nil];
            }
            model.prdOrdNo             = weakSelf.details.prdOrdNo;
            weakSelf.payTool.dataModel = model;
            [weakSelf.payTool showCashierDeskView];
          
        } else {
            [MBProgressHUD showText:resMsg];
        }
    }];
}

@end
