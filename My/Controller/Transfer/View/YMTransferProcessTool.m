//
//  YMTransferProcessTool.m
//  WSYMPay
//
//  Created by pzj on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferProcessTool.h"
#import "YMGetUserInputCell.h"
#import "YMTransferProcessHeaderView.h"
#import "YMRedBackgroundButton.h"
#import "YMTransferCheckPayPwdDataModel.h"

@interface YMTransferProcessTool ()

@property (nonatomic, strong) YMTransferProcessHeaderView *headView;
@property (nonatomic, strong) YMRedBackgroundButton *checkDetailBtn;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, copy) NSString *tipsStr;

@end

@implementation YMTransferProcessTool
- (void)selectCheckDetailBtn{}
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
    CGFloat y = CGRectGetMaxY(rect) + (SCREENWIDTH * 0.07);
    self.checkDetailBtn.frame = CGRectMake(x, y, w, h);
}

#pragma mark - eventResponse                - Method -
- (void) checkDetailBtnClick
{//查看账单详情
    if ([self.delegate respondsToSelector:@selector(selectCheckDetailBtn)]) {
        [self.delegate selectCheckDetailBtn];
    }
}

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"YMGetUserInputCell";
    YMGetUserInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[YMGetUserInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    [cell sendTransferProcessWithRowNum:indexPath.row model:self.dataModel];
    
    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    [self setSureButtonFrame:rect];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREENWIDTH * ROWProportion);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - getters and setters          - Method -
- (YMTransferProcessHeaderView *)headView
{
    if (!_headView) {
        _headView = [[YMTransferProcessHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130)];
    }
    return _headView;
}
- (YMRedBackgroundButton *)checkDetailBtn
{
    if (!_checkDetailBtn) { //查看账单详情按钮
        _checkDetailBtn = [[YMRedBackgroundButton alloc]init];
        _checkDetailBtn.enabled = NO;
        [_checkDetailBtn setTitle:@"查看账单详情" forState:UIControlStateNormal];
        [_checkDetailBtn addTarget:self action:@selector(checkDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:_checkDetailBtn];
        _checkDetailBtn.enabled = YES;
    }
    return _checkDetailBtn;
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
                make.top.mas_equalTo(self.checkDetailBtn.mas_bottom).offset(10);
                make.width.mas_equalTo(size.width);
                make.height.mas_equalTo(size.height);
                make.centerX.equalTo(self.tableView.mas_centerX);
            }];
        }
    }
    return _tipsLabel;
}

- (void)setDataModel:(YMTransferCheckPayPwdDataModel *)dataModel
{
    _dataModel = dataModel;
    [self headView].model = _dataModel;
    self.tipsStr = @"如信息填写有误,资金将原路退回";
    [self tipsLabel];
    [self.tableView reloadData];
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    _tableView.tableHeaderView = [self headView];
}
@end
