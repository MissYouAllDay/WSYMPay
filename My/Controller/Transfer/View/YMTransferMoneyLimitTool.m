//
//  YMTransferMoneyLimitTool.m
//  WSYMPay
//
//  Created by pzj on 2017/5/3.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferMoneyLimitTool.h"
#import "YMTransferMoneyLimitCell.h"
#import "YMTransferRecentRecodeDataListModel.h"

@implementation YMTransferMoneyLimitTool

#pragma mark - lifeCycle                    - Method -
- (instancetype)initWithTableView
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - privateMethods               - Method -

#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"YMTransferMoneyLimitCell";
    YMTransferMoneyLimitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[YMTransferMoneyLimitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (self.dataArray.count>0) {
        YMTransferRecentRecodeDataListModel *listModel = self.dataArray[indexPath.row];
        cell.listModel = listModel;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
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
}
@end
