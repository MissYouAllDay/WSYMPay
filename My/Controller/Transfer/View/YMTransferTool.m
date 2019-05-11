//
//  YMTransferTool.m
//  WSYMPay
//
//  Created by pzj on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferTool.h"
#import "YMTransferLocalCell.h"
#import "YMTransferRecentlyCell.h"
#import "YMTransferRecentRecodeDataListModel.h"

static NSString* const TYPE_LOCAL=@"YMTransferLocalCell";//section 0 本地固定
static NSString* const TYPE_RECENTLY=@"YMTransferRecentlyCell";//section 1 最近转账

@interface YMTransferTool ()

@end

@implementation YMTransferTool
- (void)selectLocalMethod:(NSInteger)row{}
- (void)selectRecentlyMethod:(id)model{}
#pragma mark - lifeCycle                    - Method -
- (instancetype)initWithTableView
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - privateMethods               - Method -
- (NSString *)getViewType:(NSInteger)section row:(NSInteger)row
{
    if (section == 0) {
        return TYPE_LOCAL;
    }else{
        return TYPE_RECENTLY;
    }
}
- (NSInteger)getItemCount:(NSInteger)section
{
    NSString *viewType = [self getViewType:section row:0];
    if (viewType == TYPE_LOCAL) {
        return 1;//app4期去掉转账到银行卡
    }else{
        return self.dataArray.count;
    }
}

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getItemCount:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *viewType = [self getViewType:indexPath.section row:indexPath.row];
    if (viewType == TYPE_LOCAL) {
        
        YMTransferLocalCell *cell = [tableView dequeueReusableCellWithIdentifier:TYPE_LOCAL];
        if (cell == nil) {
            cell = [[YMTransferLocalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TYPE_LOCAL];
        }
        cell.indexPathRow = indexPath.row;        
        return cell;
        
    }else{
        
        YMTransferRecentlyCell *cell = [tableView dequeueReusableCellWithIdentifier:TYPE_RECENTLY];
        if (cell == nil) {
            cell = [[YMTransferRecentlyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TYPE_RECENTLY];
        }
        if ([self dataArray].count>0) {
            YMTransferRecentRecodeDataListModel *listModel = [self dataArray][indexPath.row];
            cell.model = listModel;
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *viewType = [self getViewType:section row:0];
    if (viewType == TYPE_RECENTLY) {
        UIView * headView = [[UIView alloc]init];
        headView.backgroundColor = VIEWGRAYCOLOR;
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:[VUtilsTool fontWithString:12.0]];
        label.textColor = FONTCOLOR;
        label.text = @"最近";
        [headView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, LEFTSPACE, 0, RIGHTSPACE));
        }];
        return headView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *viewType = [self getViewType:section row:0];
    return viewType == TYPE_RECENTLY?(self.dataArray.count>0?30:0.1f):0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *viewType = [self getViewType:indexPath.section row:indexPath.row];
    if (viewType == TYPE_LOCAL) {//0--转到有名钱包账户,1--转到银行卡
        if ([self.delegate respondsToSelector:@selector(selectLocalMethod:)]) {
            [self.delegate selectLocalMethod:indexPath.row];
        }
    }else if (viewType == TYPE_RECENTLY){//最近转账用户
        if ([self.delegate respondsToSelector:@selector(selectRecentlyMethod:)]) {
            if ([self dataArray].count>0) {
                YMTransferRecentRecodeDataListModel *listModel = [self dataArray][indexPath.row];
                [self.delegate selectRecentlyMethod:listModel];
            }
        }
    }
}

#pragma mark - getters and setters          - Method -
- (void)setDataArray:(NSMutableArray *)dataArray
{
    [_dataArray removeAllObjects];
    _dataArray = dataArray;
    [self.tableView reloadData];
}

@end
