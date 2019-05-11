//
//  YMPrepaidCardController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/2.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMPrepaidCardController.h"
#import "YMMYPrepaidCardController.h"
#import "YMPrepaidCardRechargeController.h"
#import "YMUserInfoTool.h"
#import "YMMyHttpRequestApi.h"
#import "PromptBoxView.h"
#import "FirstRealNameCertificationViewController.h"

@interface YMPrepaidCardController ()<PromptBoxViewDelegate>
@property (nonatomic, strong) PromptBoxView *promptBoxView;
@end

@implementation YMPrepaidCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"有名预付卡";
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.tableView.tableFooterView = [[UIView alloc]init];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType   = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    //字体大小/颜色
    cell.textLabel.textColor       = RGBColor(169, 169, 169);
    
//    UIView *lineView = [[UIView alloc]init];
//    lineView.backgroundColor = LAYERCOLOR;
//    [cell.contentView addSubview:lineView];
//    
//    lineView.x = 0;
//    lineView.width = SCREEN_WIDTH;
//    lineView.height = 1;
//    lineView.y = (SCREENWIDETH * ROWProportion) -1;
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"预付卡充值";
    } else {
    
        cell.textLabel.text = @"我的预付卡";
        
        [self setSeparatorFrameToZero:cell];
        
    }
    
    return cell;
}

-(void)setSeparatorFrameToZero:(UITableViewCell *)cell
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return (SCREENWIDTH * ROWProportion);
 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        
        YMMYPrepaidCardController *myPrepaidCardVC = [[YMMYPrepaidCardController alloc]init];
        [self.navigationController pushViewController:myPrepaidCardVC animated:YES];
        
    } else {
        YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
        if (currentInfo.usrStatus == -1) {
            [self.promptBoxView show];
            return;
        }else if(currentInfo.usrStatus == 2 || currentInfo.usrStatus == 1 || currentInfo.usrStatus == -2 || currentInfo.usrStatus == 3){
            YMPrepaidCardRechargeController *prepaidCardRechargeVC = [[YMPrepaidCardRechargeController alloc]init];
            [self.navigationController pushViewController:prepaidCardRechargeVC animated:YES];        }
    }
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
