//
//  YMTransferMoneyLimitVC.m
//  WSYMPay
//
//  Created by pzj on 2017/5/3.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferMoneyLimitVC.h"
#import "YMTransferMoneyLimitTool.h"
#import "YMMyHttpRequestApi.h"

@interface YMTransferMoneyLimitVC ()
@property (nonatomic, strong) YMTransferMoneyLimitTool *tableViewTool;
@end

@implementation YMTransferMoneyLimitVC
#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
//    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - privateMethods               - Method -
- (void)initViews
{
    self.view.backgroundColor = VIEWGRAYCOLOR;
    self.title = @"限额说明";
    self.tableView.delegate   = [self tableViewTool];
    self.tableView.dataSource = [self tableViewTool];
}
- (void)loadData   
{
//    WEAK_SELF;
//    [YMMyHttpRequestApi loadHttpRequestWithTransferToBankMoneyLimitSuccess:^(NSMutableArray *array) {
//        STRONG_SELF;
//        [strongSelf tableViewTool].dataArray = array;
//        [strongSelf.tableView reloadData];
//    } failure:^{
//        
//    }];
}
#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -
- (YMTransferMoneyLimitTool *)tableViewTool
{
    if (!_tableViewTool) {
        _tableViewTool = [[YMTransferMoneyLimitTool alloc] initWithTableView];
        _tableViewTool.tableView = self.tableView;
    }
    return _tableViewTool;
}

@end
