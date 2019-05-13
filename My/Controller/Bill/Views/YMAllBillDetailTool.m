//
//  YMAllBillDetailTool.m
//  WSYMPay
//
//  Created by pzj on 2017/7/20.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillDetailTool.h"
#import "YMAllBillDetailHeadView.h"
#import "YMAllBillDetailCell.h"
#import "YMAllBillDetailFootView.h"
#import "YMAllBillDetailDataModel.h"

@interface YMAllBillDetailTool ()<YMAllBillDetailFootViewDelegate>
@property (nonatomic, strong) YMAllBillDetailHeadView *headView;
@property (nonatomic, strong) YMAllBillDetailFootView *footView;

@end

@implementation YMAllBillDetailTool
- (void)selectComplaintsMethod{}
#pragma mark - lifeCycle                    - Method -
- (instancetype)initWithTableView
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - privateMethods               - Method -
- (NSInteger )getItemCount:(NSInteger)section
{
    if (self.billDetailType == BillDetailConsumeMobilePhoneRecharge) {//消费---手机话费充值
        if (section == 0) {
            return 5;
        }else if (section == 1){
            return 3;
        }else{
            if ([[self.detailDataModel getAcceptStateCodeStr] isEqualToString:@"0"]){//未投诉
                return 0;
            }else{
                return 3;
            }
        }
    }else if (self.billDetailType == BillDetailAccountTransfer){//转账(我要收款/ 扫一扫有名收款码)
        if (section == 0) {
            return 3;
        }else if (section == 1){
            return 2;
        }else{
            if ([[self.detailDataModel getAcceptStateCodeStr] isEqualToString:@"0"]){//未投诉
                return 0;
            }else{
                return 3;
            }
        }
    }else if(self.billDetailType == BillDetailConsumeScan ){//消费---扫一扫超级收款码/扫一扫pc端生成的二维码/TX
        
        if (section == 0) {
            return 2;
        }else if (section == 1){
            return 3;
        }else{
            if ([[self.detailDataModel getAcceptStateCodeStr] isEqualToString:@"0"]){//未投诉
                return 0;
            }else{
                return 3;
            }
        }
    }else if (self.billDetailType == BillDetailAccountRecharge){//账户充值
        
        if (section == 0) {
            return 5;
        }else if (section == 1){
            return 0;
        }else{
            if ([[self.detailDataModel getAcceptStateCodeStr] isEqualToString:@"0"]){//未投诉
                return 0;
            }else{
                return 3;
            }
        }
        
    }else{//账户提现
        
        if (section == 0) {
            return 6;//提现失败时3
        }else if (section == 1){
            return 0;
        }else{
            if ([[self.detailDataModel getAcceptStateCodeStr] isEqualToString:@"0"]){//未投诉
                return 0;
            }else{
                return 3;
            }
        }
        
    }
}

#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void)selectComplaintsBtnMethod
{
    
    YMLog(@"订单投诉相关按钮。。。");
    if ([self.delegate respondsToSelector:@selector(selectComplaintsMethod)]) {
        [self.delegate selectComplaintsMethod];
    }
}
#pragma mark - objective-cDelegate          - Method -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    if ([[self.detailDataModel getAcceptStateCodeStr] isEqualToString:@"0"]) {//未投诉
//        return 2;
//    }
//    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self getItemCount:section];
    
    if ([self.tranType isEqualToString:@"5"]) {
        return section == 0 ? 6 : 1;
    }
    return section == 0 ? 5 : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"YMAllBillDetailCell";
    YMAllBillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[YMAllBillDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row == 0 || indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.tranType = self.tranType;
    [cell sendBillDetailType:self.billDetailType section:indexPath.section row:indexPath.row model:self.detailDataModel];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
    bgView.backgroundColor = [UIColor whiteColor];
    return bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 75;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
    bgView.backgroundColor = UIColorFromHex(0xf5f4f9);
    return bgView;
}

#pragma mark - getters and setters          - Method -

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
}
- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    self.headView = [YMAllBillDetailHeadView instanceView];
    self.headView.frame = CGRectMake(0, 0, SCREENWIDTH, 142);
    _tableView.tableHeaderView = self.headView;
}
- (void)setBillDetailType:(BillDetailType)billDetailType
{
    _billDetailType = billDetailType;
}

- (void)setDetailDataModel:(YMAllBillDetailDataModel *)detailDataModel
{
    _detailDataModel = detailDataModel;
    if (_detailDataModel == nil) {
        return;
    }
    [self.headView sendBillDetailType:self.billDetailType model:_detailDataModel];
    [self.headView sendBillDetailTranType:self.tranType model:_detailDataModel];    // 充值
    
    self.footView = [YMAllBillDetailFootView instanceView];
    self.footView.delegate = self;
    self.tableView.tableFooterView = self.footView;
    [self.footView sendBillDetailType:self.billDetailType model:_detailDataModel];
    [self.tableView reloadData];
}

@end
