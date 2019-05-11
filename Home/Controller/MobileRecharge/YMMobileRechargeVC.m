//
//  YMMobileRechargeVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/8.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMMobileRechargeVC.h"
#import "FinancialTool.h"
#import "YMCollectionModel.h"
#import "YMUserInfoTool.h"

#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <Contacts/Contacts.h>
#import <Contacts/ContactsDefines.h>
#import <ContactsUI/CNContactPickerViewController.h>
#import <ContactsUI/CNContactViewController.h>
#import <ContactsUI/ContactsUI.h>
#import "YMMobileRechargeModel.h"
#import "YMPayCashierView.h"
#import "YMVerificationPaywordBoxView.h"
#import "ChangePayPwdViewController.h"
#import "YMBankCardBaseModel.h"
#import "YMBankCardDataModel.h"
#import "YMBankCardModel.h"
#import "YMMyHttpRequestApi.h"
#import "YMAllBillListVC.h"
#import "YMBillRecordListVC.h"


@interface YMMobileRechargeVC ()<FinancialToolDelegate,CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UICollectionView * collectView;
@property (nonatomic, strong) FinancialTool * financialtool;
@property (nonatomic, strong) YMVerificationPaywordBoxView * pwdBoxView;

@property (nonatomic, strong) YMBankCardDataModel *bankCardDataModel;
@property (nonatomic, strong) YMBankCardModel *payTypeModel;//当前支付的model

#pragma mark - 密码弹框相关
@property (nonatomic, strong) NSURLSessionTask *task;

@property (nonatomic, strong) YMCollectionModel *mobileModel;

@end

@implementation YMMobileRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手机充值";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectView];
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.financialtool.registerCellArr = @[
                                                  @{@"name":@"YMMobileCollectionViewCell_phone",
                                                    @"isXib":@NO
                                                    },
                                                  @{@"name":@"YMMobileCollectionViewCell_money",
                                                    @"isXib":@NO
                                                    },
                                                  @{@"name":@"YMAllCollectionViewCell",
                                                    @"isXib":@NO
                                                    }
                                                  ];
    self.financialtool.registerSectionHeaderArr = @[
                                                           @{@"name":@"YMCollectionMobileReusableView",
                                                             @"isXib":@NO
                                                             },
                                                           @{@"name":@"UICollectionViewCell",
                                                             @"isXib":@NO
                                                             }
                                                           ];
    
    

    
    
    [self creatNavigationItem];
    
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    
    self.mobileModel = [YMCollectionModel new];
    self.mobileModel.title = currentInfo.usrMobile;
    [self loadRequestData];
 
    
//    YMAllCollectionViewCell
}
-(UICollectionView *)collectView
{
    if (!_collectView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectView.delegate = self.financialtool;
        _collectView.dataSource = self.financialtool;
        [_collectView setBackgroundColor:[UIColor whiteColor]];
    }
    
    return _collectView;
}
-(FinancialTool *)financialtool
{
    if (!_financialtool) {
        
        _financialtool = [[FinancialTool alloc] initWithCollectionViewFrame:CGRectZero];
        _financialtool.delegate = self;
        _financialtool.collectionView = self.collectView;
        
    }
    return _financialtool;
}
- (void)creatNavigationItem{
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    UIBarButtonItem  *rightBBI = [[UIBarButtonItem alloc]initWithTitle:@"充值记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
    rightBBI.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBBI;
}
-(void)loadRequestData
{
    [MBProgressHUD show];
  
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    
    NSDictionary * paramDic = @{
                                    @"token":currentInfo.token,
                                    @"tranCode":MOBILERECHARGEVERIFYCODE,
                                    @"recPhoneNo":[self.mobileModel.title encryptAES]
                                    
                                    };
    
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:paramDic success:^(id responseObject) {
        NSInteger resCode = [responseObject[@"resCode"] intValue];
        if (resCode == 1) {
            [MBProgressHUD hideHUD];
            [self resetData:responseObject[@"data"]];
        } else {
            NSString * resMsg = responseObject[@"resMsg"];
            [MBProgressHUD showText:resMsg];
            [self resetData:[NSDictionary new]];
        }
        
    } failure:^(NSError *error) {
    }];
}



- (void)resetData:(NSDictionary *)dic
{
    //    [self collectionViewTool].string = @"nib";
    
    
    
    //section 0
   self.mobileModel.detailTitle = dic[@"phoneOwnership"];

    
    //section 1
    NSArray * modelArr = [YMMobileRechargeModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
    NSMutableArray * sectionTwoData = [NSMutableArray new];
    if(modelArr.count > 0)
    {
        for (int i = 0; i<modelArr.count; i++) {
            YMMobileRechargeModel * model = modelArr[i];
            
            YMCollectionModel * rechModel = [YMCollectionModel new];
            rechModel.title = model.prodContent;
            rechModel.detailTitle = model.prodPrice;
            rechModel.prodId = model.prodId;
            rechModel.canRech = model.canRech;
            rechModel.nextVC = @"YMPayCashierView";
            [sectionTwoData addObject:rechModel];
        }
    }else
    {
        NSArray * moneyArr = @[@"30",@"50",@"100",@"200",@"300",@"500"];
        for (int i= 0; i<moneyArr.count; i++) {
            YMCollectionModel * rechModel = [YMCollectionModel new];
            rechModel.title = moneyArr[i];
            rechModel.detailTitle = moneyArr[i];
            rechModel.prodId = @"";
            rechModel.canRech = NO;
            rechModel.nextVC = @"YMPayCashierView";
            [sectionTwoData addObject:rechModel];
        }
        
    }
    
    
    //section 2
    YMCollectionModel * classModel4 = [YMCollectionModel new];
    classModel4.imgName = @"充流量";
    classModel4.title = @"充流量";
    
    YMCollectionModel * classModel5 = [YMCollectionModel new];
    classModel5.imgName = @"水电煤宽带";
    classModel5.title = @"水电煤宽带";
    
    YMCollectionModel * classModel6 = [YMCollectionModel new];
    classModel6.imgName = @"游戏充值";
    classModel6.title = @"游戏充值";
    
    YMCollectionModel * classModel7 = [YMCollectionModel new];
    classModel7.imgName = @"其他";
    classModel7.title = @"其他";
    
    
    self.financialtool.allArr = @[
                                         @{
                                             @"itemCell":@"YMMobileCollectionViewCell_phone",
                                             @"column":@"1",
                                             @"title":@"",
                                             @"multipliedBy":@"0.22",
                                             @"sectionHeader":@"",
                                             @"sectionFooter":@"",
                                             @"sizeForHeader":@"0",
                                             @"sizeForFooter":@"0",
                                             @"function":@[self.mobileModel]
                                             
                                             },
                                         
                                         @{
                                             @"itemCell":@"YMMobileCollectionViewCell_money",
                                             @"column":@"3",
                                             @"title":@"选择充值金额",
                                             @"multipliedBy":@"0.55",
                                             @"margin-top":@"0",
                                             @"margin-left":@"11",
                                             @"margin-bottom":@"0",
                                             @"margin-right":@"11",
                                             @"sectionHeader":@"YMCollectionMobileReusableView",
                                             @"sectionFooter":@"",
                                             @"sizeForHeader":@"50",
                                             @"sizeForFooter":@"0",
                                             @"function":sectionTwoData
                                             
                                             },
                                         
                                         @{
                                             @"itemCell":@"YMAllCollectionViewCell",
                                             @"column":@"4",
                                             @"title":@"",
                                             @"multipliedBy":@"1",
                                             @"sectionHeader":@"UICollectionViewCell",
                                             @"sectionFooter":@"",
                                             @"sizeForHeader":@"15",
                                             @"sizeForFooter":@"0",
                                             @"function":@[classModel4,classModel5,classModel6,classModel7]
                                             
                                             }
                                         
                                         ];
    
    
    [UIView performWithoutAnimation:^{
       [self.financialtool.collectionView reloadData];
        
    }];
    
    
}
/**
 充值记录

 @param sender UIBarButtonItem
 */
-(void)rightBtnClick:(UIBarButtonItem *)sender
{
    YMBillRecordListVC * listVC = [[YMBillRecordListVC alloc] init];
    listVC.billType = BillMobilePhoneRecharge;
    [self.navigationController pushViewController:listVC animated:YES];
}

/**
 点击进入系统 电话簿页面 
 */
-(void)presentContactViewController
{
    //通讯录。。。
    [self.view endEditing:YES];
    if ([self accessTheAddress]) {
        [self getAddressBookNumber];
    }
    
}
//通讯录授权
- (BOOL)accessTheAddress
{
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    __block BOOL accessGranted = NO;
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            if (error) {
                NSLog(@"Error:%@",(__bridge NSError *)error);
            }else if (!granted){
                
            }else{
                accessGranted = YES;
            }
        });
    }else if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusAuthorized){
        accessGranted = YES;
    }else{
        NSLog(@"用户未授权提示");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有开启授权" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    }
    return accessGranted;
}
//获取通讯录里的号码
- (void)getAddressBookNumber
{
    if (System_Version >= 9.0) {
        CNContactPickerViewController *con = [[CNContactPickerViewController alloc] init];
        con.delegate = self;
        [self presentViewController:con animated:YES completion:nil];
    }else{
        ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
        nav.peoplePickerDelegate = self;
        if (System_Version>=8.0&&System_Version<9.0) {
            nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}
//通讯录相关
//获取电话号码iOS9以上
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    NSLog(@"%@",contactProperty.value);
    CNPhoneNumber *str = contactProperty.value;
    if ([str isKindOfClass:[CNPhoneNumber class]]) {
        NSString *phone = [str.stringValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        YMLog(@" 电话号码 = %@",phone);
        //返回电话号码
        [self selectAddressBook:phone];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//获取电话号码（iOS8）
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phoneNumber = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phoneNumber, identifier);
    NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneNumber, index);
    if ([phone hasPrefix:@"+"]) {
        phone = [phone substringFromIndex:3];
    }
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    YMLog(@"电话号码 ---- %@",phone);
    if (phoneNumber) {
        //返回电话号码
        [self selectAddressBook:phone];
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}
- (void)selectAddressBook:(NSString *)phone
{
    self.mobileModel.title = phone;
    self.mobileModel.detailTitle =@"";
    
    [UIView performWithoutAnimation:^{
        [self.financialtool.collectionView reloadData];
        
    }];
    
   
    
    if ([phone isValidateMobile]) {
        //请求API接口数据
        [self loadRequestData];
    }else
    {
        [MBProgressHUD showText:MSG18];
    }
    
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    NSLog(@"跳转 --- ");
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

//取消选择（i0S9以上）
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//取消选择（<iOS8）
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        YMLog(@"跳转到手机系统设置界面");
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];           [[UIApplication sharedApplication] openURL:url];
        }
    }
}


/**
 请求 手机充值接口 返回可充值的金额数据
 
 @param phoneNum 手机充值接口
 */
-(void)requestMobileApi:(NSString *)phoneNum
{
    if (phoneNum.length == 0) {
        NSDictionary * dic = self.financialtool.allArr[1];
        NSArray * modelArr = dic[@"function"];
        for (YMCollectionModel * mod in modelArr) {
            mod.canRech = NO;
        }
        [UIView performWithoutAnimation:^{
             [self.financialtool.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }];
       
    }else
    {
       [self loadRequestData];
    }
    
}

/**
 点击 金额充值或者未开发功能

 @param model YMCollectionModel
 */
-(void)selectItemWithModel:(YMCollectionModel *)model
{
    if (model.nextVC.length > 0) {
        if (model.canRech) {
            //判断可用余额
            [self loadApiValidBalance:model];
            
        }
    }else
    {
        [MBProgressHUD showText:MSG0];
    }
}

#pragma mark - 网络请求
//查询支付方式接口  判断余额是否 可用
- (void)loadApiValidBalance:(YMCollectionModel *)model
{
    RequestModel *params = [[RequestModel alloc] init];
    params.txAmt = model.detailTitle;
    params.tranTypeSel = @"5";
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithGetPayTypeParameters:params success:^(YMBankCardBaseModel *baseModel) {
        STRONG_SELF;
        YMBankCardDataModel *dataM = [baseModel getBankCardDataModel];
        strongSelf.bankCardDataModel = dataM;
        if ([strongSelf.bankCardDataModel getIsAcbalUse]) {
            [strongSelf loadPayCashierView:model];
        }else{
            [MBProgressHUD showText:@"余额不足"];
        }
    }];
}
//网络请求 （请求创建手机充值订单接口）
- (void)loadCreatOrderData:(YMCollectionModel *)model
{
    [MBProgressHUD show];
    NSDictionary * dic =  self.financialtool.allArr[0];
    NSArray * arr = dic[@"function"];
    YMCollectionModel * phoneModel = arr[0];
  
    YMUserInfoTool * user = [YMUserInfoTool shareInstance];
   
    NSDictionary * paramDic = @{
                                    @"token":user.token,
                                    @"tranCode":MOBILERECHARGEORDERCODE,
                                    @"recPhoneNo":[phoneModel.title encryptAES],
                                    @"txAmt":[model.detailTitle encryptAES],
                                    @"prodcontent":model.title,
                                    @"phoneOwnership":phoneModel.detailTitle,
                                    @"prodId":model.prodId
                                
                                };
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:paramDic success:^(id responseObject) {
        //请求创建手机充值订单接口，成功后调用下面密码弹框方法
        NSInteger resCode = [responseObject[@"resCode"] intValue];
        NSString * resMsg = responseObject[@"resMsg"];
        if (resCode == 1) {
            [MBProgressHUD hideHUD];
            WEAK_SELF;
            weakSelf.bankCardDataModel.prdOrdNo = responseObject[@"data"][@"prdOrdNo"];
            [self havaFingerPay];
        }else
        {
            [MBProgressHUD showText:resMsg];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (void)havaFingerPay {
    
    CXFunctionTool *tool = [CXFunctionTool shareFunctionTool];
    tool.delegate = self;
    [tool fingerReg];
}

/** 指纹支付代理*/
- (void)functionWithFinger:(NSInteger)error {
    
    error == 0 ? [self loadPayPasswordBoxView] : [self fingerPay];
}

- (void)fingerPay {
    
    NSString *fingerText = [NSString stringWithFormat:@"{\"machineNum\":\"%@\",\"raw\":\"%@\",\"tee_n\":\"IOS\",\"tee_v\":\"%@\"}",[ObtainUserIDFVTool getIDFV],[YMUserInfoTool shareInstance].randomCode,[[UIDevice currentDevice] systemVersion]];
    [self loadPayPwdData:[OpenSSLRSAManagers rsaSignStringwithString:fingerText] withPayType:1];
}
//网络请求 （请求校验手机充值支付密码接口）
- (void)loadPayPwdData:(NSString *)payPwd withPayType:(int)paytype
{
    
    YMUserInfoTool * user = [YMUserInfoTool shareInstance];
    NSDictionary * dic =  self.financialtool.allArr[0];
    NSArray * arr = dic[@"function"];
    YMCollectionModel * phoneModel = arr[0];
    //请求之后进行相应的操作
    NSDictionary * paramDic = @{@"token":user.token,
                                @"tranCode":MOBILERECHARGEPAYCODE,
                                @"recPhoneNo":[phoneModel.title encryptAES],
                                @"payPwd ":[payPwd encryptAES],
                                @"prdOrdNo":self.bankCardDataModel.prdOrdNo
                                };
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:paramDic];
    
    if (paytype == 1) {
        [param setObject:payPwd forKey:@"payPwd"];
    }
    NSString *fingerText = [NSString stringWithFormat:@"{\"machineNum\":\"%@\",\"raw\":\"%@\",\"tee_n\":\"IOS\",\"tee_v\":\"%@\"}",[ObtainUserIDFVTool getIDFV],[YMUserInfoTool shareInstance].randomCode,[[UIDevice currentDevice] systemVersion]];
    [param setObject:[fingerText encryptAES] forKey:@"fingerText"];
    [param setObject:[[ObtainUserIDFVTool getIDFV] encryptAES] forKey:@"machineNum"];
    [param setObject:[[NSString stringWithFormat:@"%d",paytype] encryptAES] forKey:@"pwdType"];
    
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:paramDic success:^(id responseObject) {
        //停止转动
         self.pwdBoxView.loading = NO;
        
        NSInteger resCode = [responseObject[@"resCode"] intValue];
        NSString * resMsg = responseObject[@"resMsg"];
        [MBProgressHUD showText:resMsg];
        if (resCode == 1) {
            //移除
            [self.pwdBoxView removeFromSuperview];
           
        }
        
        
    } failure:^(NSError *error) {
        //停止转动
         self.pwdBoxView.loading = NO;
    }];
    
   
   
}

#pragma mark - 调起收银台 弹框view
- (void)loadPayCashierView:(YMCollectionModel *)model
{
    WEAK_SELF;
    YMPayCashierView *payCashierView = [YMPayCashierView getPayCashierView];
    payCashierView.payCashierType = PayCashierMobile;
    [payCashierView showPayCashierDeskViewWtihCurrentVC:self withBankCardDataModel:self.bankCardDataModel withMoney:model.detailTitle resultBlock:^(YMBankCardModel *bankCardModel, BOOL isAddCard) {
        STRONG_SELF;
        strongSelf.payTypeModel = bankCardModel;
        
        [strongSelf loadCreatOrderData:model];
    }];
}
#pragma mark -//支付密码弹框
- (void)loadPayPasswordBoxView
{
    self.pwdBoxView = [YMVerificationPaywordBoxView getPayPwdBoxView];
    [self.pwdBoxView showPayPwdBoxViewResultSuccess:^(NSString *pwdStr) {
        self.pwdBoxView.loading = YES;
        YMLog(@"pwdStr = %@",pwdStr);
        [self loadPayPwdData:pwdStr withPayType:0];
    } forgetPwdBtn:^{
        [self.pwdBoxView removeFromSuperview];
        ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
        [self.navigationController pushViewController:changePayVC animated:YES];
    } quitBtn:^{
        [self.task cancel];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
