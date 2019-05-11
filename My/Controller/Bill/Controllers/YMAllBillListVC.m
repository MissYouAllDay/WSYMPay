//
//  YMAllBillListVC.m
//  WSYMPay
//
//  Created by pzj on 2017/7/20.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillListVC.h"
#import "YMAllBillListCell.h"
#import "YMSearchView.h"
#import "YMCustomFooter.h"
#import "YMCustomHeader.h"
#import "YMAllBillDetailVC.h"
#import "YMExpenditureDetailsController.h"//账户提现，账户充值进入的详情vc

#import "YMMyHttpRequestApi.h"
#import "RequestModel.h"
#import "YMAllBillListEndWantModel.h"
#import "YMAllBillListDataListModel.h"

@interface YMAllBillListVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) YMSearchView *searchView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIBarButtonItem *cancelButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, copy) NSString *keyWords;//关键词
@property (nonatomic, copy) NSString *tranTypeSel;//交易类型
@property (nonatomic, assign) NSInteger pageNum;//页数默认1
@property (nonatomic, assign) NSInteger numPerPag;//每页显示条数默认20
@property (nonatomic, strong) NSMutableArray *allDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation YMAllBillListVC
//
//#pragma mark - lifeCycle                    - Method -
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self initView];
//    [self setupRefresh];
//    [self loadNotification];
//    [self.tableView.mj_header beginRefreshing];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//- (void)dealloc
//{
//    [WSYMNSNotification removeObserver:self name:WSYMRefreshUserInfoNotification object:nil];
//}
//#pragma mark - privateMethods               - Method -
//- (void)initView
//{
//    self.view.backgroundColor = VIEWGRAYCOLOR;
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
//    self.tableView.hidden = YES;
//    self.keyWords = @"";
//    self.pageNum = 1;
//    self.numPerPag = 20;
//}
//- (void)loadData
//{
//    [self.dataArray removeAllObjects];
//    NSString *transTypeSelStr = @"";
//    if (self.billType == BillConsume) {//1消费
//        transTypeSelStr = @"1";
//    }else if (self.billType == BillAccountRecharge){//2充值
//        transTypeSelStr = @"2";
//    }else if (self.billType == BillAccountWithDrawal){//3提现
//        transTypeSelStr = @"3";
//    }else if (self.billType == BillAccountTransfer){//4转账
//        transTypeSelStr = @"4";
//    }else if (self.billType == BillMobilePhoneRecharge){//5手机充值
//        transTypeSelStr = @"5";
//    }else if (self.billType == BillCollect){//6我要收款
//        transTypeSelStr = @"6";
//    }
//    RequestModel *params = [[RequestModel alloc] init];
//    params.tranTypeSel = transTypeSelStr;
//    params.pageNum = [NSString stringWithFormat:@"%ld",self.pageNum];
//    params.numPerPag = [NSString stringWithFormat:@"%ld",self.numPerPag];
//    params.keyWords = self.keyWords;
//    WEAK_SELF;
//    [YMMyHttpRequestApi loadHttpRequestWithBillList:params success:^(NSMutableArray *array, YMAllBillListModel *model) {
//        STRONG_SELF;
//        [strongSelf.tableView.mj_header endRefreshing];
//        [strongSelf.tableView.mj_footer endRefreshing];
//        strongSelf.backgroundView.hidden = YES;
//        strongSelf.tableView.hidden = NO;
//        
//        if (array.count > 0) {
//            if (strongSelf.pageNum>1) {
//                [strongSelf.allDataArray addObjectsFromArray:array];
//            }else{
//                [strongSelf.allDataArray removeAllObjects];
//                strongSelf.tableView.mj_footer.hidden = array.count>19?NO:YES;
//                strongSelf.allDataArray = array;
//            }
//        }else{
//            if (strongSelf.pageNum>1) {
//                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//            }else{
//                strongSelf.backgroundView.hidden = NO;
//                strongSelf.tableView.hidden = YES;
//            }
//        }
//        strongSelf.dataArray = [YMAllBillListEndWantModel getDataArray:strongSelf.allDataArray];
//        [strongSelf.tableView reloadData];
//    } failure:^(NSError *error) {
//        STRONG_SELF;
//        [strongSelf.tableView.mj_header endRefreshing];
//        [strongSelf.tableView.mj_footer endRefreshing];
//    }];
//    
//}
//-(void)setNavigationItem
//{
//    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
//}
//-(void)setupRefresh
//{
//    self.tableView.mj_header = [YMCustomHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeadRefresh)];
//    self.tableView.mj_footer = [YMCustomFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFootRefresh)];
//}
//-(void)tableViewHeadRefresh
//{
//    self.pageNum = 1;
//    [self loadData];
//}
//
//-(void)tableViewFootRefresh
//{
//    self.pageNum ++;
//    [self loadData];
//}
///**
// 每个分区中的cell个数
// */
//- (NSInteger)getItemCount:(NSInteger)section
//{
//    NSInteger count = 0;
//    if (self.dataArray.count>0) {
//        YMAllBillListEndWantModel *listModel = self.dataArray[section];
//        count = [listModel getListArrayCount];
//    }
//    return count;
//}
///**
// 每个分区header
// */
//- (NSString *)getHeaderStr:(NSInteger)section
//{
//    NSString *str = @"";
//    if (self.dataArray.count>0) {
//        YMAllBillListEndWantModel *listModel = self.dataArray[section];
//        str = [listModel getDateString];
//    }
//    return str;
//}
///**
// 每个分区中的cell对应的model
// */
//- (YMAllBillListDataListModel *)getDetailsModelSection:(NSUInteger)section row:(NSInteger)row
//{
//    YMAllBillListDataListModel *model;
//    if (self.dataArray.count>0) {
//        YMAllBillListEndWantModel *listModel = self.dataArray[section];
//        NSMutableArray *listArray = [listModel getListArray];
//        if (listArray.count>0) {
//            model = listArray[row];
//        }
//    }
//    return model;
//}
//
//#pragma mark - eventResponse                - Method -
//-(void)rightBarButtonItemDidClick
//{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择类型" preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"消费" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.billType = 0;
//        self.keyWords = nil;
//        [self.tableView.mj_header beginRefreshing];
//    }];
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"转账" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.billType = 1;
//        self.keyWords = nil;
//        [self.tableView.mj_header beginRefreshing];
//    }];
//    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"账户提现" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.billType = 2;
//        self.keyWords = nil;
//        [self.tableView.mj_header beginRefreshing];
//    }];
//    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"账户充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.billType = 3;
//        self.keyWords = nil;
//        [self.tableView.mj_header beginRefreshing];
//    }];
//    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
//    [alertController addAction:action1];
//    [alertController addAction:action2];
//    [alertController addAction:action3];
//    [alertController addAction:action4];
//    [alertController addAction:action5];
//    [self presentViewController:alertController animated:YES completion:nil];
////    self.leftBarButtonItem  = self.navigationItem.leftBarButtonItem;
////    self.navigationItem.leftBarButtonItem = nil;
////    self.navigationItem.hidesBackButton = YES;
////    [self.searchBar becomeFirstResponder];
////    self.navigationItem.titleView = self.searchBar;
////    self.navigationItem.rightBarButtonItem = self.cancelButtonItem;
////    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
////    [self setNavigationBarTitntColor:RGBColor(239, 239, 239) titleColor:nil];
////    [self.searchView show];
//}
//-(void)cancelBtnDidClick
//{
//    [self hideSearchView];
//}
//-(void)hideSearchView
//{
//    self.navigationItem.leftBarButtonItem  = self.leftBarButtonItem;
//    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
//    self.navigationItem.titleView = nil;
//    [self.searchView hide];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [self setNavigationBarTitntColor:NAVIGATIONBARCOLOR titleColor:nil];
//}
//
//#pragma mark - notification                 - Method -
//- (void)loadNotification
//{
//    [WSYMNSNotification addObserver:self selector:@selector(refreshTableView) name:WSYMRefreshUserInfoNotification object:nil];
//}
//- (void)refreshTableView
//{
//    [self loadData];
//}
//#pragma mark - customDelegate               - Method -
//
//#pragma mark - objective-cDelegate          - Method -
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.dataArray.count;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self getItemCount:section];
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellID = @"YMAllBillListCell";
//    YMAllBillListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil) {
//        cell = [[YMAllBillListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
//    YMAllBillListDataListModel *billListModel = [self getDetailsModelSection:indexPath.section row:indexPath.row];
//    cell.model = billListModel;
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    return 156/2;//高度不需要适配
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50/2;
//}
//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50/2)];
//    headView.backgroundColor = VIEWGRAYCOLOR;
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFTSPACE, 0, SCREENWIDTH-LEFTSPACE*2, 50/2)];
//    titleLabel.text = [self getHeaderStr:section];
//    titleLabel.textColor = FONTCOLOR;
//    titleLabel.font = [UIFont systemFontOfMutableSize:12];
//    [headView addSubview:titleLabel];
//    return headView;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    YMAllBillListDataListModel *billListModel = [self getDetailsModelSection:indexPath.section row:indexPath.row];
//    YMAllBillDetailVC *detailVC = [[YMAllBillDetailVC alloc] init];
//    if (self.billType == BillConsume) {//消费
//        
//        if ([[billListModel getTranTypeStr]isEqualToString:@"1"]) {//消费---扫一扫超级收款码
//            detailVC.billDetailType = BillDetailConsumeScan;//消费---扫一扫超级收款码
//            
//        }else if ([[billListModel getTranTypeStr]isEqualToString:@"2"]){//手机充值时
//            
//            detailVC.billDetailType = BillDetailConsumeMobilePhoneRecharge;//消费---手机话费充值
//        }
//        
//    }else if (self.billType == BillAccountTransfer){//转账
//        
//        detailVC.billDetailType = BillDetailAccountTransfer;//转账(我要收款/ 扫一扫有名收款码)
//        
//    }else if (self.billType == BillMobilePhoneRecharge){//手机充值
//        
//        detailVC.billDetailType = BillDetailConsumeMobilePhoneRecharge;//消费---手机话费充值
//        
//    }else if (self.billType == BillCollect){//收款账单（我要收款界面进入的）
//        
//        detailVC.billDetailType = BillDetailAccountTransfer;//转账(我要收款/ 扫一扫有名收款码)
//        
//    }else if (self.billType == BillAccountRecharge){//账户充值
//        
//        detailVC.billDetailType = BillDetailAccountRecharge;
//        
//    }else if (self.billType == BillAccountWithDrawal){//账户提现
//        
//        detailVC.billDetailType = BillDetailAccountWithDrawal;
//        
//    }
//    detailVC.billListModel = billListModel;
//    [self.navigationController pushViewController:detailVC animated:YES];
//    
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    self.keyWords             = searchBar.text;
//    searchBar.text            = nil;
//    [self hideSearchView];
//    [self.tableView.mj_header beginRefreshing];
//}
//
//#pragma mark - getters and setters          - Method -
//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//    }
//    return _tableView;
//}
//- (NSMutableArray *)allDataArray
//{
//    if (!_allDataArray) {
//        _allDataArray = [[NSMutableArray alloc] init];
//    }
//    return _allDataArray;
//}
//- (NSMutableArray *)dataArray
//{
//    if (!_dataArray) {
//        _dataArray = [[NSMutableArray alloc] init];
//    }
//    return _dataArray;
//}
//
//-(YMSearchView *)searchView
//{
//    if (!_searchView) {
//        _searchView = [[YMSearchView alloc]init];
//        _searchView.columns = @[@"消费",@"账户充值",@"账户提现",@"转账"];
//        WEAK_SELF;
//        _searchView.columnBtnClick = ^(NSInteger index) {
//            weakSelf.billType = index;
//            [weakSelf hideSearchView];
//            weakSelf.keyWords    = nil;
//            [weakSelf.tableView.mj_header beginRefreshing];
//        };
//    }
//    return _searchView;
//}
//-(UIBarButtonItem *)cancelButtonItem
//{
//    if (!_cancelButtonItem) {
//        UIButton *cancelBtn = [[UIButton alloc]init];
//        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [cancelBtn setTitleColor:RGBColor(83, 83, 83) forState:UIControlStateNormal];
//        [cancelBtn addTarget:self action:@selector(cancelBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
//        cancelBtn.size = [cancelBtn.titleLabel sizeThatFits:CGSizeMake(50, 40)];
//        _cancelButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
//    }
//    return _cancelButtonItem;
//}
//
//-(UISearchBar *)searchBar
//{
//    if (!_searchBar) {
//        _searchBar = [[UISearchBar alloc]init];
//        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
//        _searchBar.tintColor = NAVIGATIONBARCOLOR;
//        _searchBar.placeholder = @"请输入关键字搜索";
//        _searchBar.delegate = self;
//    }
//    return _searchBar;
//}
//
//-(UIBarButtonItem *)rightBarButtonItem
//{
//    if (!_rightBarButtonItem) {
//        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"screen"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemDidClick)];
//    }
//    return _rightBarButtonItem;
//}
//
//-(UIImageView *)backgroundView
//{
//    if (!_backgroundView) {
//        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata"]];
//        backgroundView.hidden   = YES;
//        backgroundView.centerX  = SCREENWIDTH * 0.5;
//        backgroundView.centerY  = SCREENHEIGHT * 0.5 - 64;
//        [self.view insertSubview:backgroundView atIndex:0];
//        _backgroundView = backgroundView;
//    }
//    return _backgroundView;
//}
//
//- (void)setBillType:(BillType)billType
//{
//    _billType = billType;
//    switch (_billType) {
//        case BillConsume:
//        {
//            self.title = @"消费";
//            [self setNavigationItem];
//        }
//            break;
//        case BillAccountRecharge:
//        {
//            self.title = @"账户充值";
//            [self setNavigationItem];
//        }
//            break;
//        case BillAccountWithDrawal:
//        {
//            self.title = @"账户提现";
//            [self setNavigationItem];
//        }
//            break;
//        case BillAccountTransfer:
//        {
//            self.title = @"转账";
//            [self setNavigationItem];
//        }
//            break;
//        case BillCollect:
//        {
//            self.title = @"收款账单";
//        }
//            break;
//        case BillMobilePhoneRecharge:
//        {
//            self.title = @"手机充值记录";
//        }
//            break;
//        default:
//            break;
//    }
//}

@end
