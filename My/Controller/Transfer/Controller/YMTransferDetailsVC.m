//
//  YMOrderDetailVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferDetailsVC.h"
#import "YMMoneyView.h"
#import "YMGetUserInputCell.h"
#import "YMMyHttpRequestApi.h"
#import "YMTransferDetailsModel.h"
@interface YMTransferDetailsVC ()
@property (nonatomic, assign) BOOL isLoad;
@property (nonatomic, strong) YMTransferDetailsModel *orderDetails;
@end

@implementation YMTransferDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.moneyView.hidden = YES;
    self.navigationItem.title = @"账单详情";
    [self loadData];
}

-(void)loadData
{
    WEAK_SELF;
//    [YMHTTPRequestTool shareInstance] POST:<#(NSString *)#> parameters:<#(id)#> success:<#^(id responseObject)success#> failure:<#^(NSError *error)failure#>
//    
    
//    [YMMyHttpRequestApi loadHttpRequestWithBillDetails:self.orderNo success:^(YMTransferDetailsModel *m) {
//        m.tranType = @"转账";
//        weakSelf.orderDetails = m;
//        weakSelf.isLoad = YES;
//        weakSelf.moneyView.mainTtitle = m.toAccName;
//        weakSelf.moneyView.money =m.txAmt;
//        weakSelf.moneyView.bottomTitle = [m getOrdStatus];
//        weakSelf.moneyView.hidden = NO;
//        [weakSelf.tableView reloadData];
//    }];
//    
//    
//    RequestModel *params = [[RequestModel alloc] init];
//    params.orderNo = self.orderNoStr;
//    params.orderTypeSel = self.tranTypeStr;
//    WEAK_SELF;
//    [YMMyHttpRequestApi loadHttpRequestWithBillDetailsParams:params success:^(YMAllBillDetailDataModel *detailDataModel) {
//        STRONG_SELF;
//        strongSelf.tableView.hidden = NO;
//        strongSelf.detailDataModel = detailDataModel;
//        [strongSelf tableViewTool].billDetailType = self.billDetailType;
//        [strongSelf tableViewTool].detailDataModel = strongSelf.detailDataModel;
//        [strongSelf.tableView reloadData];
//    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isLoad) {
        return 1;
    } else {
        return 0;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (YMGetUserInputCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"orderCell";
    YMGetUserInputCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YMGetUserInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.userInputTF.enabled   = NO;
        cell.userInputTF.textColor = FONTDARKCOLOR;
        cell.userInputTF.font      = COMMON_FONT;
    }

    switch (indexPath.row) {
        case 0:
            cell.leftTitle = @"付款方式";
            cell.userInputTF.text = self.orderDetails.paymentMethod;
            break;
        case 1:
            cell.leftTitle = @"转账说明";
            cell.userInputTF.text = self.orderDetails.tratype;
            break;
            
            
        case 2:
            cell.leftTitle = @"对方账户";
            cell.userInputTF.text = self.orderDetails.tragetno;
            break;
            
        case 3:
            cell.leftTitle = @"创建时间";
            cell.userInputTF.text = self.orderDetails.tratime;
            break;
            
        case 4:
            cell.leftTitle = @"交易单号";
            cell.userInputTF.text = self.orderDetails.traordNo;
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

@end
