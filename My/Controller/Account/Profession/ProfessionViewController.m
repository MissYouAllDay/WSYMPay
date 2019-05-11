//
//  ProfessionViewController.m
//  WSYMPay
//
//  Created by 赢联 on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "ProfessionViewController.h"
#import "YMUserInfoTool.h"
#import "RequestModel.h"
#import "YMResponseModel.h"
@interface ProfessionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ProfessionViewController

- (UITableView *)myTable{
    if (_myTable == nil) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT- 64) style:UITableViewStyleGrouped];
        _myTable.delegate = self;
        _myTable.dataSource = self;
        _myTable.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        _myTable.tableFooterView = [[UIView alloc]init];
    }
    return _myTable;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getProfession];
    [self setUI];
}

- (void)setUI{
    
    self.navigationItem.title = @"职业";
    [self.view addSubview:self.myTable];
}

- (void)getProfession{
    [MBProgressHUD showMessage:@"加载中..."];
    RequestModel *params = [[RequestModel alloc]init];
    params.token         = [YMUserInfoTool shareInstance].token;
    params.tranCode      = GETOCCUPATIONINFO;
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        YMLog(@"%@",responseObject);
        if (m.resCode == 1) {
            
            self.dataArray = responseObject[@"data"][@"list"];
            [self.myTable reloadData];
            
        } else {
            
            [MBProgressHUD showText:m.resMsg];
        }
        
        
    } failure:^(NSError *error) {}];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEADERSECTION_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDTH*ROWProportion;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1.0];
        cell.textLabel.font = [UIFont systemFontOfMutableSize:14];
        
        NSString  *jobStr   = self.dataArray[indexPath.row][@"usrJob"];
        NSInteger  jobTag   = [self.dataArray[indexPath.row][@"jobKey"] integerValue];
        
        cell.textLabel.text = jobStr;
        cell.tag            = jobTag;
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *usrJod = [_dataArray objectAtIndex:indexPath.row][@"usrJob"];
    
    if (_changeBlock) {
        _changeBlock(usrJod);
    }
    [MBProgressHUD showMessage:@"信息更新中"];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    
    RequestModel *params  = [[RequestModel alloc]init];
    params.token          = currentInfo.token;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    params.usrJobOpt      = [NSString stringWithFormat:@"%ld",(long)cell.tag];
    params.tranCode       = CHANGEOCCUPATION;
    
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1) {
            [MBProgressHUD hideHUD];
            [YMUserInfoTool shareInstance].usrJob = usrJod;
            [currentInfo saveUserInfoToSanbox];
            [currentInfo refreshUserInfo];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            [MBProgressHUD showText:responseObject[@"resMsg"]];
        }
    } failure:^(NSError *error) {}];
    
}


@end
