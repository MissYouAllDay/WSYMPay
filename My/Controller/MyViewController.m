//
//  MyViewController.m
//  WSYMPay
//
//  Created by 赢联 on 16/9/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "MyViewController.h"
#import "LandViewController.h"
#import "AccountViewController.h"
#import "SettingViewController.h"
#import "FirstRealNameCertificationViewController.h"
#import "YMUserInfoTool.h"
#import "YMUserInfoView.h"
#import "YMSquaresButtonCell.h"
#import "YMCustomHeader.h"
#import "YMMyBankCardController.h"
#import "UIView+Extension.h"
#import "YMPrepaidCardController.h"
#import "YMAccountBalanceViewController.h"
#import "ObtainUserIDFVTool.h"
#import "YMBillRecordListVC.h"
#import "IDVerificationViewController.h"
#import "YMServiceCell.h"
#import "YMScanViewController.h"
#import "YMTransferVC.h"
#import "PromptBoxView.h"


@interface MyViewController ()<YMUserInfoViewDelegate,YMSquaresButtonCellDelegate,PromptBoxViewDelegate>
@property (nonatomic, strong) YMUserInfoView *bgView;
@property (nonatomic, weak) NSURLSessionTask *task;
@property (nonatomic, strong) PromptBoxView  *promptBoxView;
@property (nonatomic, strong) NSArray * dataArr;
@property (nonatomic, strong) UILabel * headerL;
@end

@implementation MyViewController

#pragma mark - 生命周期
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self creatNavigationItem];
    [self setupNotification];
    [self updateStatusForSubviews];
    [self setupRefresh];
}
//YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
//IDVerificationViewController * idvVC = [[IDVerificationViewController alloc]init];
//if(currentInfo.usrStatus == -2){
//    YMLog(@"未认证");
//    idvVC.verificationStatus             = IDVerificationStatusNotStart;
//    [self.navigationController pushViewController:idvVC animated:YES];
-(NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = @[
                     @{
                         @"title":@"",
                         @"function": @[
                                 @{@"title":@"交易记录",@"icon":@"账单",@"nextVC":@"YMBillRecordListVC"},
                                 @{@"title":@"有名会员",@"icon":@"有名会员",@"nextVC":@""},
                                 @{@"title":@"账户余额",@"icon":@"账户余额",@"nextVC":@"YMAccountBalanceViewController"},
                                   @{@"title":@"身份认证",@"icon":@"我的银行卡",@"nextVC":@"YMMyBankCardController"}
                                 
                                 ]
                         }
//                     @{
//                         @"title":@"越花越有",
//                         @"function":@[
//                                 @{@"title":@"我的额度",@"icon":@"我的额度",@"nextVC":@""},
//                                 @{@"title":@"分期付",@"icon":@"分期付",@"nextVC":@""}
//                                 ]
//                         },
//                     @{
//                         @"title":@"理财",
//                         @"function":@[
//                                 @{@"title":@"活期理财",@"icon":@"活期理财",@"nextVC":@""},
//                                 @{@"title":@"定期理财",@"icon":@"定期理财",@"nextVC":@""},
//                                 @{@"title":@"基金理财",@"icon":@"基金理财",@"nextVC":@""}
//
//                                 ]
//                         }
                     
                     ];
    }
    return _dataArr;
}
-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getNavigationImageView].hidden = YES;
    if ([YMUserInfoTool shareInstance].loginStatus) {
       self.task = [[YMUserInfoTool shareInstance] loadUserInfoFromServer:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self getNavigationImageView].hidden = NO;
    [super viewWillDisappear:animated];
    [self.task cancel];
}

#pragma mark - 初始化
-(void)setupRefresh
{
    self.tableView.mj_header = [YMCustomHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewestUserInfo)];
}

-(void)setupNotification
{
    [WSYMNSNotification addObserver:self
                           selector:@selector(updateStatusForSubviews)
                               name:WSYMRefreshUserInfoNotification
                             object:nil];
    
    [WSYMNSNotification addObserver:self
                           selector:@selector(userLogout)
                               name:WSYMUserLogoutNotification
                             object:nil];
}
-(void)userLogout
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)loadNewestUserInfo
{
    WEAK_SELF;
  self.task = [[YMUserInfoTool shareInstance] loadUserInfoFromServer:^{
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

-(void)updateStatusForSubviews
{
    YMUserInfoTool *currentUserInfo = [YMUserInfoTool shareInstance];
    self.bgView.userLoginStatus     = currentUserInfo.loginStatus;
    
    
    if (currentUserInfo.loginStatus) {
        
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.title = [currentUserInfo getShowAccountStr];
        self.tableView.mj_header.hidden = NO;
        self.tableView.scrollEnabled    = YES;
    
    } else {
    
        self.navigationItem.leftBarButtonItem.title   = @"";
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.tableView.mj_header.hidden = YES;
        self.tableView.scrollEnabled    = NO;
    }
    
    
    [self.tableView reloadData];
}

- (void)setupSubviews{
    self.navigationItem.title = nil;
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.view.backgroundColor      = VIEWGRAYCOLOR;
    _bgView          = [[YMUserInfoView alloc]init];
    _bgView.delegate = self;
    _bgView.frame    = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.4);
    self.tableView.tableHeaderView = _bgView;
}

- (void)creatNavigationItem{
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    UIBarButtonItem  *rightBBI = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
    rightBBI.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBBI;
    
    UIBarButtonItem  *leftBBI = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick:)];
    rightBBI.tintColor        = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBBI;
    
}

//设置
- (void)rightBtnClick:(UIButton*)btn{
    SettingViewController *settingVC   = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
- (void)leftBtnClick:(UIButton*)btn{
    AccountViewController * av  = [[AccountViewController alloc]init];
    [self.navigationController pushViewController:av animated:NO];
    
}
-(void)userInfoViewLoginButtonDidClick:(YMUserInfoView *)infoView
{
    LandViewController * landVC     = [[LandViewController alloc]init];
    landVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:landVC animated:NO];
}



#pragma mark - UITableViewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr[section][@"function"] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([YMUserInfoTool shareInstance].loginStatus) {
       
        return self.dataArr.count;
    } else {
    
        return 0;
    }
    
}
#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        static NSString * identifer = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        NSDictionary * sectionDic = self.dataArr[indexPath.section];
        NSArray * dicArr =sectionDic[@"function"];
        NSDictionary * dic = dicArr[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:dic[@"icon"]];
        [cell.imageView sizeToFit];
        cell.textLabel.text = dic[@"title"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = COMMON_FONT;
        return cell;

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREENWIDTH * ROWProportion;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary * dic = self.dataArr[section];

    UIView * headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
    headerV.backgroundColor = [UIColor clearColor];
    
    UILabel * titleL = [UILabel new];
    [headerV addSubview:titleL];
    titleL.x = LEFTSPACE;
    titleL.y = 0;
    titleL.width = 200;
    titleL.height = HEADERSECTION_HEIGHT*2;
    titleL.textColor = FONTCOLOR;
    titleL.backgroundColor = [UIColor clearColor];
    titleL.font = [UIFont systemFontOfMutableSize:13];
    titleL.text = dic[@"title"];
    
    return headerV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSDictionary * dic = self.dataArr[section];
    if ([dic[@"title"] length] > 0) {
        return  HEADERSECTION_HEIGHT*2;
    }else
    {
       return  0.01;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    if (currentInfo.usrStatus == -1) {
        [self.promptBoxView show];
        return;
    }

    NSDictionary * sectionDic = self.dataArr[indexPath.section];
    NSArray * dicArr =sectionDic[@"function"];
    NSDictionary * dic = dicArr[indexPath.row];
    
    if ([dic[@"nextVC"] length] > 0) {
        Class  vc = NSClassFromString(dic[@"nextVC"]);
        if([dic[@"nextVC"] isEqualToString:@"YMMyBankCardController"]) {
            IDVerificationViewController * idvVC = [[IDVerificationViewController alloc]init];
            if(currentInfo.usrStatus == -2){
                YMLog(@"未认证");
                idvVC.verificationStatus             = IDVerificationStatusNotStart;
                [self.navigationController pushViewController:idvVC animated:YES];
                
            } else if(currentInfo.usrStatus == 1){
                YMLog(@"认证审核中");
                idvVC.verificationStatus            = IDVerificationStatusStarting;
                [self.navigationController pushViewController:idvVC animated:YES];
                
            } else if(currentInfo.usrStatus  == 2){
                idvVC.verificationStatus            = IDVerificationStatusSuccess;
                [self.navigationController pushViewController:idvVC animated:YES];
                
            } else if(currentInfo.usrStatus == 3){
                idvVC.verificationStatus             = IDVerificationStatusFail;
                [self.navigationController pushViewController:idvVC animated:YES];
                YMLog(@"未通过认证");
                
            } else if(currentInfo.usrStatus == -1) {
                YMLog(@"未实名认证");
                FirstRealNameCertificationViewController * firstCerVC = [[FirstRealNameCertificationViewController alloc] init];
                firstCerVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:firstCerVC animated:YES];
                
            }
            
            return;
        }else if ([dic[@"nextVC"] isEqualToString:@"YMBillRecordListVC"]) {
            YMBillRecordListVC *recordVC=[YMBillRecordListVC new];
            recordVC.billType= BillTransaction;
            [self.navigationController pushViewController:recordVC animated:YES];
            return;

        }else  {
        UIViewController * VController = [[vc alloc] init];
        [self.navigationController pushViewController:VController animated:YES];
        return;
        }
    }
    [MBProgressHUD showText:MSG0];
    
}
-(void)userInfoViewMoneyDidClick:(YMUserInfoView *)infoView
{
    YMAccountBalanceViewController *accountBalanceVC = [[YMAccountBalanceViewController alloc]init];
    [self.navigationController pushViewController:accountBalanceVC animated:YES];
}
-(PromptBoxView *)promptBoxView
{
    if (!_promptBoxView) {
        _promptBoxView = [[PromptBoxView alloc]init];
        _promptBoxView.title = @"您的账户未实名认证,为保证您的安全，请先实名认证";
        _promptBoxView.leftButtonTitle = @"取消";
        _promptBoxView.rightButtonTitle = @"去认证";
        _promptBoxView.delegate = self;
    }
    return _promptBoxView;
}
#pragma mark - PromptBoxViewDelegate(未实名弹框代理)
-(void)promptBoxViewLeftButttonDidClick:(PromptBoxView *)promptBoxView
{
}


-(void)promptBoxViewRightButtonDidClick:(PromptBoxView *)promptBoxView
{
    FirstRealNameCertificationViewController * firstCerVC = [[FirstRealNameCertificationViewController alloc] init];
    firstCerVC.hidesBottomBarWhenPushed                   = YES;
    [self.navigationController pushViewController:firstCerVC animated:YES];
}
@end
