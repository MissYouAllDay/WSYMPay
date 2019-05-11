//
//  AccountViewController.m
//  WSYMPay
//
//  Created by 赢联 on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "AccountViewController.h"
#import "AreaViewController.h"
#import "ProfessionViewController.h"
#import "PhotographViewController.h"
#import "FirstRealNameCertificationViewController.h"
#import "IDVerificationViewController.h"
#import "E_MailViewController.h"
#import "IDVerificationViewController.h"
#import "YMUserInfoTool.h"
#import "YMChangeMobileVC.h"
#import "YMResponseModel.h"
@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView          *myTableView;
@property (nonatomic, weak)   UITableViewCell      *cityCell;
@property (nonatomic, strong) E_MailViewController *e_mailVC;
@property (nonatomic, weak) NSURLSessionTask       *task;
@property (nonatomic, strong) YMChangeMobileVC* changeVC;
@end

@implementation AccountViewController

- (UITableView *)myTableView{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.bounces = NO;
//        _myTableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        _myTableView.backgroundColor=[UIColor whiteColor];
        _myTableView.tableFooterView = [[UIView alloc]init];
    }
    return _myTableView;
}

- (E_MailViewController *)e_mailVC
{
    if (!_e_mailVC) {
        _e_mailVC = [[E_MailViewController alloc]init];
    }
    return _e_mailVC;
}

-(YMChangeMobileVC *)changeVC
{
    if (!_changeVC) {
        _changeVC = [[YMChangeMobileVC alloc]init];
    }
    return _changeVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI{
    [self creatNavigation];
    [self.view addSubview:self.myTableView];
    [WSYMNSNotification addObserver:self selector:@selector(selectedCity:) name:WSYMSelectedCityNotification object:nil];
    [WSYMNSNotification addObserver:self selector:@selector(refreshTableView) name:WSYMRefreshUserInfoNotification object:nil];
}

- (void)creatNavigation{
    self.navigationItem.title = @"账户信息";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0||section ==1) {
        return 1;
    }
    return 2;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
////    return  HEADERSECTION_HEIGHT;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDTH*ROWProportion;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier  = @"cellIdentifier";
    UITableViewCell *cell            = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    YMUserInfoTool  *currentUserInfo = [YMUserInfoTool shareInstance];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = RGBColor(169, 169, 169);
        cell.textLabel.font = COMMON_FONT;
        cell.detailTextLabel.font = COMMON_FONT;
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"账户名";
        cell.accessoryType = UITableViewCellAccessoryNone;
        if(currentUserInfo.custLogin){
            
        NSMutableString *string = [NSMutableString stringWithFormat:@"%@",currentUserInfo.custLogin];
        [string replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        cell.detailTextLabel.text = string;
            
        }
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"身份认证";
        if (currentUserInfo.usrStatus == -1) {
            cell.detailTextLabel.text = @"未实名";
        }else if (currentUserInfo.usrStatus == 2){
            cell.detailTextLabel.text = @"已认证";
        }else if (currentUserInfo.usrStatus == -2){
            cell.detailTextLabel.text = @"待完善";
        }else if (currentUserInfo.usrStatus == 1){
            cell.detailTextLabel.text = @"待完善";
        }else{
            cell.detailTextLabel.text = @"未通过认证";
        }
        
    }else if (indexPath.section == 2){
        if(indexPath.row == 0){
            cell.textLabel.text = @"手机号";
            if(currentUserInfo.usrMobile){
                
                
            NSMutableString *string = [NSMutableString stringWithFormat:@"%@",currentUserInfo.usrMobile];
            [string replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            cell.detailTextLabel.text = string;
                }
        }else{
            cell.textLabel.text = @"邮箱";
            
            
            if (currentUserInfo.usrEmail.length) {
                
                NSMutableString *string = [NSMutableString stringWithFormat:@"%@",currentUserInfo.usrEmail];
                [string replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                cell.detailTextLabel.text = string;
                
            }else{
                
            cell.detailTextLabel.text = @"";
                
            }
        }
    }else if (indexPath.section == 3){
        if(indexPath.row == 0){
            cell.textLabel.text = @"职业";
            if (!currentUserInfo.usrJob) {
                cell.detailTextLabel.text = @"未设置";
            } else {
                cell.detailTextLabel.text = currentUserInfo.usrJob;
            }
        }else{
            self.cityCell = cell;
            cell.textLabel.text = @"地区";
            if (!currentUserInfo.phoneAddress.length) {
                cell.detailTextLabel.text = @"未设置";
            }else{
                
                cell.detailTextLabel.text = currentUserInfo.phoneAddress;
            }
        }
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     YMUserInfoTool  *currentUserInfo     = [YMUserInfoTool shareInstance];
    if (indexPath.section == 1){
        
        if (currentUserInfo.usrStatus  == -1) {
            
            FirstRealNameCertificationViewController *frc = [[FirstRealNameCertificationViewController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:frc animated:YES];
            
        }else if (currentUserInfo.usrStatus == 2){
            
            IDVerificationViewController *ifvc = [[IDVerificationViewController alloc]init];
            ifvc.verificationStatus = IDVerificationStatusSuccess;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ifvc animated:YES];
            
        }else if (currentUserInfo.usrStatus == -2){
            
            IDVerificationViewController *ifvc = [[IDVerificationViewController alloc]init];
            ifvc.verificationStatus = IDVerificationStatusNotStart;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ifvc animated:YES];
            
        }else if (currentUserInfo.usrStatus  == 1){
            
            IDVerificationViewController *ifvc = [[IDVerificationViewController alloc]init];
            ifvc.verificationStatus = IDVerificationStatusStarting;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ifvc animated:YES];
            
        }else if (currentUserInfo.usrStatus  == 3){
            
            IDVerificationViewController *ifvc = [[IDVerificationViewController alloc]init];
            ifvc.verificationStatus = IDVerificationStatusFail;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ifvc animated:YES];
        }

        
    }else if (indexPath.section == 2){
        NSInteger usrStatus = currentUserInfo.usrStatus;
        if(indexPath.row == 0){
            if (usrStatus == -1) {
                [MBProgressHUD showText:@"请先进行实名认证"];
                return;
            }
            
            [self.navigationController pushViewController:self.changeVC animated:YES];
                
        }else{
            if (usrStatus == -1) {
                [MBProgressHUD showText:@"请先进行实名认证"];
                return;
            }
            self.e_mailVC.changeBlock = ^(NSString *e_mail){
                    
                UITableViewCell *cell     = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                cell.detailTextLabel.text = e_mail;
                    };
            [self.navigationController pushViewController:self.e_mailVC animated:YES];
        }
    }else if (indexPath.section == 3){
        if(indexPath.row == 0){
            ProfessionViewController *pv = [[ProfessionViewController alloc]init];
            pv.changeBlock = ^(NSString *Profession){
                UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                cell.detailTextLabel.text = Profession;
            };
            
            [self.navigationController pushViewController:pv animated:NO];
        }else{
            
               //地区
            AreaViewController *pVC = [[AreaViewController alloc]init];
            pVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pVC animated:YES];
          
        }
    }
}

//选择城市
-(void)selectedCity:(NSNotification *)notification
{
    NSString *name                  = notification.userInfo[WSYMSelectedCityName];
    YMUserInfoTool *currentUserInfo = [YMUserInfoTool shareInstance];
    currentUserInfo.phoneAddress    = name;
    
    RequestModel  *params    = [[RequestModel alloc]init];
    params.token             = currentUserInfo.token;
    params.phoneAddress      = name;
    params.tranCode          = CHANGEADDRESS;
    
    __weak typeof(self) weakSelf = self;

    [MBProgressHUD showMessage:@"正在修改"];
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1) {
            [currentUserInfo saveUserInfoToSanbox];
            [currentUserInfo refreshUserInfo];
            [MBProgressHUD showText:m.resMsg];
        }
        [weakSelf.myTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)refreshTableView
{
    self.e_mailVC = nil;
    [self.myTableView reloadData];

}

-(void)loadNewSettingData
{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc]init];
    params.token         = currentInfo.token;
    params.tranCode      = SETTINGINFO;
    __weak typeof(self) weakSelf = self;
   self.task = [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        if (m.resCode == 1) {
            currentInfo.payPwdStatus = m.payPwdStatus;
            currentInfo.usrStatus    = m.usrStatus;
            [currentInfo saveUserInfoToSanbox];
            [weakSelf.myTableView reloadData];
        } else {
            [MBProgressHUD showText:m.resMsg];
        }
        
    } failure:^(NSError *error) {
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([YMUserInfoTool shareInstance].loginStatus) {
        [self loadNewSettingData];
    }
}
-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.task cancel];
}

@end
