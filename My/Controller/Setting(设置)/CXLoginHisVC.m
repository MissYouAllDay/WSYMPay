

//
//  CXLoginHisVC.m
//  WSYMPay
//
//  Created by mac on 2019/5/12.
//  Copyright © 2019 赢联. All rights reserved.
//

#import "CXLoginHisVC.h"
#import "YMPublicHUD.h"
#import "LandViewController.h"  //登录
@interface CXLoginHisVC ()<UITableViewDelegate,UITableViewDataSource>

/** <#mark#> */
@property (nonatomic, strong) UITableView *tableView;

/** <#mark#> */
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation CXLoginHisVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"切换账户";
    
    self.dataArr = GET_NSUSERDEFAULT(@"LOGIN_HIS");
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"login_his"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"login_his"];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *loginName = self.dataArr[indexPath.row];
    NSString *message = [NSString stringWithFormat:@"您确定要切换登录名为：%@ 的用户吗？",loginName];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self userSignOut:loginName];
    }];
    
    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)userSignOut:(NSString *)changeTel
{
    [[YMUserInfoTool shareInstance] removeUserInfoFromSanbox];
    
    LandViewController * landVC     = [[LandViewController alloc]init];
    landVC.loginName = changeTel;
    landVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:landVC animated:NO];

}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
