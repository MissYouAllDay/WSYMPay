//
//  YMPayCardListView.m
//  WSYMPay
//
//  Created by pzj on 2017/5/23.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPayCardListView.h"
#import "YMPayCashierTopView.h"

#import "YMBankCardDataModel.h"
#import "YMBankCardModel.h"
#import "YMSelectModel.h"

#import "YMPayBalanceCell.h"
#import "YMPayBankCardCell.h"
#import "YMVerifyBankCardViewController.h"//信用卡时需要验证安全码是否有，没有跳转到这个界面
#import "LKDBHelper.h"
#import "YMVerifyBankCardDataModel.h"

@interface YMPayCardListView ()<UITableViewDelegate,UITableViewDataSource,YMPayCashierTopViewDelegate>
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YMPayCashierTopView *topView;

@property (nonatomic, copy) NSString *payTypeString;
@property (nonatomic, strong) YMBankCardModel *payTypeModel;
@property (nonatomic, strong) YMBankCardDataModel *bankCardDataModel;

@property (nonatomic, strong) NSMutableArray *canPayDataArray;
@property (nonatomic, strong) NSMutableArray *noCanPayDataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, assign) BOOL isSelectBalance;
@property (nonatomic, assign) BOOL isShowBalance;//是否显示余额,不传或YES显示余额
@property (nonatomic, strong) UIViewController *vc;

@property (nonatomic, strong) LKDBHelper *listDB;

@end

@implementation YMPayCardListView

static YMPayCardListView * s = nil;
#pragma mark - lifeCycle                    - Method -
+(YMPayCardListView *)getPayCardListView{
    s = [[self alloc] init];
    [s show];
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
        make.bottom.mas_equalTo(0);
    }];
    [self.tableView reloadData];
}
#pragma mark - privateMethods               - Method -
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isShowBalance = YES;
        self.isSelectBalance = NO;
        [self initViews];
    }
    return self;
}
- (void)initViews
{
    self.backgroundColor = RGBAlphaColor(13, 13, 13, 0.5);
    //    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    
    self.boxView = [[UIView alloc] init];
    self.boxView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.boxView];
    
    [self.boxView addSubview:[self topView]];
    [self.boxView addSubview:[self tableView]];
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

- (NSInteger)getItemCountWithSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0) {//2017-8-11余额不足时 不显示
        if (self.isShowBalance) {
            if (self.type == 1) {
                return 0;
            }else{
                if ([self.bankCardDataModel getIsAcbalUse]) {
                    return 1;
                }else{
                    return 0;
                }
            }
        }else{
            return 0;
        }
    }else if (section == 1){
        count = [self canPayDataArray].count;
    }else if (section == 2){
        count = 1;
    }else{
        count = [self noCanPayDataArray].count;
    }
    return count;
}
#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void)selectQuitBtnMethod
{
    if (self.quitBlock) {
        self.quitBlock();
    }
    [self remove];
}
#pragma mark - objective-cDelegate          - Method -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;//可支付银行卡、余额、使用其他银行卡、不可支付的卡
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getItemCountWithSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//余额 当isShowBalance=YES时,才显示余额模块
        
        if ([self.bankCardDataModel getIsAcbalUse]) {
            static NSString *cellID = @"YMPayBalanceCell";
            YMPayBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[YMPayBalanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            [cell sendBankCardDataModel:self.bankCardDataModel isSelect:self.isSelectBalance];
            return cell;
        }else{
            return nil;
        }

    }else if (indexPath.section == 1) {//可使用的银行卡(通过cartType判断是否可选即可)
        
        static NSString *cellID = @"YMPayBankCardCell";
        YMPayBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[YMPayBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.type = self.type;
        //互斥选择实现（通过改变model）
        /***********/
        if (self.selectArray.count>0) {
            YMSelectModel *selectModel = self.selectArray[indexPath.row];
            cell.isSelected = selectModel.isSelect;
        }
        /***********/
        if ([self canPayDataArray].count>0) {
            YMBankCardModel *model = [self canPayDataArray][indexPath.row];
            cell.bankCardModel = model;
        }
        return cell;
        
    }else if (indexPath.section == 2){//使用其他银行卡
        static  NSString*otherID = @"otherCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:otherID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherID];
            cell.textLabel.text = @"使用其他银行卡";
            cell.textLabel.textColor = FONTDARKCOLOR;
            cell.textLabel.font = [UIFont systemFontOfMutableSize:16];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }else{//不可使用的卡--cell(通过cartType判断是否可选即可)
        static NSString *cellID = @"YMPayBankCardCell";
        YMPayBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[YMPayBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.type = self.type;
        if ([self noCanPayDataArray].count>0) {
            YMBankCardModel *model = [self noCanPayDataArray][indexPath.row];
            cell.bankCardModel = model;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.boxView.bounds.size.height * 0.21;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowBalance) {//显示余额
        if (indexPath.section == 0) {//选择余额支付
            
            BOOL isAcbalUse = [self.bankCardDataModel getIsAcbalUse];
            if (isAcbalUse) {//余额足够
                /*
                 * 余额足够，选中余额时，下面的银行卡不能选中
                 */
                self.payTypeModel = [[YMBankCardModel alloc] init];
                self.payTypeModel.isSelectBalance = YES;
                self.isSelectBalance = YES;
                if ([self canPayDataArray].count>0) {
                    self.selectArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [self canPayDataArray].count; i++) {
                        YMSelectModel *selectModel = [[YMSelectModel alloc] init];
                        selectModel.isSelect = NO;
                        [self.selectArray addObject:selectModel];
                    }
                }
                [self.tableView reloadData];
                if (self.payTypeResultBlock) {
                    self.payTypeResultBlock(self.payTypeModel,@"余额支付");
                }
                [self remove];
            }
            
        }else if (indexPath.section == 1){//选择银行卡
            /*
             * 选中银行卡时，余额不能选中(互斥选择)
             */
            self.isSelectBalance = NO;
            self.payTypeModel.isSelectBalance = NO;
            //互斥选择实现（通过改变model）
            /***********/
            if ([self canPayDataArray].count>0) {
                self.selectArray = [[NSMutableArray alloc] init];
                for (int i = 0; i<[self canPayDataArray].count; i++) {
                    YMSelectModel *selectModel = [[YMSelectModel alloc] init];
                    selectModel.isSelect = NO;
                    [self.selectArray addObject:selectModel];
                }
                YMSelectModel *selectModel = self.selectArray[indexPath.row];
                selectModel.isSelect = !selectModel.isSelect;
            }
            [self.tableView reloadData];
            /***********/
            //选择银行卡对应的model
            if ([self canPayDataArray].count>0) {
                YMBankCardModel *model = [self canPayDataArray][indexPath.row];
                self.payTypeModel = model;
                self.payTypeString = [model getBankStr];
                /*
                 * 信用卡支付 逻辑：
                 * 从本地数据库中根据支付标记，获取信用卡的安全码
                 * 有安全码，返回到收银台支付弹框view(即执行self.payTypeResultBlock 回调即可)
                 
                 * 无安全码，文案提示“您的信用卡信息已过期，请重新认证”之后跳转信用卡信息认证界面YMVerifyBankCardViewController
                 */
                if ([self.payTypeModel getCardTypeCount]==2) {
                    
                    [self loadXinYongKasafetyCode];
                    
                }else{
                    if (self.payTypeResultBlock) {
                        self.payTypeResultBlock(self.payTypeModel, self.payTypeString);
                    }
                    [self remove];
                }
            }
            
            
        }else if (indexPath.section == 2){//使用其他银行卡
            self.isSelectBalance = NO;
            YMLog(@"使用其他银行卡");
            if (self.payTypeResultBlock) {
                self.payTypeResultBlock(nil,nil);
            }
            [self remove];
        }
    }else{//不显示余额，充值跟提现时用
        
        if (indexPath.section == 0) {//选择余额支付
            
            if ([self.bankCardDataModel isAcbalUsed]) {//余额可选
                self.payTypeModel = [[YMBankCardModel alloc] init];
                self.payTypeModel.isSelectBalance = YES;
                self.isSelectBalance = YES;
                if ([self canPayDataArray].count>0) {
                    self.selectArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [self canPayDataArray].count; i++) {
                        YMSelectModel *selectModel = [[YMSelectModel alloc] init];
                        selectModel.isSelect = NO;
                        [self.selectArray addObject:selectModel];
                    }
                }
                [self.tableView reloadData];
                if (self.payTypeResultBlock) {
                    self.payTypeResultBlock(self.payTypeModel,@"余额支付");
                }
                [self remove];
            }
            
            
        }else if (indexPath.section == 1){//选择银行卡
            
            self.isSelectBalance = NO;
            self.payTypeModel.isSelectBalance = NO;
            //互斥选择实现（通过改变model）
            /***********/
            if ([self canPayDataArray].count>0) {
                self.selectArray = [[NSMutableArray alloc] init];
                for (int i = 0; i<[self canPayDataArray].count; i++) {
                    YMSelectModel *selectModel = [[YMSelectModel alloc] init];
                    selectModel.isSelect = NO;
                    [self.selectArray addObject:selectModel];
                }
                YMSelectModel *selectModel = self.selectArray[indexPath.row];
                selectModel.isSelect = !selectModel.isSelect;
            }
            [self.tableView reloadData];
            /***********/
            //选择银行卡对应的model
            if ([self canPayDataArray].count>0) {
                YMBankCardModel *model = [self canPayDataArray][indexPath.row];
                self.payTypeModel = model;
                self.payTypeString = [model getBankStr];
                if (self.payTypeResultBlock) {
                    self.payTypeResultBlock(self.payTypeModel,self.payTypeString);
                }
            }
            [self remove];
            
        }else if (indexPath.section == 2){//使用其他银行卡
            self.isSelectBalance = NO;
            YMLog(@"使用其他银行卡");
            if (self.payTypeResultBlock) {
                self.payTypeResultBlock(nil,nil);
            }
            [self remove];
        }
        
    }
}

#pragma mark - getters and setters          - Method -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
- (YMPayCashierTopView *)topView
{
    if (!_topView) {
        _topView = [[YMPayCashierTopView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT * 0.07)];
        _topView.delegate = self;
        _topView.titleStr = @"选择支付方式";
    }
    return _topView;
}
- (NSMutableArray *)canPayDataArray
{
    if (!_canPayDataArray) {
        _canPayDataArray = [[NSMutableArray alloc] init];
    }
    return _canPayDataArray;
}
- (NSMutableArray *)noCanPayDataArray
{
    if (!_noCanPayDataArray) {
        _noCanPayDataArray = [[NSMutableArray alloc] init];
    }
    return _noCanPayDataArray;
}

#pragma mark - app4期
/**
 调起支付方式弹框view
 
 @param vc 当前界面vc
 @param dataModel 查询的支付方式总model
 @param array 银行卡列表array
 @param payTypeModel 当前选中的model
 @param isShowBalance 是否显示余额模块
 @param resultBlock 结果回调
 */
- (void)showPayTypeViewWtihCurrentVC:(UIViewController *)vc
               withBankCardDataModel:(YMBankCardDataModel *)dataModel
                       bankCardArray:(NSMutableArray *)array
                        payTypeModel:(YMBankCardModel *)payTypeModel
                       isShowBalance:(BOOL)isShowBalance
                         resultBlock:(void(^)(YMBankCardModel *payTypeModel,NSString *payTypeStr))resultBlock
{
    self.vc = vc;
    self.isShowBalance = isShowBalance;
    self.bankCardDataModel = dataModel;
    NSMutableArray *bankCardArray = array;
    self.payTypeModel = payTypeModel;
    
    if ([self canPayDataArray].count>0) {
        [[self canPayDataArray] removeAllObjects];
    }
    if ([self noCanPayDataArray].count>0) {
        [[self noCanPayDataArray] removeAllObjects];
    }
    if ([self selectArray].count>0) {
        [[self selectArray] removeAllObjects];
    }
    /**********/
    if (self.isShowBalance) {//显示余额
        for (YMBankCardModel *model in bankCardArray) {
            if ([model isCanUseFlag]) {
                [self.canPayDataArray addObject:model];//可用
            }else{
                [self.noCanPayDataArray addObject:model];//不可用
            }
        }
        
        NSInteger useType = [dataModel getUseType];
        if (useType == 0) {//默认余额
            self.isSelectBalance = YES;
            if ([self canPayDataArray].count>0) {
                self.selectArray = [[NSMutableArray alloc] init];
                for (YMBankCardModel *model in [self canPayDataArray]) {
                    YMSelectModel *selectModel = [[YMSelectModel alloc] init];
                    
                    if (self.payTypeModel != nil) {
                        if (self.payTypeModel.isSelectBalance) {
                            self.isSelectBalance = YES;
                            selectModel.isSelect = NO;
                        }else{
                            self.isSelectBalance = NO;
                            if ([model.mj_keyValues isEqual: self.payTypeModel.mj_keyValues]) {
                                selectModel.isSelect = YES;
                            }else{
                                selectModel.isSelect = NO;
                            }
                        }
                        [self.selectArray addObject:selectModel];
                    }
                    
                }
            }
        }else if(useType == 9){//请选择支付方式
            self.isSelectBalance = NO;
            if ([self canPayDataArray].count>0) {
                self.selectArray = [[NSMutableArray alloc] init];
                for (YMBankCardModel *model in [self canPayDataArray]){
                    
                    YMSelectModel *selectModel = [[YMSelectModel alloc] init];
                    if (self.payTypeModel != nil) {
                        if (self.payTypeModel.isSelectBalance) {
                            //需要判断余额是否可以支付
                            if ([dataModel getIsAcbalUse]) {
                                self.isSelectBalance = YES;
                            }else{
                                self.isSelectBalance = NO;
                            }
                            selectModel.isSelect = NO;
                        }else{
                            self.isSelectBalance = NO;
                            if ([model.mj_keyValues isEqual: self.payTypeModel.mj_keyValues]) {
                                selectModel.isSelect = YES;
                            }else{
                                selectModel.isSelect = NO;
                            }
                        }
                        [self.selectArray addObject:selectModel];
                    }
                }
            }
        }else{//默认银行卡 （遍历银行卡）
            self.isSelectBalance = NO;
            
            if ([self canPayDataArray].count>0) {
                self.selectArray = [[NSMutableArray alloc] init];
                for (YMBankCardModel *model in [self canPayDataArray]) {
                    YMSelectModel *selectModel = [[YMSelectModel alloc] init];
                    if (self.payTypeModel != nil) {
                        if (self.payTypeModel.isSelectBalance) {
                            self.isSelectBalance = YES;
                            selectModel.isSelect = NO;
                        }else{
                            self.isSelectBalance = NO;
                            if ([model.mj_keyValues isEqual:self.payTypeModel.mj_keyValues]) {
                                selectModel.isSelect = YES;
                            }else{
                                selectModel.isSelect = NO;
                            }
                        }
                    }else{//第一次payTypeModel为空
                        if (model.isDefaultCard) {
                            selectModel.isSelect = YES;
                        }else{
                            selectModel.isSelect = NO;
                        }
                    }
                    [self.selectArray addObject:selectModel];
                }
            }
        }
        
    }else{//不显示余额（充值跟提现时）
        
        NSMutableArray *bankCardArray = array;
        self.isSelectBalance = NO;
        
        for (YMBankCardModel *m in bankCardArray) {
            if ([m getCardTypeNum] == 1) {
                [self.canPayDataArray addObject:m];
            }else if ([m getCardTypeNum] == 2){
                [self.noCanPayDataArray addObject:m];
            }
        }
        if ([self canPayDataArray].count>0) {
            self.selectArray = [[NSMutableArray alloc] init];
            for (YMBankCardModel *model in [self canPayDataArray]) {
                YMSelectModel *selectModel = [[YMSelectModel alloc] init];
                if (model == self.payTypeModel) {
                    selectModel.isSelect = YES;
                }else{
                    selectModel.isSelect = NO;
                }
                [self.selectArray addObject:selectModel];
            }
        }
        
    }
    [self.tableView reloadData];
    
    self.payTypeResultBlock = [resultBlock copy];
}

- (void)setPayCashierView:(UIView *)payCashierView
{
    _payCashierView = payCashierView;
    [self.tableView reloadData];
}
/*
 * 信用卡支付 逻辑：
 * 从本地数据库中根据支付标记，获取信用卡的安全码
 * 有安全码，返回到收银台支付弹框view(即执行self.payTypeResultBlock 回调即可)
 * 无安全码，文案提示“您的信用卡信息已过期，请重新认证”之后跳转信用卡信息认证界面YMVerifyBankCardViewController
 */
- (void)loadXinYongKasafetyCode
{
    [self searchDB];
}

#pragma mark - 数据库相关
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
        NSString *sql = [NSString stringWithFormat:@"select * from YMVerifyBankCardDataModelDBTable where paySingKey='%@'",self.payTypeModel.getPaySignStr];
        NSMutableArray *array = [self.listDB searchWithRAWSQL:sql toClass:[YMVerifyBankCardDataModel class]];
        YMLog(@"查询数据库 --- array = %@",array);
        if (array.count>0) {
            //数据库中有安全码
            YMVerifyBankCardDataModel *verifyBankCardModel = array[0];
            self.payTypeModel.safetyCode = verifyBankCardModel.getSafetyCodeStr;
            if (self.payTypeResultBlock) {
                self.payTypeResultBlock(self.payTypeModel, self.payTypeString);
            }
            [self remove];
        }else{
            //数据库中无安全码
            YMVerifyBankCardViewController *verifyBankCardVC = [[YMVerifyBankCardViewController alloc] init];
            verifyBankCardVC.bankCardModel = self.payTypeModel;
            verifyBankCardVC.fromXinYongCardPay = YES;
            verifyBankCardVC.payCashierView = self.payCashierView;
            verifyBankCardVC.payCardListView = self;
            self.payCashierView.hidden = YES;
            self.hidden = YES;
            [self.vc.navigationController pushViewController:verifyBankCardVC animated:YES];
        }
    });
}


@end
