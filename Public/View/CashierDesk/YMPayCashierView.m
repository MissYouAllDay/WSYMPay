//
//  YMPayCashierView.m
//  WSYMPay
//
//  Created by pzj on 2017/5/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPayCashierView.h"
#import "YMPayCashierTopView.h"
#import "YMPayCashierDescCell.h"
#import "YMPayCashierTypeCell.h"
#import "YMRedBackgroundButton.h"

#import "YMBankCardDataModel.h"
#import "YMBankCardModel.h"

#import "LKDBHelper.h"
#import "YMVerifyBankCardDataModel.h"
#import "YMVerifyBankCardViewController.h"

////验证输入支付密码相关
//#import "YMVerificationPaywordBoxView.h"
//支付方式相关
#import "YMPayCardListView.h"


@interface YMPayCashierView ()<UITableViewDelegate,UITableViewDataSource,YMPayCashierTopViewDelegate>
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YMPayCashierTopView *topView;
@property (nonatomic, strong) YMRedBackgroundButton *sureBtn;

@property (nonatomic, strong) YMBankCardModel *payTypeModel;//选择的支付方式model
@property (nonatomic, strong) YMBankCardDataModel *bankCardDataModel;//dataModel
@property (nonatomic, strong) NSMutableArray *bankListArray;//银行卡列表model array

@property (nonatomic, copy) NSString *moneyStr;//支付的金额
@property (nonatomic, copy) NSString *payTypeStr;//选择的支付方式名称
@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) LKDBHelper *listDB;
@end

@implementation YMPayCashierView
static YMPayCashierView * s = nil;
#pragma mark - lifeCycle                    - Method -
+(YMPayCashierView *)getPayCashierView{
    s = [[self alloc] init];
    [s show];
    s.payCashierType = 0;
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [s initDB];
    });
    return s;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.boxView.x = 0;
    self.boxView.width = SCREENWIDTH;
    self.boxView.height = SCREENHEIGHT * 0.3 + 216;
    self.boxView.y = SCREENHEIGHT - self.boxView.height;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.height);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-(SCREENWIDTH*ROWProportion+20));
    }];
    [self.tableView reloadData];
    
    CGFloat w = SCREENWIDTH * 0.9;
    CGFloat x = (SCREENWIDTH - w) /2;
    CGFloat h = SCREENWIDTH * ROWProportion;
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.boxView.height-(SCREENWIDTH*ROWProportion)-20);
        make.left.mas_equalTo(x);
        make.width.mas_equalTo(w);
        make.height.mas_equalTo(h);
    }];
}
#pragma mark - privateMethods               - Method -
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}
- (void)initViews
{
    self.backgroundColor = RGBAlphaColor(13, 13, 13, 0.5);
    self.layer.masksToBounds = YES;
    
    self.boxView = [[UIView alloc] init];
    self.boxView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.boxView];
    
    [self.boxView addSubview:[self topView]];
    [self.boxView addSubview:[self tableView]];
    [self.boxView addSubview:[self sureBtn]];
}
- (void)show
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show];
        });
    }
    self.frame = KEYWINDOW.bounds;
    [KEYWINDOW addSubview:self];
}
- (void)remove
{
    [self removeFromSuperview];
}
#pragma mark - //调起选择支付方式view
//调起选择支付方式view
- (void)selectPayType{
    
    self.backgroundColor = [UIColor clearColor];
    
    YMPayCardListView *payCardListView = [YMPayCardListView getPayCardListView];
    payCardListView.payCashierView = self;
    WEAK_SELF;
    [payCardListView showPayTypeViewWtihCurrentVC:self.vc withBankCardDataModel:self.bankCardDataModel bankCardArray:self.bankListArray payTypeModel:self.payTypeModel isShowBalance:YES resultBlock:^(YMBankCardModel *payTypeModel, NSString *payTypeStr) {
        STRONG_SELF;
        strongSelf.backgroundColor = RGBAlphaColor(13, 13, 13, 0.5);
        strongSelf.payTypeStr = payTypeStr;//选中的支付方式名称
        strongSelf.payTypeModel = payTypeModel;//选中支付方式对应的model
        if (payTypeModel == nil && payTypeStr == nil) {//使用其他银行卡---跳转新界面
            if (strongSelf.payCashierResultBlock) {
                strongSelf.payCashierResultBlock(strongSelf.payTypeModel, YES);
            }
            [strongSelf remove];
        }
        [strongSelf.tableView reloadData];
    }];
    //退出按钮
    [payCardListView setQuitBlock:^{
        STRONG_SELF;
        strongSelf.backgroundColor = RGBAlphaColor(13, 13, 13, 0.5);
    }];
    
}
#pragma mark - eventResponse                - Method -
- (void)sureBtnClick
{
    YMLog(@"确认支付...");
    if ([self.payTypeStr isEqualToString:@"选择支付方式"]||[self.payTypeStr isEqualToString:@"请选择支付方式"]) {
        [MBProgressHUD showText:@"选择支付方式"];
        return;
    }else{
        if (self.payCashierType == PayCashierTX) {
            [self searchDB];
        }else{
            if (self.payTypeModel == nil) {
                self.payTypeModel = [[YMBankCardModel alloc] init];
                self.payTypeModel.paySign = self.bankCardDataModel.defPaySign;
                self.payTypeModel = [self.bankCardDataModel getCurrentPayTypeModel:s.bankCardDataModel.defPaySign];
                if ([self.payTypeModel getCardTypeCount]==2) {//贷记卡
                    [self searchDB];
                    return;
                }
            }
            
            if (self.payCashierResultBlock) {
                self.payCashierResultBlock(self.payTypeModel,NO);
                [self remove];
            }
        }
        
    }
}

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void)selectQuitBtnMethod
{//退出按钮
    [self remove];
}

#pragma mark - objective-cDelegate          - Method -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        static NSString *cellID = @"YMPayCashierDescCell";
        YMPayCashierDescCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[YMPayCashierDescCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.moneyString = self.moneyStr;
        return cell;
    }else{
        static NSString *cellID = @"YMPayCashierTypeCell";
        YMPayCashierTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[YMPayCashierTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.payTypeString = self.payTypeStr;
        if (self.payCashierType == PayCashierMobile) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        return SCREENHEIGHT * 0.18;
    }else{
        return SCREENWIDTH * ROWProportion;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.payCashierType != PayCashierMobile) {
        if (indexPath.section == 1) {YMLog(@"选择支付方式。。。");
            [self selectPayType];
        }
    }
}

#pragma mark - getters and setters          - Method -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (YMPayCashierTopView *)topView
{
    if (!_topView) {
        _topView = [[YMPayCashierTopView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT * 0.07)];
        _topView.delegate = self;
        _topView.titleStr = @"支付详情";
    }
    return _topView;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[YMRedBackgroundButton alloc] init];
        [_sureBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (NSMutableArray *)bankListArray
{
    if (!_bankListArray) {
        _bankListArray = [[NSMutableArray alloc] init];
    }
    return _bankListArray;
}
/**
 调起收银台View
 
 @param vc 当前界面vc
 @param model 支付方式总model
 @param money 支付金额
 @param resultBlock 结果回调
 YMBankCardModel *bankCardModel----银行卡支付时，银行卡相关的信息
 isAddCard----是否使用其他银行卡
 */
- (void)showPayCashierDeskViewWtihCurrentVC:(UIViewController *)vc
                      withBankCardDataModel:(YMBankCardDataModel *)model
                                  withMoney:(NSString *)money
                                resultBlock:(void(^)(YMBankCardModel *bankCardModel,BOOL isAddCard))resultBlock
{
    self.vc = vc;
    self.bankCardDataModel = model;
    self.moneyStr = money;
    self.payTypeStr = [self.bankCardDataModel getPayBankStr];
    self.bankListArray = [model getBankCardListArray];
    self.payTypeModel = nil;
    self.payCashierResultBlock = [resultBlock copy];
    [self.tableView reloadData];
}
- (void)setPayCashierType:(PayCashierType)payCashierType
{
    _payCashierType = payCashierType;
}
#pragma mark - 密码校验弹框相关
#pragma mark - getters and setters          - Method -

#pragma mark - 信用卡 tx 相关
- (void)initDB
{
    self.listDB = [YMVerifyBankCardDataModel getUsingLKDBHelper];
    YMLog(@"create table sql :\n%@\n",[YMVerifyBankCardDataModel getCreateTableSQL]);
}
/*
 * 查询数据库
 */
- (void)searchDB{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *paySignStr = @"";
        if (self.payTypeModel == nil) {
            paySignStr = self.bankCardDataModel.getDefPaySignStr;
            self.payTypeModel = [[YMBankCardModel alloc] init];
        }else{
            paySignStr = self.payTypeModel.getPaySignStr;
        }
        
        NSString *sql = [NSString stringWithFormat:@"select * from YMVerifyBankCardDataModelDBTable where paySingKey='%@'",paySignStr];
        NSMutableArray *array = [self.listDB searchWithRAWSQL:sql toClass:[YMVerifyBankCardDataModel class]];
        YMLog(@"查询数据库 --- array = %@",array);
        
        self.payTypeModel.paySign = paySignStr;
        
        if (array.count>0) {
            //数据库中有安全码
            YMVerifyBankCardDataModel *verifyBankCardModel = array[0];
            self.payTypeModel.safetyCode = verifyBankCardModel.getSafetyCodeStr;
            if (self.payCashierResultBlock) {
                self.payCashierResultBlock(self.payTypeModel,NO);
                [self remove];
            }
        }else{
            //数据库中无安全码
            YMVerifyBankCardViewController *verifyBankCardVC = [[YMVerifyBankCardViewController alloc] init];
            self.payTypeModel.cardType = 2;
            NSString *payBankStr = self.bankCardDataModel.getPayBankStr;
            NSString *userTypeValueStr = @"";
            NSArray *a = [payBankStr componentsSeparatedByString:@"("];
            if (a.count>0) {
                userTypeValueStr = a[0];
            }else{
                userTypeValueStr = payBankStr;
            }
            self.payTypeModel.useTypeValue = userTypeValueStr;
            verifyBankCardVC.bankCardModel = self.payTypeModel;
            verifyBankCardVC.fromXinYongCardPay = YES;
            verifyBankCardVC.payCashierView = self;
            self.hidden = YES;
            [self.vc.navigationController pushViewController:verifyBankCardVC animated:YES];
        }
    });
}



@end
