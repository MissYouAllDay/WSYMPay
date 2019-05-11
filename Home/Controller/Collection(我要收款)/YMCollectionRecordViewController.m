//
//  YMCollectionRecordViewController.m
//  WSYMPay
//
//  Created by PengCheng on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import "YMCollectionRecordViewController.h"
#import "YMHomeHttpRequestApi.h"
#import "YMCollectionBaseListModel.h"
#import "YMRecordHeaderView.h"
#import "YMRecordTableViewCell.h"
#import "YMQueryRecordViewController.h"

@interface YMCollectionRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *queryButton;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recordDataArray;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@end

@implementation YMCollectionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收款记录";
    self.view.backgroundColor = VIEWGRAYCOLOR;
    _recordDataArray = [[NSMutableArray alloc] init];
    [self requestCollectRecordData];
    [self initWithYMCollectionRecordView];
}
- (void)initWithYMCollectionRecordView{
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.queryButton];
    [self.headerView addSubview:self.descLabel];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setBackgroundColor:VIEWGRAYCOLOR];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}
- (void)requestCollectRecordData{
    WEAK_SELF;
    [weakSelf.recordDataArray removeAllObjects];
    RequestModel *params = [[RequestModel alloc] init];
    params.tranCode = BILLLISTCODE;
    params.token = [YMUserInfoTool shareInstance].token;
    params.tranTypeSel = @"6";
    params.beginDate = self.startDate;
    params.endDate = self.endDate;
    [YMHomeHttpRequestApi loadParams:params HttpRequestWithCollectionSuccess:^(NSMutableArray *array) {
        weakSelf.recordDataArray = array;
        [self.tableView reloadData];
    }];
}
#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.recordDataArray.count;//self.recordDataArray.count
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELLINDIFITERONE = @"CELLINDIFITERONE";
    YMRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLINDIFITERONE];
    if (!cell) {
        cell = [[YMRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLINDIFITERONE];
    }
    YMCollectionBaseListModel *model = self.recordDataArray[indexPath.section];
    cell.descLabel.text = model.orderMsg;
    cell.timeLabel.text = model.ordTime;
    cell.moneyLabel.text = [model.txAmt decryptAESWithKey:AESKEYS];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YMRecordHeaderView *view = [[YMRecordHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    view.backgroundColor = VIEWGRAYCOLOR;
    YMCollectionBaseListModel *model = self.recordDataArray[section];
    view.dateLabel.text = [NSString stringWithFormat:@"日期 %@", model.ordDate];
//    view.totalCountLabel.text = @"收款笔数";
//    view.totalMoneyLabel.text = @"共计";
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - view
- (UIView *)headerView{
    if (_headerView==nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 140)];
    }
    return _headerView;
}
- (UIButton *)queryButton{
    if (_queryButton==nil) {
        _queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _queryButton.frame = CGRectMake(SCREENWIDTH-110, 10, 100, 20);
        _queryButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_queryButton setTitle:@"自定义查询" forState:UIControlStateNormal];
        [_queryButton setImage:[UIImage imageNamed:@"收款码自定义"] forState:UIControlStateNormal];
        [_queryButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_queryButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_queryButton addTarget:self action:@selector(queryAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _queryButton;
}
- (void)queryAction{
    YMQueryRecordViewController *vc = [[YMQueryRecordViewController alloc] init];
    vc.queryDateBlock = ^(NSString * _Nonnull startDate, NSString * _Nonnull endDate) {
        self.startDate = startDate;
        self.endDate = endDate;
        [self requestCollectRecordData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (UILabel *)descLabel{
    if (_descLabel==nil) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.queryButton.frame)+10, SCREENWIDTH, 100)];
        _descLabel.numberOfLines = 0;
        _descLabel.text = @"每一笔收款记录着你的g付出和努力\n今天请继续加油";
        _descLabel.textColor = [UIColor grayColor];
        _descLabel.font = [UIFont systemFontOfSize:15];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.backgroundColor = [UIColor whiteColor];
    }
    return _descLabel;
}
@end
