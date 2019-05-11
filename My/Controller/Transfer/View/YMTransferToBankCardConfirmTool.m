//
//  YMTransferToBankCardConfirmTool.m
//  WSYMPay
//
//  Created by pzj on 2017/5/3.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferToBankCardConfirmTool.h"
#import "YMGetUserInputCell.h"
#import "YMTransferToBankCardBeiZhuCell.h"
#import "YMTransferMoneyHeaderView.h"//header
#import "YMRedBackgroundButton.h"
#import "YMTransferToBankSearchFeeDataModel.h"

static NSString* const TYPE_COLLECTIONMSG=@"YMGetUserInputCell";//收款方信息cell
static NSString* const TYPE_BEIZHU=@"YMTransferToBankCardBeiZhuCell";//备注cell

@interface YMTransferToBankCardConfirmTool ()<YMTransferToBankCardBeiZhuCellDelegate>

@property (nonatomic, strong) YMTransferMoneyHeaderView *headView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, copy) NSString *tipsStr;
@property (nonatomic, strong) YMRedBackgroundButton *sureBtn;
@property (nonatomic, copy) NSString *beiZhuStr;
@property (nonatomic, strong)UIView *lineView;
@end

@implementation YMTransferToBankCardConfirmTool
- (void)selectSureTransferBtnWithbeiZhuMsg:(NSString *)beiZhuMsg{}

#pragma mark - lifeCycle                    - Method -
- (instancetype)initWithTableView
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - privateMethods               - Method -
- (NSString *)getViewType:(NSInteger)section row:(NSInteger)row
{
    return section == 0?TYPE_COLLECTIONMSG:TYPE_BEIZHU;
}

- (NSInteger)getItemCount:(NSInteger)section
{
    NSString *viewType = [self getViewType:section row:0];
    return viewType == TYPE_COLLECTIONMSG?2:1;
}

-(void)setSureButtonFrame:(CGRect)rect
{
    CGFloat w = SCREENWIDTH * 0.9;
    CGFloat h = SCREENWIDTH * ROWProportion;
    CGFloat x = (SCREENWIDTH - w) /2;
    CGFloat y = CGRectGetMaxY(rect) + (SCREENWIDTH * 0.08);
    self.sureBtn.frame = CGRectMake(x, y, w, h);
}

#pragma mark - eventResponse                - Method -
- (void)sureBtnClick
{//确认转账。。。
    if ([self.delegate respondsToSelector:@selector(selectSureTransferBtnWithbeiZhuMsg:)]) {
        [self.delegate selectSureTransferBtnWithbeiZhuMsg:self.beiZhuStr];
    }
}
#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void)textFieldWithBeiZhu:(NSString *)beiZhu
{//备注
    self.beiZhuStr = beiZhu;
}

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
    if (viewType == TYPE_COLLECTIONMSG) {
        YMGetUserInputCell *cell = [tableView dequeueReusableCellWithIdentifier:TYPE_COLLECTIONMSG];
        if (cell == nil) {
            cell = [[YMGetUserInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TYPE_COLLECTIONMSG];
            cell.preservesSuperviewLayoutMargins = NO;
            cell.separatorInset = UIEdgeInsetsZero;
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        [cell addSubview:[self lineView]];
        [[self lineView] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo((SCREENWIDTH * ROWProportion)-0.5);
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        [cell sendTransferWithRowNum:indexPath.row model:self.dataModel];
        return cell;
    }else{
        YMTransferToBankCardBeiZhuCell *cell = [tableView dequeueReusableCellWithIdentifier:TYPE_BEIZHU];
        if (cell == nil) {
            cell = [[YMTransferToBankCardBeiZhuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TYPE_BEIZHU];
        }
        cell.delegate = self;
        CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
        [self setSureButtonFrame:rect];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *viewType = [self getViewType:indexPath.section row:indexPath.row];
    return viewType == TYPE_COLLECTIONMSG?(SCREENWIDTH * ROWProportion):(SCREENWIDTH * 0.1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *viewType = [self getViewType:section row:0];
    return viewType == TYPE_COLLECTIONMSG?0.1f:0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - getters and setters          - Method -
- (YMTransferMoneyHeaderView *)headView
{
    if (!_headView) {
        _headView = [[YMTransferMoneyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130)];
    }
    return _headView;
}

- (YMRedBackgroundButton *)sureBtn
{
    if (!_sureBtn) { //确认转账按钮
        _sureBtn = [[YMRedBackgroundButton alloc]init];
        _sureBtn.enabled = NO;
        [_sureBtn setTitle:@"确认转账" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:_sureBtn];
        _sureBtn.enabled = YES;
    }
    return _sureBtn;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont systemFontOfMutableSize:12];
        _tipsLabel.textColor = FONTCOLOR;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
        _tipsLabel.text = self.tipsStr;
        if (!([_tipsLabel.text isEmptyStr]||_tipsLabel.text == nil)) {
            [UILabel changeLineSpaceForLabel:_tipsLabel WithSpace:7];
            [self.tableView addSubview:_tipsLabel];
            CGSize size = [_tipsLabel sizeThatFits:CGSizeMake(SCREENWIDTH * 0.85, MAXFLOAT)];
            [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.sureBtn.mas_bottom).offset(10);
                make.width.mas_equalTo(size.width);
                make.height.mas_equalTo(size.height);
                make.centerX.equalTo(self.tableView.mas_centerX);
            }];
        }
    }
    return _tipsLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = lINECOLOR;
    }
    return _lineView;
}
- (void)setDataModel:(YMTransferToBankSearchFeeDataModel *)dataModel
{
    _dataModel = dataModel;
    if (_dataModel == nil) {
        return;
    }
    self.tipsStr = @"2小时到账\n到账后，有名钱包将及时通知您到账信息";
    [self tipsLabel];
    [self headView].toBankModel = _dataModel;
    [self.tableView reloadData];
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    _tableView.tableHeaderView = [self headView];
    [self sureBtn];
}
@end
