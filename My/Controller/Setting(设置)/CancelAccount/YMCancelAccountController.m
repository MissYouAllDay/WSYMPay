//
//  YMCancelAccountController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/13.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMCancelAccountController.h"
#import "YMNotCancelAccountController.h"
#import "YMCancelAccountProtocolController.h"
#import "YMMyHttpRequestApi.h"
#import "YMResponseModel.h"
#import "DetailPayPwdViewController.h"
#import "SetpasswordViewController.h"
#import "YMLoginWayViewController.h"
#import "KeychainData.h"
#import "ChangeLoginsPwdViewController.h"
#import "ChangePayPwdViewController.h"
#import "YMAccountTimeViewController.h"
#import "YMFingerprintViewController.h"
@interface YMCancelAccountController ()

@end

@implementation YMCancelAccountController

#pragma mark - lifeCycle                    - Method -
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

#pragma mark - privateMethods               - Method -
-(void)setupSubviews
{
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.navigationItem.title      = @"安全管理";
}

/**
 注销账户校验
 */
- (void)loadData
{
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithCheckLogoffSuccess:^(YMResponseModel *model) {
        STRONG_SELF;
        if (model != nil) {//进入注销账户界面(请求成功之后 不管resCode 多少都要进入注销账户界面，在注销账户界面判断，然后决定文字显示)
            YMCancelAccountProtocolController *accountProtocolVC = [[YMCancelAccountProtocolController alloc]init];
            accountProtocolVC.model = model;
            [strongSelf.navigationController pushViewController:accountProtocolVC animated:YES];
        }
    } failure:^(NSError *error) {

    }];
}
#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *arr = @[@"解锁方式",@"修改登录密码",@"修改支付密码",@"手势设置",@"指纹设置",@"解锁设置"];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text  = arr[indexPath.row];
    cell.accessoryType   = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YMLoginWayViewController * vc = [[YMLoginWayViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1) {
        ChangeLoginsPwdViewController *vc = [[ChangeLoginsPwdViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2) {
        ChangePayPwdViewController *vc = [[ChangePayPwdViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 3)  {
        BOOL isSave = [KeychainData isSave]; //是否有保存
        if (isSave) {
            SetpasswordViewController *setpass = [[SetpasswordViewController alloc] init];
            setpass.string = @"修改密码";
            [self.navigationController pushViewController:setpass animated:YES];
        } else {
            SetpasswordViewController *setpass = [[SetpasswordViewController alloc]init];
            setpass.string = @"重置密码";
            [self.navigationController pushViewController:setpass animated:YES];
        }
        
    }
    else if (indexPath.row == 4) {
        YMFingerprintViewController *vc = [[YMFingerprintViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 5) {
        YMAccountTimeViewController *vc = [[YMAccountTimeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREENWIDTH * ROWProportion) ;
}

#pragma mark - getters and setters          - Method -

@end
