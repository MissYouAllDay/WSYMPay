//
//  YMExpenditureDetailsController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/9.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMExpenditureDetailsController.h"
#import "YMMoneyView.h"
#import "YMGetUserInputCell.h"
#import "YMBillDetailsModel.h"
#import "YMMyHttpRequestApi.h"
#import "YMBillDetailResultModel.h"
#import "YMBillDetailKeyValueModel.h"
//2019-5-11  账单详情 cell
#import "CXDetailsTableViewCell.h"


@interface YMExpenditureDetailsController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) YMBillDetailResultModel *billDetailModel;

@end

@implementation YMExpenditureDetailsController

#pragma mark - lifeCycle                    - Method -
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self loadData];
}

#pragma mark - privateMethods               - Method -
- (void)setupSubviews
{
    [self moneyView].alpha = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    if (self.billDetails.tranType == 3) {
//    }else{
//        self.tableView.tableHeaderView = [self moneyView];

//    }
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.navigationItem.title = @"账单详情";
}
- (void)loadData
{
    [self loadCashDetailData];
    
//    /*
//     * 判断是充值、提现、预付卡充值
//     * (tranType 1转账2充值3提现4预付费卡充值)
//     * 此版暂时只规划：账户充值和提现、预付卡充值
//     */
//    switch (self.billDetails.tranType) {
//        case 2:
//        {
//            [self loadReChargeDetailData];
//        }
//            break;
//        case 3:
//        {
//            [self loadCashDetailData];
//        }
//            break;
//        case 4:
//        {
//            [self loadPrepaidCardDetailData];
//        }
//            break;
//        default:
//            break;
//    }
}

/**
 充值详情查询
 */
- (void)loadReChargeDetailData
{
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithReChargeDetailsModel:self.billDetails Success:^(YMBillDetailResultModel *model) {
        STRONG_SELF;
        strongSelf.billDetailModel = model;
        strongSelf.dataArray = [model getDataArray];
        [strongSelf getTableViewHeader];
        [strongSelf.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

/**
 提现详情查询
 */
- (void)loadCashDetailData
{
    
    NSArray * namearray =@[
  @{@"name":@"交易类型",@"name1":self.billDetails.prdName},
  @{@"name":@"交易时间",@"name1": self.billDetails.orderDate},
  @{@"name":@"交易状态",@"name1":self.billDetails.getOrdStatusNameStr},
  @{@"name":@"交易型号",@"name1":self.billDetails.prdOrdNo}];

    
    _dataArray = [[NSMutableArray alloc]initWithArray:namearray];
}

/**
 预付卡充值查询
 */
- (void)loadPrepaidCardDetailData
{
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithPrepaidCardDetailModel:self.billDetails Success:^(YMBillDetailResultModel *model) {
        STRONG_SELF;
        strongSelf.billDetailModel = model;
        strongSelf.dataArray = [model getPrepaidDataArray];
        [strongSelf getTableViewHeader];
        [strongSelf.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

/**
 header view 加载数据
 */
- (void)getTableViewHeader
{
    if (self.dataArray.count>0) {
        [self moneyView].alpha = 1;
    }else{
        [self moneyView].alpha = 0;
    }
    [self moneyView].money = [self.billDetailModel getTxAmtStr];
    [self moneyView].mainTtitle = [self.billDetailModel getHeadTitleStr];
}
#pragma mark - objective-cDelegate          - Method -（Table view data source）

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    if (self.billDetails.tranType == 3) {
        return 4;
//    }else{
//
//    return [self dataArray].count;
//    }
    
}
//返回组头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
//    if (self.billDetails.tranType == 3) {
        return 100;
//    }else{
//        return 0.01;
//
//    }
    
}
//返回组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
    UIView  *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,100)];
//    if (self.billDetails.tranType == 3) {
        headerView.frame = CGRectMake(0, 0, tableView.frame.size.width, 100);
        
        UILabel *namela= [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 30)];
        [headerView addSubview:namela];
        namela.textColor = FONTCOLOR;
        namela.font = [UIFont systemFontOfSize:14];
        namela.text = self.billDetails.ordStatusName;
        namela.textAlignment =1;

        
         UILabel * nametwola = [[UILabel alloc]initWithFrame:CGRectMake(0, namela.bottom+10, SCREENWIDTH, 30)];
        [headerView addSubview:nametwola];
        nametwola.textColor = FONTCOLOR;
        nametwola.font = [UIFont systemFontOfSize:15];
        nametwola.text = self.billDetails.getTxAmtStr;
        nametwola.textAlignment =1;
        
        
//    }else{
//
//        headerView.frame = CGRectMake(0, 0, tableView.frame.size.width, 0.01);
//
//    }
    
    
    return  headerView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREENWIDTH * ROWProportion) ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellID";
    CXDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CXDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    NSDictionary *namedic= _dataArray[indexPath.row];
    
    cell.namela.text = namedic[@"name"];
    cell.nametwola.text = namedic[@"name1"];
    
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellId = @"cellID";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.textColor = FONTCOLOR;
//    cell.textLabel.font = [UIFont systemFontOfMutableSize:13];
//    cell.detailTextLabel.textColor = FONTCOLOR;
//    cell.detailTextLabel.font = [UIFont systemFontOfMutableSize:13];
//
//    if ([self dataArray].count>0) {
//        YMBillDetailKeyValueModel *keyValueModel = [self dataArray][indexPath.row];
//        cell.textLabel.text = keyValueModel.keyStr;
//        cell.detailTextLabel.text = keyValueModel.valueStr;
//    }
//
//    return cell;
//}
//-(YMGetUserInputCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    NSString *ID = @"cell";
//    YMGetUserInputCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[YMGetUserInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//        cell.userInputTF.enabled   = NO;
//        cell.userInputTF.textColor = FONTDARKCOLOR;
//        cell.userInputTF.font      = COMMON_FONT;
//    }
//
//    if ([self dataArray].count>0) {
//        YMBillDetailKeyValueModel *keyValueModel = [self dataArray][indexPath.row];
//        cell.keyOrValueModel = keyValueModel;
//    }
//    return cell;
//}

#pragma mark - getters and setters          - Method -
- (void)setBillDetails:(YMBillDetailsModel *)billDetails
{
    _billDetails = billDetails;
    if (_billDetails == nil) {
        return;
    }
    [self.tableView reloadData];
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
