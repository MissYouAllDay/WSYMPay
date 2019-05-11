//
//  YMTransferMoneyTool.m
//  WSYMPay
//
//  Created by pzj on 2017/5/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferMoneyTool.h"
#import "YMRedBackgroundButton.h"
#import "YMTransferMoneyHeaderView.h"
#import "YMTransferMoneyCell.h"
#import "YMTransferCheckAccountDataModel.h"

static NSString* const HTML=@"<font color='#404040'>使用%@付款，</font><font color='#E2483C'>更换</font>";

@interface YMTransferMoneyTool ()<YMTransferMoneyCellDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) YMRedBackgroundButton *sureBtn;
@property (nonatomic, strong) YMTransferMoneyHeaderView *headView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, copy) NSString *moneyStr;
@property (nonatomic, copy) NSString *beiZhuStr;
@property (nonatomic, copy) NSString *tipsStr;
@property (nonatomic, strong) UIButton *selectPayTypeBtn;

@end

@implementation YMTransferMoneyTool

- (void)selectSureTransferBtnWithMoney:(NSString *)money beiZhuMsg:(NSString *)beiZhuMsg{}
- (void)selectPayTypeBtnWithMoneyStr:(NSString *)money{}

#pragma mark - lifeCycle                    - Method -
- (instancetype)initWithTableView
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - privateMethods               - Method -
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
{
    [self.vc.view endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(selectSureTransferBtnWithMoney:beiZhuMsg:)])
    {
        [self.delegate selectSureTransferBtnWithMoney:self.moneyStr beiZhuMsg:self.beiZhuStr];
    }
}
- (void)selectPayTypeBtnClick
{
    YMLog(@"更换支付方式。。。");
    if ([self.delegate respondsToSelector:@selector(selectPayTypeBtnWithMoneyStr:)]) {
        [self.delegate selectPayTypeBtnWithMoneyStr:self.moneyStr];
    }
}

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void)textFieldBeginEditing
{
    YMLog(@"begin editing 。。。 ");
}
- (void)textFieldWithMoney:(NSString *)money
{
    self.moneyStr = money.length>0?money:@"0";
    self.sureBtn.enabled = money.length>0?YES:NO;
}
- (void)textFieldWithBeiZhu:(NSString *)beiZhu
{
    self.beiZhuStr = beiZhu;
}

#pragma mark - objective-cDelegate          - Method -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"YMTransferMoneyCell";
    YMTransferMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[YMTransferMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate = self;
    cell.moneyTextField.text = self.scanMoney;
    if ([self.scanMoney isEqualToString:@""] || self.scanMoney.length == 0 || [self.scanMoney isEqualToString:@""] || self.scanMoney == nil || self.scanMoney == NULL || [self.scanMoney isEqual:[NSNull null]])
    {
        cell.moneyTextField.enabled = YES;

    }else{
        
        cell.moneyTextField.enabled = NO;
    }
    self.sureBtn.enabled = self.scanMoney.length>0?YES:NO;
    
    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    [self setSureButtonFrame:rect];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

#pragma mark - getters and setters          - Method -
- (YMRedBackgroundButton *)sureBtn
{
    if (!_sureBtn) { //下一步按钮
        _sureBtn = [[YMRedBackgroundButton alloc]init];
        _sureBtn.enabled = NO;
        [_sureBtn setTitle:@"确认转账" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:_sureBtn];
    }
    return _sureBtn;
}

- (YMTransferMoneyHeaderView *)headView
{
    if (!_headView) {
        _headView = [[YMTransferMoneyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130)];
    }
    return _headView;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont systemFontOfMutableSize:12];
        _tipsLabel.textColor = FONTCOLOR;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.userInteractionEnabled = YES;
        [self.tableView addSubview:_tipsLabel];

        NSString *htmlStr = [NSString stringWithFormat:HTML,@"余额"];
        _tipsLabel.attributedText = [htmlStr getHtmlStr];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        
        CGFloat interval = SCREENHEIGHT * 0.04;
        [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sureBtn.mas_bottom).offset(interval * 0.5);
            make.left.mas_equalTo(LEFTSPACE);
            make.right.mas_equalTo(-LEFTSPACE);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(self.tableView.mas_centerX);
        }];
        
        [_tipsLabel addSubview:self.selectPayTypeBtn];
        [self.selectPayTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _tipsLabel;
}

- (UIButton *)selectPayTypeBtn
{
    if (!_selectPayTypeBtn) {
        _selectPayTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectPayTypeBtn addTarget:self action:@selector(selectPayTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectPayTypeBtn;
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    [self sureBtn];
    [self tipsLabel];
    _tableView.tableHeaderView = [self headView];
}

- (void)setDataModel:(YMTransferCheckAccountDataModel *)dataModel
{
    _dataModel = dataModel;
    if (_dataModel == nil) {
        return;
    }
    [self headView].model = _dataModel;
    self.tipsStr = [_dataModel getAccountMsgStr];
    [self.tableView reloadData];
}
- (void)setVc:(UITableViewController *)vc
{
    _vc = vc;
}
- (void)setPayTypeStr:(NSString *)payTypeStr
{
    _payTypeStr = payTypeStr;
    if ([_payTypeStr isEqualToString:@"余额支付"]) {
        _payTypeStr = @"账户余额";
    }
    NSString *htmlStr = [NSString stringWithFormat:HTML,_payTypeStr];
    self.tipsLabel.attributedText = [htmlStr getHtmlStr];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView reloadData];
}
@end
