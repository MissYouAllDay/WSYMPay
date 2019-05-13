//
//  SettingViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/20.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "SettingViewController.h"
#import "SignOutLoginCell.h"
#import "PromptBoxView.h"
#import "ChangePayPwdViewController.h"
#import "ChangeLoginsPwdViewController.h"
#import "FirstRealNameCertificationViewController.h"
#import "IDVerificationViewController.h"
#import "LandViewController.h"
#import "YMPaymentViewController.h"
#import "YMUserInfoTool.h"
#import "YMCustomHeader.h"
#import "YMCancelAccountController.h"
#import "YMResponseModel.h"
#import "YMPublicHUD.h"
#import "AccountViewController.h"
#import "IDVerificationViewController.h"
#import "FirstRealNameCertificationViewController.h"
#import "FeedbackViewController.h"
#import "VersionNotesViewController.h"
#import "CXLoginHisVC.h"    // 切换账号
//登录页面
#import "LandViewController.h"

//实名认证cell TAG
#define NAMETAG  10000
//支付密码
#define PAY_PASSWORDTAG  10001
//修改登录密码
#define M_LOGIN_PASSWORDTAG 10002
//关于
#define ABOUTTAG 10003

#define SECURITYMANAGEMENTTAG 10004

//退出
#define SIGNOUTTAG 10005

//支付管理
#define MANAGERTAG 10006

//检查更新
#define UPDATETAG 10007


@interface SettingViewController ()<PromptBoxViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) PromptBoxView  *promptBoxView;



@property (nonatomic, weak) NSURLSessionTask *task;
@end

@implementation SettingViewController{
    
      ChangePayPwdViewController  * changeVC;
    ChangeLoginsPwdViewController * editLoginPwdVC;
}

- (instancetype)init
{
   
    return [self initWithStyle:UITableViewStylePlain];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
//    [self setupSubviews];
    [self setupRefresh];
    [self addNotification];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([YMUserInfoTool shareInstance].loginStatus) {
        [self loadNewSettingData];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.task cancel];
}


#pragma mark 初始化
-(void)addNotification
{
    
    [WSYMNSNotification addObserver:self selector:@selector(refreshTableView) name:WSYMRefreshUserInfoNotification object:nil];

}


-(void)setupSubviews
{
    //客服电话
    UILabel*tel         = [UILabel new];
    tel.backgroundColor = [UIColor redColor];
    tel.font            = [UIFont systemFontOfSize:[VUtilsTool fontWithString:13.0]];
    tel.text            = @"客服电话 : 4000-191-077";
    tel.alpha           = 1;
    tel.userInteractionEnabled = YES;
    tel.textColor       = FONTCOLOR;
    [tel sizeToFit];
    [self.view addSubview:tel];
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [tel addGestureRecognizer:tap];
    
    [tel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
        make.height.mas_equalTo((SCREENWIDTH * ROWProportion));
        
    }];
}

-(void)setupRefresh
{
    self.tableView.mj_header = [YMCustomHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewSettingData)];
    if([YMUserInfoTool shareInstance].loginStatus){
        self.tableView.mj_header.hidden = NO;
    }else{
        self.tableView.mj_header.hidden = YES;
    }
}

-(void)setupTableView
{

    self.view.backgroundColor = VIEWGRAYCOLOR;
    self.navigationItem.title = @"设置";
//    UIView * footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*ROWProportion*3)];
//    footerV.backgroundColor = VIEWGRAYCOLOR;
//    UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
//    [but setBackgroundColor:[UIColor whiteColor]];
//    [but setTitle:@"退出登录" forState:UIControlStateNormal];
//    but.titleLabel.font = COMMON_FONT;
//    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    but.layer.borderColor = LAYERCOLOR.CGColor;
//    but.layer.borderWidth = 1;
//    but.layer.cornerRadius = 6;
//    [but addTarget:self action:@selector(userSignOut) forControlEvents:UIControlEventTouchUpInside];
//    [footerV addSubview:but];
//    [but mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(LEFTSPACE);
//        make.right.mas_equalTo(-LEFTSPACE);
//        make.height.mas_equalTo(SCREENWIDTH*ROWProportion);
//        make.centerY.mas_equalTo(footerV.mas_centerY);
//    }];
    
    YMUserInfoTool * userInfo = [YMUserInfoTool shareInstance];
    if(!userInfo.loginStatus) {
        
        self.tableView.tableFooterView =[UIView new];
    }else
    {
//        self.tableView.tableFooterView =footerV;
        self.tableView.tableFooterView =[UIView new];
    }
    
    
}


#pragma mark 其他
-(void)refreshTableView
{
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREENWIDTH * ROWProportion) ;
}

-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}

-(void)loadNewSettingData
{
    self.tableView.mj_header.hidden = NO;
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
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showText:m.resMsg];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
//    if (section == 0) {
//        return 5;
//    }else {
//        return 2;
//    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
      
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    
        cell.accessoryType             = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle            = UITableViewCellSelectionStyleNone;
        cell.backgroundColor           = [UIColor whiteColor];
        cell.textLabel.font            = COMMON_FONT;
        cell.detailTextLabel.font      = COMMON_FONT;
        cell.textLabel.textColor       = RGBColor(0, 0, 0);
        cell.detailTextLabel.textColor = RGBColor(115, 115, 115);
        
        }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
        
            case 0:
                cell.textLabel.text=@"账户信息";
                cell.tag=1;
                break;
            case 1:
            {
                cell.textLabel.text=@"安全设置";
                cell.tag=2;
                //                cell.textLabel.text       = @"支付密码";
                //                cell.tag                  = PAY_PASSWORDTAG;
                //                if ([YMUserInfoTool shareInstance].payPwdStatus == -1){
                //                    cell.detailTextLabel.text = @"未设置";
                //                } else {
                //                    cell.detailTextLabel.text = nil;
                //                }
                
                break;
            }
            case 2:
                //                cell.textLabel.text = @"修改登录密码";
                //                cell.tag            = M_LOGIN_PASSWORDTAG;
                cell.textLabel.text=@"支付设置";
                cell.tag=3;
                
                break;
            case 3:
                cell.textLabel.text=@"清理缓存";
            {
                NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                cell.detailTextLabel.text=[self getCacheSizeWithFilePath:cachesPath];
            }
                cell.tag=4;
                //                cell.textLabel.text = @"支付管理";
                //                cell.tag            = MANAGERTAG;
                break;
            case 4:
                cell.textLabel.text=@"意见反馈";
                cell.tag=5;
                //                cell.textLabel.text = @"安全管理";
                //                cell.tag            = SECURITYMANAGEMENTTAG;
                break;
            case 5:
                cell.textLabel.text=@"版本说明";
                //                cell.tag            = ABOUTTAG;
                cell.tag=6;
                
                break;
            case 6:
                cell.textLabel.text=@"切换账户";
                cell.tag=7;
                break;
                
            case 7:
                cell.textLabel.text=@"退出账户";
                cell.tag=8;
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 1:
                cell.textLabel.text = @"关于网上有名";
                cell.tag            = ABOUTTAG;
                break;
            case 0:
                
                cell.textLabel.text = @"检查更新";
                cell.tag            = UPDATETAG;
                break;
                
            default:
                break;
        }
        
    }
    
    //    else if (indexPath.section == 2)
    //    {
    //        cell.tag            = SIGNOUTTAG;
    //        if ([YMUserInfoTool shareInstance].loginStatus) {
    //            cell.hidden         = NO;
    //            cell.textLabel.text = @"退出登录";
    //        } else {
    //            cell.hidden         = YES;
    //        }
    //
    //    }
    
    /**
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"身份认证";
                cell.tag = 0;
                break;
            case 1:
                cell.textLabel.text=@"账户信息";
                cell.tag=1;
                break;
            case 2:
            {
                cell.textLabel.text=@"安全设置";
                cell.tag=2;
//                cell.textLabel.text       = @"支付密码";
//                cell.tag                  = PAY_PASSWORDTAG;
//                if ([YMUserInfoTool shareInstance].payPwdStatus == -1){
//                    cell.detailTextLabel.text = @"未设置";
//                } else {
//                    cell.detailTextLabel.text = nil;
//                }
                
                break;
            }
            case 3:
//                cell.textLabel.text = @"修改登录密码";
//                cell.tag            = M_LOGIN_PASSWORDTAG;
                cell.textLabel.text=@"支付设置";
                cell.tag=3;

                break;
            case 4:
                cell.textLabel.text=@"清理缓存";
            {
                NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                cell.detailTextLabel.text=[self getCacheSizeWithFilePath:cachesPath];
            }
                cell.tag=4;
//                cell.textLabel.text = @"支付管理";
//                cell.tag            = MANAGERTAG;
                break;
            case 5:
                cell.textLabel.text=@"意见反馈";
                cell.tag=5;
                //                cell.textLabel.text = @"安全管理";
                //                cell.tag            = SECURITYMANAGEMENTTAG;
                break;
            case 6:
                cell.textLabel.text=@"版本说明";
//                cell.tag            = ABOUTTAG;
                cell.tag=6;

                break;
//            case 7:
//                cell.textLabel.text=@"切换账户";
//                cell.tag=7;
//                break;
                
            case 7:
                cell.textLabel.text=@"退出账户";
                cell.tag=7;
                break;
    
            default:
                break;
        }
    }else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 1:
                cell.textLabel.text = @"关于网上有名";
                cell.tag            = ABOUTTAG;
                break;
            case 0:
            
                cell.textLabel.text = @"检查更新";
                cell.tag            = UPDATETAG;
                break;
              
            default:
                break;
        }
     
    }
    
//    else if (indexPath.section == 2)
//    {
//        cell.tag            = SIGNOUTTAG;
//        if ([YMUserInfoTool shareInstance].loginStatus) {
//            cell.hidden         = NO;
//            cell.textLabel.text = @"退出登录";
//        } else {
//            cell.hidden         = YES;
//        }
//
//    }
    
    */
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    YMUserInfoTool * userInfo =[YMUserInfoTool shareInstance];
    
    
    if (cell.tag == ABOUTTAG) {
        YMLog(@"关于网上有名");
        return;
    }
    
    if(!userInfo.loginStatus) {
        
//        LandViewController * landVC     = [[LandViewController alloc]init];
//        landVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:landVC animated:NO];
        [self.navigationController popViewControllerAnimated:YES];

        return;
        
    }
// @{@"title":@"身份认证",@"icon":@"我的银行卡",@"nextVC":@"YMMyBankCardController"
    if (cell.tag == 0) {
        YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
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
    }
   else if(cell.tag==1) {
        AccountViewController *accountVC=[AccountViewController new];
        
        [self.navigationController pushViewController:accountVC animated:YES];
        return;
    }else if (cell.tag==2) {
                YMCancelAccountController *cancelAccountVC = [[YMCancelAccountController alloc]init];
                [self.navigationController pushViewController:cancelAccountVC animated:YES];
    }else if (cell.tag==3) {
                YMPaymentViewController *cancelAccountVC = [[YMPaymentViewController alloc]init];
                [self.navigationController pushViewController:cancelAccountVC animated:YES];
    }else if (cell.tag==4) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确定要清除缓存吗" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ac1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            [self clearCacheWithFilePath:cachesPath];
            [self.tableView reloadData];
        }];
        UIAlertAction *ac2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:ac1];
        [alert addAction:ac2];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (cell.tag==5) {
        FeedbackViewController * vc = [[FeedbackViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        //意见反馈
    }else if (cell.tag==6) {
        VersionNotesViewController *vc = [[VersionNotesViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (cell.tag==7) {
       
        CXLoginHisVC *vc = [[CXLoginHisVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (cell.tag==8) {
        [YMPublicHUD showActionSheetTitle:nil message:nil destructiveBtn:@"退出登录" cancelBtn:@"取消" destrusctive:^{
            [self userSignOut];
        } cancel:nil];
        
    }
    
    
//    if (cell.tag == NAMETAG) {
//
//            IDVerificationViewController * idvVC = [[IDVerificationViewController alloc]init];
//            if(userInfo.usrStatus == -2){
//                YMLog(@"未认证");
//                idvVC.verificationStatus             = IDVerificationStatusNotStart;
//                [self.navigationController pushViewController:idvVC animated:YES];
//
//            } else if(userInfo.usrStatus == 1){
//                YMLog(@"认证审核中");
//                idvVC.verificationStatus            = IDVerificationStatusStarting;
//                [self.navigationController pushViewController:idvVC animated:YES];
//
//            } else if(userInfo.usrStatus  == 2){
//                idvVC.verificationStatus            = IDVerificationStatusSuccess;
//                [self.navigationController pushViewController:idvVC animated:YES];
//
//            } else if(userInfo.usrStatus == 3){
//                idvVC.verificationStatus             = IDVerificationStatusFail;
//                [self.navigationController pushViewController:idvVC animated:YES];
//                YMLog(@"未通过认证");
//
//            } else if(userInfo.usrStatus == -1) {
//                YMLog(@"未实名认证");
//                FirstRealNameCertificationViewController * firstCerVC = [[FirstRealNameCertificationViewController alloc] init];
//                firstCerVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:firstCerVC animated:YES];
//
//            }
//
//    }
//
//    if (cell.tag == PAY_PASSWORDTAG) {
//
//        if (userInfo.payPwdStatus == -2) {
//
//            LandViewController * landVC     = [[LandViewController alloc]init];
//            landVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:landVC animated:NO];
//            return;
//
//        }
//
//        if (userInfo.payPwdStatus == -1) {
//
//           [self.promptBoxView show];
//            return;
//        }
//        if (userInfo.payPwdStatus == 1 && (userInfo.usrStatus == 2 || userInfo.usrStatus == 1 || userInfo.usrStatus == -2 || userInfo.usrStatus == 3)) {
//
//            if (!changeVC) {
//                ChangePayPwdViewController  *changePayPwdVC = [[ChangePayPwdViewController alloc]init];
//                changeVC = changePayPwdVC;
//            }
//            [self.navigationController pushViewController:changeVC animated:YES];
//
//        } else {
//
//            [self.promptBoxView show];
//            return;
//        }
//    }
//    if (cell.tag == M_LOGIN_PASSWORDTAG) {
//        YMLog(@"修改登录密码");
//        if (userInfo.loginStatus) {
//            if (!editLoginPwdVC) {
//                ChangeLoginsPwdViewController * changePwd = [[ChangeLoginsPwdViewController alloc] init];
//                editLoginPwdVC                            = changePwd;
//            }
//            [self.navigationController pushViewController:editLoginPwdVC animated:YES];
//        }
//    }
//    if (cell.tag == SIGNOUTTAG) {
//        [YMPublicHUD showActionSheetTitle:nil message:nil destructiveBtn:@"退出登录" cancelBtn:@"取消" destrusctive:^{
//            [self userSignOut];
//        } cancel:nil];
//    }
//    if (cell.tag == SECURITYMANAGEMENTTAG) {
//        YMLog(@"安全管理");
//        YMCancelAccountController *cancelAccountVC = [[YMCancelAccountController alloc]init];
//        [self.navigationController pushViewController:cancelAccountVC animated:YES];
//    }
//    if (cell.tag == MANAGERTAG) {
//        YMLog(@"支付管理");
//        YMPaymentViewController *cancelAccountVC = [[YMPaymentViewController alloc]init];
//        [self.navigationController pushViewController:cancelAccountVC animated:YES];
//    }
//    if (cell.tag == UPDATETAG) {
//        YMLog(@"检查更新");
//
//    }
}

//客服电话
-(void)tapAction
{
    [self callServicePhone];
}


#pragma mark - PromptBoxViewDelegate
-(void)promptBoxViewLeftButttonDidClick:(PromptBoxView *)promptBoxView
{
  
}

-(void)promptBoxViewRightButtonDidClick:(PromptBoxView *)promptBoxView
{
    
    FirstRealNameCertificationViewController * firstCerVC = [[FirstRealNameCertificationViewController alloc] init];
    firstCerVC.hidesBottomBarWhenPushed                   = YES;
    [self.navigationController pushViewController:firstCerVC animated:YES];
    
}
-(void)callServicePhone
{

    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4000191077"]];
}

-(void)userSignOut
{
    [[YMUserInfoTool shareInstance] removeUserInfoFromSanbox];
    self.tableView.mj_header.hidden = YES;

    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
    YMLog(@"退出登录");
    [self.navigationController popViewControllerAnimated:YES];
//    LandViewController * landVC     = [[LandViewController alloc]init];
//    landVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:landVC animated:NO];
    
}
-(NSString *)getCacheSizeWithFilePath:(NSString *)path {
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    
    for (NSString *subPath in subPathArr){
        
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
        
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
        
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    
    return totleStr;
}
-(BOOL)clearCacheWithFilePath:(NSString *)path {
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSString *filePath = nil;
    
    NSError *error = nil;
    
    for (NSString *subPath in subPathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    return YES;
}
@end
