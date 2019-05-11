//
//  YMMyBankCardController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/11/30.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMMyBankCardController.h"
#import "YMMyBankCardCell.h"
#import "YMAddBankCardCell.h"
#import "YMAddBankCardController.h"
#import "YMBankCardModel.h"
#import "YMVerificationPaywordBoxView.h"
#import "ChangePayPwdViewController.h"
#import "YMUserInfoTool.h"
#import "YMMyHttpRequestApi.h"
#import "YMPublicHUD.h"
#import "YMBankCardNoneCell.h"
#import "FirstRealNameCertificationViewController.h"
#import "IDVerificationViewController.h"

@interface YMMyBankCardController ()<YMMyBankCardCellDelegate,UIActionSheetDelegate,YMVerificationPaywordBoxViewDelegate>

@property (nonatomic, strong) NSMutableArray *bankCardArray;

@property (nonatomic, strong) YMVerificationPaywordBoxView *payPasswordBoxView;

@property (nonatomic, strong) YMBankCardModel *deleteBankCardModel;
@property (nonatomic, assign) BOOL isLoad;
@property (nonatomic, weak) NSURLSessionTask *task;
@end

@implementation YMMyBankCardController

-(YMVerificationPaywordBoxView *)payPasswordBoxView
{
    if (!_payPasswordBoxView) {
        
        _payPasswordBoxView = [[YMVerificationPaywordBoxView alloc]init];
        _payPasswordBoxView.delegate = self;
    }

    return _payPasswordBoxView;
}

-(NSMutableArray *)bankCardArray
{
    if (!_bankCardArray) {
        
        _bankCardArray = [NSMutableArray array];
    }
    
    return _bankCardArray;
}
- (instancetype)init
{
   
    return [self initWithStyle:UITableViewStyleGrouped];
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.isLoad = NO;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    [self setupNotifications];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadBankList];
//    [self setShouldResignOnTouchOutside:NO];
    if(!self.isFirst) {
        [self setNavigationItem];
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self setShouldResignOnTouchOutside:YES];
    
    

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}

-(void)setupNotifications
{
    [WSYMNSNotification addObserver:self selector:@selector(loadBankList) name:WSYMUserAddBankCardSuccessNotification object:nil];
}

-(void)loadBankList{
        [[YMUserInfoTool shareInstance] loadUserInfoFromSanbox];
    [YMMyHttpRequestApi loadHttpRequestWithCheckBankListsuccess:^(NSArray<YMBankCardModel *> *response) {
        self.isLoad = YES;
        [self.bankCardArray removeAllObjects];
        [self.bankCardArray addObjectsFromArray:response];
        [self.tableView reloadData];
    }];
}

-(void)setNavigationItem
{
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"backblack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
//    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)setupSubViews
{
    self.tableView.delaysContentTouches = NO;
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.navigationItem.title = @"我的银行卡";
    self.tableView.tableFooterView = [[UIView alloc]init];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goAddBankCard)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _bankCardArray.count?_bankCardArray.count:0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.bankCardArray.count) {
        
      return [self haveBankCardCreatCell:tableView indexPath:indexPath];

    } else {
        
     return  [self bankCardNoneCreatCell:tableView indexPath:indexPath];
    
    }
}
//editbankcard
//侧滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.bankCardArray.count) {
    if (indexPath.section == self.bankCardArray.count) {
         return NO;
     }else {
         return YES;
     }
    }else {
        return NO;
    }
}
//此方法不走,但是必须要写
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"解除绑定" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
        //这里面写button点击之后的事件
//        [self.bankCardArray removeObjectAtIndex:indexPath.section];//这里的dataArray是可变数组，滑动删除的时候，需要删除数组中的元素
//        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationFade];
        [self deleteBankCard];
    }];
//    deleteRoWAction.backgroundColor=[UIColor colorWithHex:0xff003c];
    return @[deleteRoWAction];//最后返回这俩个RowAction 的数组
}
-(UITableViewCell *)haveBankCardCreatCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == self.bankCardArray.count) {
//      return  [self createAddBankCardCell:tableView];
//    } else {
        static NSString *ID = @"bankCardCell";
        YMMyBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[YMMyBankCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.delegate = self;
        }
        cell.bankCardInfo     = self.bankCardArray[indexPath.section];
        return cell;
//    }
    
}

-(UITableViewCell *)bankCardNoneCreatCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 1) {
//        return  [self createAddBankCardCell:tableView];
//    } else {
        static NSString *cellID = @"YMBankCardNoneCell";
        YMBankCardNoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[YMBankCardNoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.backgroundView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bankcard_none"]];
        return cell;
//    }

}

-(UITableViewCell *)createAddBankCardCell:(UITableView *)tableView
{
    static NSString *ID = @"addCardCell";
    YMAddBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[YMAddBankCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.textLabel.text     = @"+ 添加银行卡";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (self.bankCardArray.count) {
        
        if (indexPath.section == self.bankCardArray.count) {
            [self goAddBankCard];
        }
    } else {
        
        if (indexPath.section == 1) {
            [self goAddBankCard];
        }
    }
}

-(void)goAddBankCard
{
    NSInteger status = [YMUserInfoTool shareInstance].usrStatus;
    if (status != 2) {
        if (status == -2){
            [MBProgressHUD showText:MSG19];
            IDVerificationViewController *ifvc = [[IDVerificationViewController alloc]init];
            ifvc.verificationStatus = IDVerificationStatusNotStart;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ifvc animated:YES];
            
        }else if (status  == 1){
            [MBProgressHUD showText:MSG20];
            IDVerificationViewController *ifvc = [[IDVerificationViewController alloc]init];
            ifvc.verificationStatus = IDVerificationStatusStarting;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ifvc animated:YES];
            
        }else if (status  == 3){
            [MBProgressHUD showText:MSG21];
            IDVerificationViewController *ifvc = [[IDVerificationViewController alloc]init];
            ifvc.verificationStatus = IDVerificationStatusFail;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ifvc animated:YES];
             //认证状态 -1是‘未实名’，-2 是'未认证'， '1' 是 '认证审核中'， '2' 是 '已通过认证'跳转到 ， '3' 是 '未通过认证' ‘0’ 是未登录
        }else  {
//            [MBProgressHUD showText:@"未知错误"];
            YMAddBankCardController *addBankCardVC = [[YMAddBankCardController alloc]init];
            [self.navigationController pushViewController:addBankCardVC animated:YES];
        }
    }else{
        YMAddBankCardController *addBankCardVC = [[YMAddBankCardController alloc]init];
        [self.navigationController pushViewController:addBankCardVC animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.bankCardArray.count) {
        
        if (indexPath.section == self.bankCardArray.count) {
            
            return (SCREENWIDTH * ROWProportion);
        } else {
            
            return SCREENHEIGHT * 0.17;
        }
    } else {
        
        if (indexPath.section == 0) {
            
            return SCREENHEIGHT * 0.17;
        } else {
            return (SCREENWIDTH * ROWProportion);
        }
    
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return LEFTSPACE;
}

-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - YMMyBankCardCellDelegate
-(void)myBankCardCellManagementButtonDidClick:(YMMyBankCardCell *)cardCell
{
    self.deleteBankCardModel = cardCell.bankCardInfo;
    [YMPublicHUD showActionSheetTitle:nil message:nil destructiveBtn:@"解除绑定" cancelBtn:@"取消"destrusctive:^{
        [self deleteBankCard];
    } cancel:nil];
    
}
-(void)deleteBankCard
{
    [self.payPasswordBoxView show];
}
#pragma mark - YMVerificationPaywordBoxViewDelegate
-(void)verificationPaywordBoxViewQuitButtonDidClick:(YMVerificationPaywordBoxView *)boxView
{
    [self.task cancel];
    YMLog(@"退出");
}
-(void)verificationPaywordBoxView:(YMVerificationPaywordBoxView *)boxView completeInput:(NSString *)str
{
    boxView.loading = YES;
   self.task = [YMMyHttpRequestApi loadHttpRequestWithDeleteBankCard:self.deleteBankCardModel.paySign payPwd:str success:^(NSInteger resCode, NSString *resMsg) {
        if (resCode == 1) {
            [boxView removeFromSuperview];
            [MBProgressHUD showText:@"解绑成功"];
            [self loadBankList];
        } else {
            [self showMessage:resMsg resCode:resCode];
         }
    }];
}

-(void)showMessage:(NSString *)message resCode:(NSInteger)code
{
    if (code == PWDERRORTIMES_CODE){//密码错误，还可以输入"+N+"次"
        [YMPublicHUD showAlertView:nil message:message cancelTitle:@"重新输入" confirmTitle:@"忘记密码" cancel:^{
            self.payPasswordBoxView.loading = NO;
        } confirm:^{
            [self goChangePayPassword];
        }];
        
    }else {
        
        [self.payPasswordBoxView removeFromSuperview];
        
        if (code == PAYPWDLOCK_CODE) {
            [YMPublicHUD showAlertView:nil message:MSG15 cancelTitle:@"取消" confirmTitle:@"忘记密码" cancel:nil confirm:^{
                [self goChangePayPassword];
            }];
        } else {
            [YMPublicHUD showAlertView:nil message:message cancelTitle:@"确定" handler:nil];
        }
    }
}

-(void)verificationPaywordBoxViewForgetButtonDidClick:(YMVerificationPaywordBoxView *)boxView
{
    [self goChangePayPassword];
}

-(void)goChangePayPassword
{
    [self.payPasswordBoxView removeFromSuperview];
    ChangePayPwdViewController *changePayVC = [[ChangePayPwdViewController alloc]init];
    [self.navigationController pushViewController:changePayVC animated:YES];
}

@end
