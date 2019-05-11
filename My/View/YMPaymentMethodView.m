//
//  YMPaymentMethodView.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/16.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPaymentMethodView.h"
#import "YMPayBankCardCell.h"
#import "YMPaymentBalanceCell.h"
#import "YMPaymentBankCell.h"
#import "YMUserInfoTool.h"
#import "YMScanModel.h"
#import "YMBankCardModel.h"
@interface YMPaymentMethodView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIView   *contentView;

@property (nonatomic, weak) UIButton *quitButton;

@property (nonatomic, weak) UILabel  *mainItemLabel;

@property (nonatomic, weak) UIView   *lineView;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) BOOL balanceSelected;

@property (nonatomic, strong) NSArray  *bankCardArray;
@property (nonatomic, strong) NSArray  *prepaidCardArray;
@property (nonatomic, copy)   NSString *balance;

@end

@implementation YMPaymentMethodView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
        self.balance = @"9999.1";
    }
    return self;
}
#pragma mark - privateMethods               - Method -
-(void)setupSubviews
{
    
    self.backgroundColor = RGBAlphaColor(0, 0, 0, 0.5);
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UIButton *quitButton = [[UIButton alloc]init];
    [quitButton setImage:[UIImage imageNamed:@"quit"] forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:quitButton];
    self.quitButton = quitButton;
    
    UILabel *mainItemLabel  = [[UILabel alloc]init];
    mainItemLabel.font          = COMMON_FONT;
    mainItemLabel.textColor     = FONTDARKCOLOR;
    mainItemLabel.text          = @"选择支付方式";
    mainItemLabel.textAlignment = NSTextAlignmentCenter;
    [mainItemLabel sizeToFit];
    [contentView addSubview:mainItemLabel];
    self.mainItemLabel = mainItemLabel;
    
    UIView *lineView         = [[UIView alloc]init];
    lineView.backgroundColor = LAYERCOLOR;
    [contentView addSubview:lineView];
    self.lineView = lineView;
    
    UITableView *tableView    = [[UITableView alloc]init];
    tableView.delegate        = self;
    tableView.dataSource      = self;
    tableView.tableFooterView = [[UIView alloc]init];
    [contentView addSubview:tableView];
    self.tableView = tableView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(SCREENHEIGHT * 0.3 + 216);
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
    }];
    
    CGFloat H = SCREENWIDTH*ROWProportion;
    CGFloat interVal = (H - self.mainItemLabel.bounds.size.height) / 2;
    
    [self.mainItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(interVal);
    }];
    
    [self.quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(H);
        make.height.mas_equalTo(H);
        make.centerY.equalTo(self.mainItemLabel.mas_centerY);
        make.left.equalTo(self.contentView.mas_left);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView.mas_width);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.mainItemLabel.mas_bottom).offset(interVal);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView.mas_width);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

-(void)show
{   [self.tableView reloadData];
    self.frame = KEYWINDOW.bounds;
    [KEYWINDOW addSubview:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)getNumberOfRowsInSection:(NSInteger)section
{
    if ([self balanceAvailable]) {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return self.bankCardArray.count;
                break;
            case 2:
                return self.prepaidCardArray.count;
                break;
            default:
                return 1;
                break;
        }
    } else {
        switch (section) {
            case 0:
                return  self.bankCardArray.count;
                break;
            case 1:
                return  self.prepaidCardArray.count;
                break;
            default:
                return 1;
                break;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self getNumberOfRowsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 3) {
       static NSString *ID = @"otherCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.textLabel.text      = @"使用其他银行卡";
            cell.textLabel.textColor = FONTDARKCOLOR;
            cell.textLabel.font      = [UIFont systemFontOfMutableSize:16];
            cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        }
        return cell;
    } else {
        
        if ([self balanceAvailable]) {
            switch (indexPath.section) {
                case 0:
                {
                    YMPaymentBalanceCell *cell = [YMPaymentBalanceCell configCell:tableView withMoney:[YMUserInfoTool shareInstance].cashAcBal];
                    cell.isSelected = _balanceSelected;
                    cell.enabled = YES;
                    return cell;
                    break;
                }
                case 1:
                {
                    YMPaymentBankCell *cell = [YMPaymentBankCell configCell:tableView withBankModel:self.bankCardArray[indexPath.row]];
                    
                    return cell;
                    break;
                }
                default:
                {
                    YMPaymentBankCell *cell = [YMPaymentBankCell configCell:tableView withBankModel:nil];
                    return cell;
                    break;
                }
            }
        } else {
            switch (indexPath.section) {
                case 0:
                {
                    YMPaymentBankCell *cell = [YMPaymentBankCell configCell:tableView withBankModel:self.bankCardArray[indexPath.row]];
                    return cell;
                    break;
                }
                case 1:
                {
                    YMPaymentBankCell *cell = [YMPaymentBankCell configCell:tableView withBankModel:nil];
                    return cell;
                    break;
                }
                default:
                {
                    YMPaymentBalanceCell *cell = [YMPaymentBalanceCell configCell:tableView withMoney:[YMUserInfoTool shareInstance].cashAcBal];
                    cell.isSelected = _balanceSelected;
                    cell.enabled = NO;
                    return cell;
                    break;
                }
            }

        }
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.contentView.bounds.size.height * 0.21;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        if ([self.delegate respondsToSelector:@selector(paymentMethodViewWithAddBankCard:)]) {
            [self.delegate paymentMethodViewWithAddBankCard:self];
        }

    } else {
        
        if ([self balanceAvailable]) {
            switch (indexPath.section) {
                case 0:
                   {
                    //选择余额
                    if (_balanceSelected) {
                        return;
                        
                        } else {
                        _balanceSelected = YES;
                        for (YMBankCardModel *m in self.bankCardArray) {
//                            m.selected = NO;
                        }
                    }
                    
                    if ([self.delegate respondsToSelector:@selector(paymentMethodView:withBalance:)]) {
                        [self.delegate paymentMethodView:self withBalance:@"余额"];
                    }
                    [self removeFromSuperview];
                 break;
                }
                case 1:
                   {
                    //选择银行卡
                    YMBankCardModel *m = self.bankCardArray[indexPath.row];
                    if (m.isFlag)  return;
                    _balanceSelected = NO;
                    for (YMBankCardModel *m in self.bankCardArray) {
//                        m.selected = NO;
                    }
            
//                    m.selected = YES;
                    if ([self.delegate respondsToSelector:@selector(paymentMethodView:withBankCard:)]) {
                        [self.delegate paymentMethodView:self withBankCard:m];
                    }
                    [self removeFromSuperview];
                 break;
                   }
                default:
                    break;
                }
            
        } else {
            switch (indexPath.section) {
                case 0:
                {
                    //选择银行卡
                    YMBankCardModel *m = self.bankCardArray[indexPath.row];
                    if (m.isFlag)  return;
                    //银行卡被选中
                    for (YMBankCardModel *m in self.bankCardArray) {
//                        m.selected = NO;
                    }
//                    m.selected = YES;
                    if ([self.delegate respondsToSelector:@selector(paymentMethodView:withBankCard:)]) {
                        [self.delegate paymentMethodView:self withBankCard:m];
                    }
                    [self removeFromSuperview];
                    break;
                }
                case 1:
                    break;
                default:
                    break;
            }
        }
    }
}

-(void)quitButtonClick
{
    [self removeFromSuperview];
}

-(BOOL)balanceAvailable
{
    
    return  [self.scanModel.acbalUse isString:@"1"];
}

-(void)setScanModel:(YMScanModel *)scanModel
{
    _scanModel = scanModel;
    
    self.bankCardArray = _scanModel.list;
    switch ([_scanModel.useType integerValue]) {
        case 0:
            _balanceSelected = YES;
            for (YMBankCardModel *m in self.bankCardArray) {
//                m.selected = NO;
            }
            break;
        case 1:
            _balanceSelected = NO;
            break;
        default:
            _balanceSelected = NO;
            for (YMBankCardModel *m in self.bankCardArray) {
//                m.selected = NO;
            }
            break;
    }
}

@end
