//
//  YMAllVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/8.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllVC.h"
#import "YMAllTableViewCell.h"
#import "YMCollectionModel.h"
#import "YMAllBillVC.h"
#import "YMCollectionVC.h"
#import "PromptBoxView.h"
#import "FirstRealNameCertificationViewController.h"

@interface YMAllVC ()<UITableViewDelegate,UITableViewDataSource,YMAllTableViewCellDelegate,PromptBoxViewDelegate>
@property (nonatomic, strong) UITableView * gtableView;
@property (nonatomic, strong) NSArray * allData;
@property (nonatomic, retain) UIView * headerV;
@property (nonatomic, strong) PromptBoxView *promptBoxView;

@end

@implementation YMAllVC
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
    self.navigationItem.title = @"全部应用";
    self.view.backgroundColor = VIEWGRAYCOLOR;
    [self.gtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets=UIEdgeInsetsMake(0, 0, 0, 0);
    }];

}
-(NSArray *)allData
{
    if (!_allData) {
        
        NSArray * section1 = @[
                               @{@"title":@"银行卡",@"imgName":@"银行卡_all",@"nextVC":@"YMMyBankCardController"},
                               @{@"title":@"转账",@"imgName":@"转账_all",@"nextVC":@"YMTransferVC"},
                               @{@"title":@"信用卡还贷",@"imgName":@"信用卡还贷_all",@"nextVC":@""},
                               @{@"title":@"账单",@"imgName":@"账单_all",@"nextVC":@"YMAllBillVC"},
                               @{@"title":@"收支明细",@"imgName":@"收支明细_all",@"nextVC":@""},
                               @{@"title":@"我要收款",@"imgName":@"我要收款_all",@"nextVC":@"YMCollectionVC"}
                               
                               ];
        
        NSArray * section2 = @[
                               @{@"title":@"手机充值",@"imgName":@"手机充值_all",@"nextVC":@"YMMobileRechargeVC"},
                               @{@"title":@"便民缴费",@"imgName":@"便民缴费_all",@"nextVC":@"YMEasyPaymentVC"}
                               ];
        
        NSArray * section3 = @[
                               @{@"title":@"新手特惠",@"imgName":@"新手特惠_all",@"nextVC":@""},
                               @{@"title":@"房屋理财",@"imgName":@"房屋理财_all",@"nextVC":@""}
                               
                               ];
        
        NSArray * section4 = @[
                               @{@"title":@"房租小贷",@"imgName":@"房租小贷_all",@"nextVC":@""},
                               @{@"title":@"有名分期",@"imgName":@"有名分期_all",@"nextVC":@""}
                               ];
        
        NSArray * section5 = @[
                               @{@"title":@"港韩购",@"imgName":@"港韩购_all",@"nextVC":@""},
                               @{@"title":@"生活客",@"imgName":@"生活客_all",@"nextVC":@""},
                               @{@"title":@"飞机票",@"imgName":@"飞机票_all",@"nextVC":@""},
                               @{@"title":@"火车票",@"imgName":@"火车票_all",@"nextVC":@""},
                               @{@"title":@"加油卡",@"imgName":@"加油卡_all",@"nextVC":@""},
                               @{@"title":@"违章缴费",@"imgName":@"违章缴费_all",@"nextVC":@""},
                               @{@"title":@"停车缴费",@"imgName":@"停车缴费_all",@"nextVC":@""},
                               @{@"title":@"娱乐充值",@"imgName":@"娱乐充值_all",@"nextVC":@""}
                               
                               ];
        
       
        
        _allData = @[
                     @{
                           @"title":@"资金",
                           @"function":[YMCollectionModel mj_objectArrayWithKeyValuesArray:section1]
                           },
                     @{
                           @"title":@"生活",
                           @"function":[YMCollectionModel mj_objectArrayWithKeyValuesArray:section2]
                         },
                     @{
                         @"title":@"理财",
                         @"function":[YMCollectionModel mj_objectArrayWithKeyValuesArray:section3]
                         
                         },
                     @{
                         @"title":@"信贷",
                         @"function":[YMCollectionModel mj_objectArrayWithKeyValuesArray:section4]
                         
                         },
                     @{
                         @"title":@"第三方服务",
                         @"function":[YMCollectionModel mj_objectArrayWithKeyValuesArray:section5]
                         
                         },
                     
                     
                     
                     ];
    }
    return _allData;
}
-(UITableView *)gtableView
{
    if (!_gtableView) {
        _gtableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _gtableView.scrollEnabled = YES;
        _gtableView.tableFooterView = [UIView new];
        _gtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _gtableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_gtableView];
        _gtableView.delegate = self;
        _gtableView.dataSource = self;
//        _gtableView.estimatedRowHeight = SCREENWIDTH/4;
//        _gtableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    
    return _gtableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return self.allData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifer = [NSString stringWithFormat:@"YMAllTableViewCell%ld",indexPath.row];//唯一标识，相当于不复用
    YMAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell  = [YMAllTableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic = self.allData[indexPath.row];
    NSString * title = dic[@"title"];
    NSArray * modelArr = dic[@"function"];
    cell.titleStr = title;
    cell.modelArr = modelArr;
    cell.delegate = self;
    return cell;
   
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary * dic = self.allData[indexPath.row];
    NSArray * modelArr = dic[@"function"];
    
    NSInteger x = modelArr.count/4;
    NSInteger y = modelArr.count%4;
    if (y!=0) {
        x= x+1;
    }
    return  x*SCREENWIDTH/4 + HEADERSECTIONVIEW_HEIGHT;
}
-(void)didChangeCell:(UITableViewCell *)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //未登录
    if (![YMUserInfoTool shareInstance].loginStatus) {
        [MBProgressHUD showText:@"请您登陆"];
        return ;
    }
    //未实名
    if ([YMUserInfoTool shareInstance].usrStatus == -1) {
        [self.promptBoxView show];
        return;
    }
    
    
    NSIndexPath * cellPath = [self.gtableView indexPathForCell:cell];
    
    NSDictionary * dic = self.allData[cellPath.row];
    NSArray * modelArr = dic[@"function"];
    YMCollectionModel * model = modelArr[indexPath.item];
    NSString * nextVCTitle = model.nextVC;
    if (nextVCTitle.length > 0) {
        Class vc = NSClassFromString(nextVCTitle);
        UIViewController * vC = [[vc alloc] init];
        [self.navigationController pushViewController:vC animated:YES];
        return;
        
    }
  
    [MBProgressHUD showText:MSG0];
}
#pragma mark - PromptBoxViewDelegate(未实名弹框代理)
-(void)promptBoxViewLeftButttonDidClick:(PromptBoxView *)promptBoxView
{
}

-(void)promptBoxViewRightButtonDidClick:(PromptBoxView *)promptBoxView
{
    FirstRealNameCertificationViewController * firstCerVC = [[FirstRealNameCertificationViewController alloc] init];
    [self.navigationController pushViewController:firstCerVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
